SynthDef.new(\patch_fb, {arg in=0, out=0, amp=1, amplag = 0.01;
	var sig;
	amp = Lag.kr(amp, amplag);
	sig = InFeedback.ar(in);
	Out.ar(out, sig * amp);
}).send(s);

~echo_loop_patch = Synth.new(\patch_fb, [\in, ~del_out_b.index, \out, ~loop_in_b.index], ~rg, \addBefore);