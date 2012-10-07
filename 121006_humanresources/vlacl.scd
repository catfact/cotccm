/*Routine {
	~vladelbuf0 = Buffer.alloc(s, s.sampleRate * 8.0, 1);
//	~vladelbuf1 = Buffer.alloc(s, s.sampleRate * 8.0, 1);
	~vladelbuf2 = Buffer.alloc(s, s.sampleRate * 8.0, 1);

2.0.wait;

SynthDef.new(\vladelsh, {arg in=1, dry=1.0, out=0, amp=1.0,
	windowdown=0.05, windowup=0.05, dispdown=0.025, dispup=0.025,
	deldown = 8.0,   
//	delup = 4.0,
	deldry = 2.0,
	feedback = 0.1,
	buf0, buf1, buf2;
	
	var input, down, up, drydel, output;
	
	input = SoundIn.ar(in) + LocalIn.ar(1);
	input = input + LPF.ar(FreeVerb.ar(input.distort, 0.5, 1.0, 1.0), 4600);
	input = input + LPF.ar(FreeVerb.ar(input, 0.5, 1.0, 1.0), 4600);
	
	down = PitchShift.ar(input, windowdown, 0.5, timeDispersion:dispdown);
	//up = PitchShift.ar(input, windowdown, 2.0, timeDispersion:dispup);
	down = BufDelayL.ar(buf0, down, 4.0, [deldown, deldown * 0.5]);
//	delup = LFPulse.ar(0.25 / delup, 0, 0.5, 0.5, 0.5);
//	up = BufDelayL.ar(buf1, up, 4.0, [delup, delup*0.25]) * 0.25;
	drydel = BufDelayL.ar(buf2, input* dry, 4.0, [deldry, deldry * 0.5]);
	output = down + drydel + (input * dry);
	LocalOut.ar(HPF.ar(LPF.ar(Mix.new(drydel + down), 3000), 10) * feedback);
	Out.ar(out, Pan2.ar(output));
}).send(s);

1.0.wait;

~vladel = Synth.new(\vladelsh, [	
	\buf0, ~vladelbuf0.bufnum,
//	\buf1, ~vladelbuf1.bufnum,
	\buf2, ~vladelbuf2.bufnum
], s);

}.play;

*/

Routine {
	
~vladelbuf = Buffer.alloc(s, s.sampleRate * 16.0);
s.sync;
~vladel_s = Synth.new(\bufdelay_fb, [\in, c.in_b.index + 1, \out, c.in_b.index + 1, \buf, ~vladelbuf.bufnum, \feedback, -9.dbamp, \delaytime, 0.5], c.ig, \addToTail);

~vla_out_s = Synth.new( \pan, [\in, c.in_b.index + 1, \out, c.out_b], c.og, \addToHead);

~vladel_r = Routine {inf.do { arg i;
	~vladel_s.set(\delaytimelag, (i * 3) % 4);
	~vladel_s.set(\delaytime, ( ( ( (i * 6) % 9) + 1)));
	(((i * 13) % 14)).wait;
} }.play;

}.play;