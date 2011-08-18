s = Server.local.waitForBoot { Routine {
		
	SynthDef.new(\adc, {
		arg in=0, out=0;
		Out.ar(out, SoundIn.ar(in));
	}).send(s);
		
	SynthDef.new(\buf_phasor, {
		arg buf, out, rate=1.0;
		Out.ar(out, Phasor.ar(0, rate * BufRateScale.kr(buf), 0.0, BufFrames.kr(buf)));
	}).send(s);
	
	SynthDef.new(\bufwr_mono, {
		arg in, buf, phasebus;
		BufWr.ar(In.ar(in, 1), buf, In.ar(phasebus, 1));
	}).send(s);
	
	SynthDef.new(\gr, {
		arg in=0, out=0, buf,
			rate=4.0, pitch=1.0, dur=0.5,
			phasebus, del=1.0,
			amp=1.0, amplag=10.0,
			posrate=2.0, pan=0.0;
		var trig, gr, pos, postrig, bufFrames;
		trig = Impulse.ar(rate);
		bufFrames = BufFrames.kr(buf);
		pos = (In.ar(phasebus) - (del * SampleRate.ir)).wrap(0, bufFrames) / bufFrames;
		postrig = LFPulse.ar(posrate, 0, 0.5);
		pos = Latch.ar(pos, postrig);
		amp = Lag.kr(amp, amplag);
		gr = BufGrain.ar(trig, dur, buf, pitch, pos, 2, amp);
		Out.ar(out, Pan2.ar(gr, pan));
	}).send(s);
	
	
	~vlgr_n = 8;
	~vlgr_l = 20.0;
	
	~vlin_b = Bus.audio(s, 1);
	~vlin_s = Synth.new(\adc, [\in, 1, \out, ~vlin_b.index], s);

	~vlgr_buf = Array.fill(~vlgr_n, { Buffer.alloc(s, s.sampleRate * ~vlgr_l, 1) });
	
	s.sync;
	
	~vlgr = Array.fill(~vlgr_n, { arg i;
		var grev = Event.new;
		grev.phase_b =  Bus.audio(s, 1);
		grev.phase_s = Synth.new(\buf_phasor, [\buf, ~vlgr_buf[i].bufnum, \out, grev.phase_b.index], ~vlin_s, \addAfter);
		grev.bufwr_s = Synth.new(\bufwr_mono, [\buf, ~vlgr_buf[i].bufnum, \phasebus, grev.phase_b.index, \in, ~vlin_b.index], grev.phase_s, \addAfter);
		grev.bufwr_s.run(false);
		grev.gr1 = Synth.new(\gr, [\buf, ~vlgr_buf[i].bufnum, \phasebus, grev.phase_b.index, \rate, 3.0, \posrate, 0.75, \dur, 1.5], ~bufwr_s, \addAfter);
		grev.gr2 = Synth.new(\gr, [\buf, ~vlgr_buf[i].bufnum, \phasebus, grev.phase_b.index, \rate, 2.0, \pitch, 0.5, \posrate, 0.5, \dur, 2.0], ~bufwr_s, \addAfter);
		grev.gr1.set(\amp, 0);
		grev.gr2.set(\amp, 0);
		grev
	});
	
	
	~vlgrdat = Event.new;
	~vlgrdat.cur = 7;
	~vlgrdat.time = Array.fill(~vlgr_n, {~vlgr_l * 0.75});
	~vlgrdat.tlast = SystemClock.seconds;
	
	~vlgr_r = nil;
	~vlgr_playEvent = { arg i;
		var i_1 = (i - 1).wrap(0, ~vlgr_n - 1);
		var i4 = (i+4).wrap(0, ~vlgr_n - 1);
		var i3 = (i+3).wrap(0, ~vlgr_n - 1);
		var time = ~vlgrdat.time[i_1];
		i = i.wrap(0, ~vlgr_n - 1);
		~vlgr[i].gr1.set(\amplag, time);
		~vlgr[i].gr2.set(\amplag, time);
		~vlgr[i].gr1.set(\amp, 1.0);
		~vlgr[i].gr2.set(\amp, 1.0);
		~vlgr[i_1].gr1.set(\amplag, time);
		~vlgr[i_1].gr2.set(\amplag, time);
		~vlgr[i_1].gr1.set(\amp, 0.0);
		~vlgr[i_1].gr2.set(\amp, 0.0);
		~vlgr[i4].gr1.set(\amplag, time);
		~vlgr[i4].gr2.set(\amplag, time);
		~vlgr[i4].gr1.set(\amp, 1.0);
		~vlgr[i4].gr2.set(\amp, 1.0);
		~vlgr[i3].gr1.set(\amplag, time);
		~vlgr[i3].gr2.set(\amplag, time);
		~vlgr[i3].gr1.set(\amp, 0.0);
		~vlgr[i3].gr2.set(\amp, 0.0);
		~vlgr_monome.msg('/grid/led/row', [0, 1, (1 << i.asInteger) | (1 << i4.asInteger)]);
		time
	};
	
	~vlgr_monome = MonomeGridApp.new(
		name:"vlgr", 
		monomeInitAction:{ arg app;
			app.ctx.keyResponder = MonomeResponder.new(
				filter:(
					\id:{arg id; id.asSymbol == app.id.asSymbol},
					\cmd:'/grid/key'
				),
				function:{ arg r, e;
					//e.postln;
					if (e.c > 0, {
						if(e.a != ~vlgrdat.cur, {
							~vlgr[~vlgrdat.cur].bufwr_s.run(false);
							~vlgrdat.cur = e.a;
							~vlgr[~vlgrdat.cur].bufwr_s.run(true);
							app.msg('/grid/led/row', [0, 0, 1 << (e.a).asInteger]);
							~vlgrdat.time[(e.a - 1).wrap(0, ~vlgr_n - 1)] = SystemClock.seconds - ~vlgrdat.tlast;
							~vlgrdat.tlast = SystemClock.seconds;
						}, {
							postln("stop recording!");
							~vlgr[~vlgrdat.cur].bufwr_s.run(false);
							app.msg('/grid/led/row', [0, 0, 0]);
						});
						
						if (~vlgr_r.isNil, {
							~vlgr_r = Routine { inf.do({ arg i;
								(~vlgr_playEvent.value(i) * 2).wait;
							}) }.play;
						});
					});
					
				}
			);
		}
	);
	
	1.0.wait;
	{ ~vlgr_monome.recallConnection; }.defer;
	0.5.wait;
	~vlgr_monome.msg('/grid/led/all', [0]);
}.play; };