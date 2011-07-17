Routine {
	SynthDef.new(\patch_adc_mono, { arg in, out, level=1.0;
		Out.ar(out, SoundIn.ar(in) * level);
	}).store;
	
	SynthDef.new(\patch_pan, {arg in, out, pan=0.0, level=1.0;
		Out.ar(out, Pan2.ar(In.ar(in), pan));
	}).store;
	
	SynthDef.new(\patch_sum, {arg in, out, level=1.0;
		Out.ar(out, Mix.new(In.ar(in, 2)));
	}).store;
	
	SynthDef.new(\patch_stereo, {arg in, out, level=1.0;
		Out.ar(out, In.ar(in, 2));
	}).store;
	
	0.1.wait;
	
	~ig = Group.new(s);
	~xg = Group.after(~ig);
	~og = Group.after(~og);	
	
	~mic_in_b = Bus.audio(s, 2);
	~mic_in_s = Synth.new(\patch_adc_mono, [\in, 0, \out, ~mic_in_b.index], ~ig);	
}.play;