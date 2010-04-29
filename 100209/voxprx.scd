
/*
SynthDef.new(\god_vox, {
	arg in=1, out=0, amp=1.0,
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
}).load(s);
*/

~god_vox = Synth.new(\god_vox, [\gate_thresh, -42.dbamp, \amp, 16.dbamp]);
~god_vox.set(\delaydc, 0.1);
~god_vox.set(\delaytime, 0.2);