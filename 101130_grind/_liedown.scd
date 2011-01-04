//s = Server.default;
s.waitForBoot { Routine {

// -- synthdefs
SynthDef.new(\patch, { arg in = 0, out=0, amp = 1.0, amplag = 0.01;	Out.ar(out, In.ar(in) * Lag.kr(amp, amplag));
}).send(s);

SynthDef.new(\patch_stereo, { arg in = 0, out	=0, amp = 1.0, amplag = 0.01;	Out.ar(out, In.ar(in, 2) * Lag.kr(amp, amplag));
}).send(s);

SynthDef.new(\liedown_vla, {arg in=1, dry=1.0, out=0, amp=1.0,
	windowdown=0.05, windowup=0.05, dispdown=0.025, dispup=0.025,
	deldown = 3.0,   
	delup = 2.0,
	deldry = 1.0;
	
	var input, down, up, drydel;
	
	input = SoundIn.ar(in);
	
	input = input + LPF.ar(FreeVerb.ar(input.distort, 0.5, 1.0, 1.0), 4600);
	
	down = PitchShift.ar(input, windowdown, 0.5, timeDispersion:dispdown);
	up = PitchShift.ar(input, windowdown, 2.0, timeDispersion:dispup);
	down = DelayL.ar(down, 4.0, [deldown, deldown * 0.5]);
	delup = LFPulse.ar(0.25 / delup, 0, 0.5, 0.5, 0.5);
	up = DelayL.ar(up, 4.0, [delup, delup*0.25]) * 0.25;
	drydel = DelayL.ar(input* dry, 4.0, [deldry, deldry * 0.5]);
	Out.ar(out, Pan2.ar(up + down + drydel + (input * dry)));
}).send(s);


SynthDef.new(\liedown_vox, {
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

~liedown_out_b = Bus.audio(s, 2);
~liedown_out_s = Synth.new(\patch_stereo, [\in, ~liedown_out_b.index, \out, 0], s);

~liedown_vla = Synth.new(\liedown_vla, [\out, ~liedown_out_b.index], ~liedown_out_s, \addBefore);

~liedown_vox = Synth.new(\liedown_vox, [\out, 0], s, \addToHead);

~liedown_vla.set(\deldown, 2.5);
~liedown_vla.set(\delup, 1.25);
~liedown_vla.set(\deldry, 1.0);
//~liedown_vox.set(\amp, 2.dbamp);


~gran[0].rate = 0.5;
	~gran[0].dur = 8.0;
	~gran[0].wait = 1.5;
	~gran[0].attack = 0.25;
	~gran[0].release = 0.25;
	~gran[0].deltime = 2.0;

	~gran[1].rate = 0.5;
	~gran[1].dur = 3.0;
	~gran[1].wait = 0.25;
	~gran[1].attack = 0.25;
	~gran[1].release = 0.25;
	~gran[1].deltime = 0.5;

	~gran[2].rate = 1.0;
	~gran[2].dur = 8.0;
	~gran[2].wait = 1.5;
	~gran[2].attack = 0.25;
	~gran[2].release = 0.25;
	~gran[2].deltime = 2.0;

	~gran[3].rate = 1.0;
	~gran[3].dur = 3.0;
	~gran[3].wait = 0.25;
	~gran[3].attack = 0.25;
	~gran[3].release = 0.25;
	~gran[3].deltime = 0.5;
	
	~gran[4].rate = 2.0;
	~gran[4].dur = 8.0;
	~gran[4].wait = 1.5;
	~gran[4].attack = 0.25;
	~gran[4].release = 0.25;
	~gran[4].deltime = 2.0;

	~gran[5].rate = 2.0;
	~gran[5].dur = 3.0;
	~gran[5].wait = 0.25;
	~gran[5].attack = 0.25;
	~gran[5].release = 0.25;
	~gran[5].deltime = 0.5;
	
	~gran[6].rate = 0.25;
	~gran[6].dur = 2.0;
	~gran[6].wait = 0.25;
	~gran[6].attack = 0.25;
	~gran[6].release = 0.25;
	~gran[6].deltime = 2.5;

	~gran[7].rate = 4.0;
	~gran[7].dur = 4.0;
	~gran[7].wait = 0.25;
	~gran[7].attack = 0.25;
	~gran[7].release = 0.25;
	~gran[7].deltime = 3.0;


}.play; };