//s = Server.default;
s.waitForBoot { Routine {

// -- synthdefs
SynthDef.new(\patch, { arg in = 0, out=0, amp = 1.0, amplag = 0.01;	Out.ar(out, In.ar(in) * Lag.kr(amp, amplag));
}).send(s);

SynthDef.new(\patch_stereo, { arg in = 0, out	=0, amp = 1.0, amplag = 0.01;	Out.ar(out, In.ar(in, 2) * Lag.kr(amp, amplag));
}).send(s);

SynthDef.new(\fangs_vla, {arg in=1, dry=1.0, out=0, amp=1.0,
	hzdown=800, hzup=440, rqdown=0.25, rqup=0.25,
	deldown = 60/76 * 1.5,   
	delup = 60/76 * 0.75,
	deldry = 60/76 * 0.25;
	
	var input, down, up, drydel;
	
	input = SoundIn.ar(in);
	
	input = input + LPF.ar(FreeVerb.ar(input.distort, 0.5, 1.0, 1.0), 4600);
	
	down = RLPF.ar(input, hzdown, rqdown);
	up = RLPF.ar(input, hzup, rqup);
	down = DelayL.ar(down, 4.0, [deldown, deldown * 0.5]) * 0.25;
	delup = LFPulse.ar(0.25 / delup, 0, 0.5, 0.5, 0.5);
	up = DelayL.ar(up, 4.0, [delup, delup*0.25]) * 0.125;
	drydel = DelayL.ar(input* dry, 4.0, [deldry, deldry * 0.5]);
	Out.ar(out, Pan2.ar(up + down + drydel + (input * dry)) * amp);
}).send(s);


SynthDef.new(\fangs_vox, {
	arg in=0, out=0, amp=1.0,
	verb_mix=0.24, verb_room=0.8, verb_damp=1.0, verb_lpf=4000,
	delaydc = 0.002,
	delaytime = 60/76,
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

	del = DelayL.ar(comp, 3.0, delaytime);
	del = LPF.ar((del + DC.ar(delaydc)).softclip, delaylpf) * delayamp;

	verb = FreeVerb.ar(comp + del, 1.0, verb_room, verb_damp);
	verb = LPF.ar(verb, verb_lpf);
	output = comp * (1.0 - verb_mix) + (verb * verb_mix);
	
	Out.ar(out, Pan2.ar(output * amp));
}).send(s);


s.sync;

~fangs_out_b = Bus.audio(s, 2);
~fangs_out_s = Synth.new(\patch_stereo, [\in, ~fangs_out_b.index, \out, 0], s);

~fangs_vla = Synth.new(\fangs_vla, [\out, ~fangs_out_b.index, \amp, -8.dbamp], ~fangs_out_s, \addBefore);

// already got the god vox
~fangs_vox = Synth.new(\fangs_vox, [\out, ~fangs_out_b.index], s, \addToHead);

//~fangs_vla.set(\deldown, 2.5);
//~fangs_vla.set(\delup, 1.25);
//~fangs_vla.set(\deldry, 1.0);
~fangs_vox.set(\amp, 2.dbamp);
}.play; };