
c = CfAudioContext.new(s, 2, { Routine {

	SynthDef.new(\vladown, {
		arg in=1, out=0, amp=0.0625,
		prelpfhz = 1000,
		postlpfhz = 1000,
		pretan = 1.0,
		posttan = 1.0,
		del = 0.25, 
		fb = 0.0625,
		octdown=1.0,
		oct2down=0.5;

		var sig, delsig;

		sig = In.ar(in);
		
		delsig = DelayN.ar(sig, 1.0, del) + (LocalIn.ar(1) * fb);
		LocalOut.ar(delsig);
		
		sig = sig + delsig;

		sig = LPF.ar(sig, prelpfhz);
		sig = sig + (sig.tanh * pretan);

		sig = sig + (PitchShift.ar(sig, 0.5) * octdown)
		+ (PitchShift.ar(sig, 0.25) * oct2down);
		
		sig = sig + (sig.tanh * posttan);
		sig = LPF.ar(sig, postlpfhz);
		
		Out.ar(out, sig.dup * amp);
		
	}).send(s);

	s.sync;

	~vladown_s = Synth.new(\vladown, [
		\in, c.in_b.index + 1,
		\out, c.out_b.index
	], c.ig, \addAfter);

	~vladown_s.set(\amp, -30.dbamp);
}.play; });