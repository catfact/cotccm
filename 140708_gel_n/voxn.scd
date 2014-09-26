
/*

Compander.ar(in, control, thresh, slopeBelow, slopeAbove, 

clampTime, relaxTime, mul, add)


*/

Routine {

SynthDef.new(\comp1, { 
	arg inSignal=0, inControl=0, out=0,
	predelay=0.125,
	amp = 6.dbamp,
	thresh = -12.dbamp,
	slopeBelow = 1.0,
	slopeAbove = 0.25,
	clampTime = 0.01,
	relaxTime = 0.05,
	gatethresh = -32.dbamp,
	fb = 0.2;

	var sig, del;

	sig = In.ar(inSignal);

	del = DelayL.ar(sig, 1.0, predelay) + LocalIn.ar(1) * fb;
	LocalOut.ar(del);
	
	sig = sig + del;

	sig = Compander.ar(sig, In.ar(inControl),
		thresh, slopeBelow, slopeAbove, 
		clampTime, relaxTime);

	//	sig = Compander.ar(sig, sig, gatethresh, 0.0);

	Out.ar(out, sig.dup * amp);

}).send(s);

s.sync;

~vox_comp = Synth.new(\comp1, [
	\inSignal, c.in_b.index, 
	\inControl, c.in_b.index, 
	\out, c.out_b,
	\gatethresh, -60.dbamp,
	\fb, 0.5,
	\predelay, 0.2
], c.ig, \addAfter);

}.play;
/*
~vox_comp.free
*/

SynthDef.new(\god_vox, {
	arg in=1, out=0, amp=1.0,
	verb_mix=0.24, verb_room=0.8, verb_damp=1.0,
	delaydc = 0.002,
	delaytime = 0.1,
	delaylpf = 1200,
	delayamp = 0.4,
	gate_thresh = 0.00001,
	gate_slope = 10.0,
	gate_clamp = 0.004, 
	gate_release = 0.05,
	comp_thresh = 0.5,
	comp_slope = 0.25,
	comp_clamp = 0.003,
	comp_release = 0.1;
	var input, gate, comp, eq, del, verb;
	
	input = SoundIn.ar(in);
	
	gate = Compander.ar(input, input, gate_thresh, gate_slope, 1.0, gate_clamp, gate_release);
	comp = Compander.ar(gate, input, comp_thresh, 1.0, comp_slope, comp_clamp, comp_release);
//	comp = Compander.ar(input, input, comp_thresh, 1.0, comp_slope, comp_clamp, comp_release);

	del = DelayL.ar(comp, 1.0, delaytime);
	del = LPF.ar((del + DC.ar(delaydc)).softclip, delaylpf) * delayamp;

	verb = FreeVerb.ar(comp + del, verb_mix, verb_room, verb_damp);
//	verb = FreeVerb.ar(input, verb_mix, verb_room, verb_damp);
//	verb = FreeVerb.ar(gate, verb_mix, verb_room, verb_damp);	
	Out.ar(out, Pan2.ar(verb * amp));
}).send(s);


~gv = Synth.new(\god_vox, [\in, 0], s);
~gv.set(\amp, -12.dbamp);
~gv.set(\verb_mix, 0.0);


~gv.free;