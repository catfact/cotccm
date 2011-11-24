s = Server.local.waitForBoot { Routine {
	
	SynthDef.new(\rec, {
		arg in=0, buf, loop=1, run=1, pre=0.0;
		RecordBuf.ar(In.ar(in), buf, run:run, loop:loop, preLevel:pre);
	}).send(s);
	
	SynthDef.new(\adc, {
		arg in=0, out=0, amp=1.0, amplag=10.0;
		Out.ar(out, SoundIn.ar(in) * amp.lag(amplag));
	}).send(s);
	
	
	SynthDef.new(\inFb, {
		arg in=0, out=0, amp=0.0, amplag=10.0;
		Out.ar(out, InFeedback.ar(in) * amp.lag(amplag));
	}).send(s);
	
	SynthDef.new(\pulsegrain, {
		arg out=0, buf, 
			amp=0.25, amplag=1.0,
			hz=4.0, rate=1.0, dur=4, posrate;
		var trig, pos, grain;
		amp = amp.lag(amplag);
		trig = Impulse.ar(hz);
		pos = LFTri.kr(posrate).linlin(-1, 1, 0, 0.99);
		grain = GrainBuf.ar(1, trig, dur/hz, buf, rate, pos);
		Out.ar(out, grain*amp);
	}).send(s);
	
	~grain_in_b = Bus.audio(s, 1);
	~grainbuf = Buffer.alloc(s, s.sampleRate * 16.0, 1);
	
	s.sync;
	
	~grainspecs = [
		(pitch:2.0, hz:8.0, posrate:1/4, amp:0.1, lag:10.0),
		(pitch:2, hz:7.0, posrate:1/3, amp:0.1, lag:14.0),
		(pitch:4, hz:6, posrate:2/5, amp:0.1, lag:18.0),
		(pitch:2, hz:5.0,  posrate:2/7, amp:0.1, lag:20.0),
		(pitch:3, hz:12.0,  posrate:2/9, amp:0.1, lag:24.0),
		(pitch:4, hz:13.0,  posrate:1/8, amp:0.1, lag:30.0),
		(pitch:1, hz:14.0,  posrate:1/5, amp:0.1, lag:33.0),
		(pitch:2, hz:16.0,  posrate:1/6, amp:0.1, lag:36.0)
	];
	
	~grain_g = Group.new(s);
	~in_g = Group.before(~grain_g);
	
	~grain_s = ~grainspecs.collect({ arg spec;
		spec.postln;
		Synth.new(\pulsegrain, [
			\buf, ~grainbuf.bufnum,
			\hz, spec.hz *2,
			\dur, 8,
			\rate, spec.pitch, 
			\amp, spec.amp,
			\amplag, spec.lag * 2,
			\posrate, spec.posrate
		], ~grain_g);
	});
	
	~grain_rec_s = Synth.new(\rec, [\buf, ~grainbuf.bufnum,\in, ~grain_in_b.index], ~in_g, \addAfter);
	~in_s = Array.fill(2, {|i| Synth.new(\adc, [\in, i, \out, ~grain_in_g], ~in_g); });
	~fb_s = Synth.new(\inFb, [\in, 0, \out, ~grain_in_b.index, \amp, 0.5], ~in_g);
	
	~quadOnFuncs[0] = { ~grain_g.set(\amp, 0.3); };
	~quadOffFuncs[0] = { ~grain_g.set(\amp, 0.0); };
	
	~quadOnFuncs[1] = { ~grain_rec_s.set(\run, 1); };
	~quadOffFuncs[1] = { ~grain_rec_s.set(\run, 0); };
	
	~quadOnFuncs[2] = { ~in_s[1].set(\amp, 1); };
	~quadOffFuncs[2] = { ~in_s[1].set(\amp, 0); };
	
	
	~quadOnFuncs[3] = { ~fb_s.set(\amp, 1.0); };
	~quadOffFuncs[3] = { ~fb_s.set(\amp, 0.0); };
	
}.play; };
	