Routine {
	
	SynthDef.new(\inFb, {
		arg in=0, out=0, amp=0.0, amplag=10.0;
		Out.ar(out, InFeedback.ar(in) * amp.lag(amplag));
	}).send(s);
		
	s.sync;
	
	~grainspecs = [
		(pitch:1.0, hz:8.0, posrate:1/4, amp:0.0, lag:10.0),
		(pitch:2, hz:7.0, posrate:1/3, amp:0.0, lag:14.0),
		(pitch:4/5, hz:6, posrate:2/5, amp:0.0, lag:18.0),
		(pitch:3/2, hz:5.0,  posrate:2/7, amp:0.0, lag:20.0),
		(pitch:4/3, hz:12.0,  posrate:2/9, amp:0.0, lag:24.0),
		(pitch:3/4, hz:13.0,  posrate:1/8, amp:0.0, lag:30.0),
		(pitch:2/3, hz:14.0,  posrate:1/5, amp:0.0, lag:33.0),
		(pitch:0.5, hz:16.0,  posrate:1/6, amp:0.0, lag:36.0)
	];
	
	~bass_gr_shift_g = Group.new(c.xg);
	~vla_gr_shift_g = Group.new(c.xg);
	~bass_gr_shift_s = ~grainspecs.collect({ arg spec;
		spec.postln;
		Synth.new(\gr, [
			\in, ~bass_gr_in_b.index,
			\buf, ~bass_gr_buf2.bufnum,
			\pulserate, spec.hz *2,
			\dur, 2.0,
			\pitch, spec.pitch, 
			\amp, spec.amp,
			\amplag, spec.lag * 2,
			\posrate, spec.posrate
		], ~bass_gr_shift_g);
	});
	~vla_gr_shift_s = ~grainspecs.collect({ arg spec;
		spec.postln;
		Synth.new(\gr, [
			\in, ~vla_gr_in_b.index,
			\buf, ~vla_gr_buf2.bufnum,
			\pulserate, spec.hz * 9/8,
			\dur, 2.0,
			\pitch, spec.pitch, 
			\amp, spec.amp,
			\amplag, spec.lag * 2,
			\posrate, spec.posrate
		], ~vla_gr_shift_g);
	});
	
	~bass_fb_s = Synth.new(\inFb, [\in, c.out_b.index, \out, ~bass_gr_in_b.index, \amp, 0.0], c.ig, \addBefore);
	~vla_fb_s = Synth.new(\inFb, [\in, c.out_b.index, \out, ~vla_gr_in_b.index, \amp, 0.0], c.ig, \addBefore);
	
	~quadOnFuncs[1] = { 
		~vla_gr_shift_g.set(\amp, 0.3);
		~bass_gr_shift_g.set(\amp, 0.3);
	};
	~quadOffFuncs[1] = { 
		~vla_gr_shift_g.set(\amp, 0.0);
		~bass_gr_shift_g.set(\amp, 0.0);
	};
	
	
	~quadOnFuncs[2] = { 
		~bass_fb_s.set(\amp, 0.5);
		~vla_fb_s.set(\amp, 0.5);
	};
	~quadOffFuncs[2] = { 
		~bass_fb_s.set(\amp, 0.0);
		~vla_fb_s.set(\amp, 0.0);
	};
	
}.play;