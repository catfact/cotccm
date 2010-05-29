SynthDef.new(\multicomp, {
	arg in=0, out=0, amp=0.24;
	var sig;
	sig = In.ar(in);
	sig = Normalizer.ar(sig, 1.0, [0.1, 0.15]);
	sig = Normalizer.ar(sig, 1.0, [0.2, 0.25]);
	sig = Normalizer.ar(sig, 1.0, [0.3, 0.35]);
	Out.ar(out, amp * sig);
}).store;
	
x = Synth.new(\multicomp, [\in, ~in_b.index], ~xg);
x.set(\amp, 1.0);


x.free;