s = Server.default;
//s.options.memSize = 8192 * 4;
s.waitForBoot { Routine {

	SynthDef.new(\patch, {arg in, out, amp=1.0, amplag=1.0;
		amp = Lag.kr(amp, amplag);
		Out.ar(out, In.ar(in) * amp);
	}).store;
	
	
	SynthDef.new(\adc, {arg in, out, amp=1.0, amplag=1.0;
		amp = Lag.kr(amp, amplag);
		Out.ar(out, SoundIn.ar(in) * amp);
	}).store;
	
		
	SynthDef.new(\fb_rlpf, {
		arg in=0, out=0,
			amp=0.125, hz=5000, rq=0.5,
			amplag=0.1, hzlag=0.1, rqlag=0.1;
			
		var sig;
		
		amp = Lag.kr(amp, amplag);
		hz= Lag.kr(hz, hzlag);
		rq = Lag.kr(rq, rqlag);
		
		sig = InFeedback.ar(in, 1);
		sig = RLPF.ar(sig, hz, rq);
		
		Out.ar(out, sig * amp);
	}).store;
	
	s.sync;
	
	~gran_g = Group.new(s);
	~in_g = Group.before(~gran_g);
	~out_g = Group.after(~gran_g);
	
	~gran_in_b = Array.fill(6, { Bus.audio(s, 1); });
	~gran_out_b = Array.fill(6, { Bus.audio(s, 1); });
	
	~in_s = Array.fill(6, { arg i; Synth.new(\adc, [\in, 1, \out, ~gran_in_b[i].index], ~in_g); });
	~out_s = Array.fill(6, { arg i; Synth.new(\patch, [\in, ~gran_out_b[i].index, \out, i % 2, \amp, 0.0], ~out_g); });
	
	~gran = Array.fill (6, { arg i;
		Grandel.new(s, ~gran_in_b[i].index, ~gran_out_b[i].index, ~gran_g, \addToTail);
	});
	
	0.01.wait;
	
	~gran[0].rate = 0.5;
	~gran[0].dur = 8.0;
	~gran[0].wait = 1.5;
	~gran[0].attack = 0.25;
	~gran[0].release = 0.25;
	~gran[0].deltime = 2.0;

	~gran[1].rate = 0.5;
	~gran[1].dur = 3.0;
	~gran[1].wait = 0.25;
	~gran[1].attack = 0.25;
	~gran[1].release = 0.25;
	~gran[1].deltime = 0.5;

	~gran[2].rate = 1.0;
	~gran[2].dur = 8.0;
	~gran[2].wait = 1.5;
	~gran[2].attack = 0.25;
	~gran[2].release = 0.25;
	~gran[2].deltime = 2.0;

	~gran[3].rate = 1.0;
	~gran[3].dur = 3.0;
	~gran[3].wait = 0.25;
	~gran[3].attack = 0.25;
	~gran[3].release = 0.25;
	~gran[3].deltime = 0.5;
	
	~gran[4].rate = 2.0;
	~gran[4].dur = 8.0;
	~gran[4].wait = 1.5;
	~gran[4].attack = 0.25;
	~gran[4].release = 0.25;
	~gran[4].deltime = 2.0;

	~gran[5].rate = 2.0;
	~gran[5].dur = 3.0;
	~gran[5].wait = 0.25;
	~gran[5].attack = 0.25;
	~gran[5].release = 0.25;
	~gran[5].deltime = 0.5;

	~fb = Array.fill(6, { arg i;
		Synth.new(\fb_rlpf, [
			\in, ~gran_out_b[i].index,
			\out, ~gran_in_b[(i+1) % 6].index,
			\amp, 0.0,
			\amplag, 4.0,
			\rqlag, i + 1,
			\hzlag, (i*2) + 1,
			\hz, 800 * (1.5 ** i),
			\rq, 0.4
		], ~in_g, \addBefore);
	});
	
	
	~fb.do({arg syn;
		syn.set(\amp, -24.dbamp);
		syn.set(\rq, 0.8);
	});
	
	
	///////// hid and gui
	Routine {
	~gw = SCWindow.new("_g");
	~gw.front;
	
	~switch = 0;
	~switchtap = CfTapper.new;
	
	~switch_func = { arg val; 
		"footswitch".postln;
		if(val > 0, {
			postln("press");
			~switchtap.tap;
		}, {
			postln("lift");
			if(~switch > 0, {
				postln("turning off");
				~switchtap.tap;
				~out_g.set(\amplag, ~switchtap.time);
				~out_g.set(\amp, 0.0);
				~switch = 0;
				{ ~gw.view.background = Color.black; }.defer;
			}, {
				postln("turning on");
				~switchtap.tap;
				~out_g.set(\amplag, ~switchtap.time);
				~out_g.set(\amp, 0.1);
				~switch = 1;
				{ ~gw.view.background = Color.red; }.defer;
			});
			("switch "++val).postln;
		});
	};

	}.play(AppClock);
	//////
	
}.play; };	


/*
~gran_in_b[0].scope;
~gran_out_b[0].scope;
*/