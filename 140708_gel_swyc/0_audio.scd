//s.options.memSize = 8192 * 128;
s = Server.default;
//s.options.memSize = 2 ** 20; // 512 MB
//s.options.device = "Tapco USB Interface";

s.waitForBoot { Routine {
	
	SynthDef.new(\adc, { arg in, out, level=1.0;
		Out.ar(out, SoundIn.ar(in) * level);
	}).send(s);
	
	SynthDef.new(\patch, { arg in, out, level=1.0;
		Out.ar(out, In.ar(in) * level);
	}).send(s);
	
	SynthDef.new(\amplitude, { arg in=0, out=0;
		Out.kr(out, Amplitude.kr(In.ar(in)));
	}).send(s);
	
	SynthDef.new(\pitch, { arg in=0, out=0;
		Out.kr(out, Pitch.kr(In.ar(in)));
	}).send(s);
	
	s.sync;
	
	// groups
	~in_g = Group.new(s);
	
	// busses
	~mic_in_b    = Bus.audio(s, 1);
	~vla_in_b    = Bus.audio(s, 1);
	~vla_amp_b   = Bus.control(s, 1);
	~vla_pitch_b = Bus.control(s, 1);
	
	// synths
	~mic_in_s    = Synth.new(\adc, [\in, 0, \out, ~mic_in_b.index], ~in_g);
	~vla_in_s    = Synth.new(\adc, [\in, 1, \out, ~vla_in_b.index], ~in_g);
	~vla_amp_s   = Synth.new(\amplitude, [\in, ~vla_in_b.index, \out, ~vla_amp_b.index], ~in_g, \addAfter);
	~vla_pitch_s = Synth.new(\pitch, [\in, ~vla_in_b.index, \out, ~vla_pitch_b.index], ~in_g, \addAfter);
	
}.play; };