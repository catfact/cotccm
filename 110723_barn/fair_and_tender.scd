s = Server.local;
Routine.run {
	c = Condition.new;
	s.bootSync(c);
	
	/////////// defs
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
	
	s.sync(c);
	
	////////// groups, synths
	~gran_g = Group.new(s);
	~in_g = Group.before(~gran_g);
	~out_g = Group.after(~gran_g);
	
	~ngrans = 4;
	
	~gran_in_b = Array.fill(~ngrans, { Bus.audio(s, 1); });
	~gran_out_b = Array.fill(~ngrans, { Bus.audio(s, 1); });
	
	~in_s = Array.fill(~ngrans, { arg i; Synth.new(\adc, [\in, 1, \out, ~gran_in_b[i].index], ~in_g); });
	~out_s = Array.fill(~ngrans, { arg i; Synth.new(\patch, [\in, ~gran_out_b[i].index, \out, i % 2, \amp, 0.0], ~out_g); });
	
	s.sync;
	
	//////// weird classes
	g = Array.fill (~ngrans, { arg i;
		Grandel.new(s, ~gran_in_b[i].index, ~gran_out_b[i].index, ~gran_g, \addToTail);
	});
	
	m = Cf40h.new(host:"127.0.0.1", port:8080, prefix:'/box');
	r = Remains.new(s, 1, 0);

	////////// grain feedback
	
	~fb = Array.fill(~ngrans, { arg i;
		Synth.new(\fb_rlpf, [
			\in, ~gran_out_b[i].index,
			\out, ~gran_in_b[(i+1) % ~ngrans].index,
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
	
	s.sync(c);
	
	1.0.wait;
	
	///////////////// initial state
	// remains: no input
	r.in_s.set(\amp, 0.0);
	
	g.do({ arg gran, i; gran.deltime = i + 1; gran.wait = ((i*3+1)%5 +1) * 0.5; });
	
	// no echos
	/*
	r.echo_s[0].set(\level, 0);
	r.echo_s[1].set(\level, 0);
	r.echo_s[2].set(\level, 0);
	r.echo_s[3].set(\level, 0);
	*/

	
	////////////////////////// UI

	// num switches
	~nsw = 3;
	// values
	~sw = Array.with(1, 0, 0);
	// tapper machines
	~swtap = Array.fill(~nsw, { CfTapper.new; });
	~swtap.do({ arg tapper; tapper.tap; });
	
	m.pressFunctions.add(\tr -> {
		arg col, row;
		if(col==0 && row==0, {
			~swtap[0].tap;
		});
		if(col==1 && row==0, {
			// remains input toggle
			~swtap[1].tap;
		});
		if(col==2 && row==0, {
			// events
			~swtap[2].tap;
			~events.next.value(0, ~swtap[2].time);
		});
			});

	m.liftFunctions.add(\tr -> {
		arg col, row;
		if(col==0 && row==0, {
			// grain timed toggle// grain input freeze
			~swtap[0].tap;
			if (~swtap[0].time > 1.0, {
				~ngrans.do({|i|
					g[i].deltime = (~swtap[0].time * (i+1)).wrap(0.125, 180.0);
					g[i].wait = (((i*3+1)%5 +1) * ~swtap[0].time * 0.25).wrap(0.25, 2.0); });
			});
			
			~sw[0] = (~sw[0] + 1) % 2;

			if (~sw[0] > 0, {
				~ngrans.do({|i| g[i].bufwr_s.run(true) });
			}, {
				~ngrans.do({|i| g[i].bufwr_s.run(false) });
			});
			~sw.asString.postln;
		});
		if(col==1 && row==0, {
			// remains toggle
		});
		if(col==2 && row==0, {
			// events
		});
		
		//~notify.value(~sw.asString);
		//~sw.asString.postln;
	});
	
	///////////////////// EVENTS
	~events = Pseq([
		{
			~notify.value(r.in_s.set(\amp, 1.0));
		},
		{	
			~notify.value(~out_s[0].set(\amp, -16.dbamp));
		},
		{
			~notify.value(~out_s[1].set(\amp, -16.dbamp));
		},
		{
			~notify.value(~out_s[2].set(\amp, -16.dbamp));
		},
		{
			~notify.value(~out_s[3].set(\amp, -12.dbamp));
		},
		{		
			~notify.value( g[0].rate = 2.25 );
		},
		{		
			~notify.value( g[1].rate = 0.75 );
		},
		{		
			~notify.value( g[1].rate = 0.5 );
		},
		{		
			~notify.value( g[1].rate = 4/3 );
		},
		{		
			~notify.value( g[0].rate = 5/6 );
		},
		{		
			~notify.value( g[1].rate = 2/3 );
		},
		{		
			~notify.value( g[2].rate = 3/2 );
		},
		{		
			~notify.value( g[3].rate = 0.5 );
		},
		{		
			~notify.value( g[0].rate = 1.0 );
		},
	]).asStream;
	
	////// notify func	
	~notify = { arg string, color, dur=1.5;
	var win, text;
	{
		win = SCWindow.new(nil, Rect(0, 0, 800, 180));
		if(color.isNil, { color = Color.new(1.0, 1.0.rand, 1.0.rand, 0.5); });
		win.view.background = color; 
		text = SCStaticText(win, win.view.bounds);
		text.font = Font("Andale Mono", 54);
		text.string = string;
		win.front;
		string.postln;
	//	win.refresh;
		AppClock.sched(dur, {win.close; nil});
	}.defer;
};
};