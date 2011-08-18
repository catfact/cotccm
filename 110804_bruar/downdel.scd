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

s.sync;

~liedown_out_b = Bus.audio(s, 2);
~liedown_out_s = Synth.new(\patch_stereo, [\in, ~liedown_out_b.index, \out, 0], s);

~liedown_vla = Synth.new(\liedown_vla, [\out, ~liedown_out_b.index], ~liedown_out_s, \addBefore);

~liedown_vla.set(\deldown, 2.5);
~liedown_vla.set(\delup, 1.25);
~liedown_vla.set(\deldry, 1.0);

}.play; };