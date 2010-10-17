s = Server.internal;
s.waitForBoot { Routine {

// -- synthdefs
SynthDef.new(\patch, { arg in = 0, out=0, amp = 1.0, amplag = 0.01;	Out.ar(out, In.ar(in) * Lag.kr(amp, amplag));
}).send(s);

SynthDef.new(\patch_stereo, { arg in = 0, out=0, amp = 1.0, amplag = 0.01;	Out.ar(out, In.ar(in, 2) * Lag.kr(amp, amplag));
}).send(s);

SynthDef.new(\br_vla, {arg in=1, dry=1.0, out=0, amp=1.0, windowsize=1.0, ratio=0.5;
	var input, shift;
	input = SoundIn.ar(in);
	shift = PitchShift.ar(input, windowsize, ratio);
	Out.ar(out, Pan2.ar(shift + (input * dry)));
}).send(s);


SynthDef.new(\br_vox, {
	arg in=0, out=0, amp=1.0,
	verb_mix=0.24, verb_room=0.8, verb_damp=1.0, verb_lpf=4000,
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
	
	var input, gate, comp, eq, del, verb, output;
	
	input = SoundIn.ar(in);
	
	gate = Compander.ar(input, input, gate_thresh, gate_slope, 1.0, gate_clamp, gate_release);
	comp = Compander.ar(gate, input, comp_thresh, 1.0, comp_slope, comp_clamp, comp_release);

	del = DelayL.ar(comp, 1.0, delaytime);
	del = LPF.ar((del + DC.ar(delaydc)).softclip, delaylpf) * delayamp;

	verb = FreeVerb.ar(comp + del, 1.0, verb_room, verb_damp);
	verb = LPF.ar(verb, verb_lpf);
	output = comp * (1.0 - verb_mix) + (verb * verb_mix);
	
	Out.ar(out, Pan2.ar(output * amp));
}).send(s);


s.sync;

~br_b = Bus.audio(s, 2);
~br_out = Synth.new(\patch_stereo, [\in, ~br_b.index, \out, 0], s);
~br_vla = Synth.new(\br_vla, [\out, ~br_b.index], ~br_out, \addBefore);
~br_vox = Synth.new(\br_vox, [\out, ~br_b.index], ~br_out, \addBefore);
~br_vox.set(\amp, -12.dbamp);
}.play; };