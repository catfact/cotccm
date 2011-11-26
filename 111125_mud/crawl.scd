Routine {
	SynthDef.new(\multicomp, {
		arg in=0, out=0, amp=0.24,
		mix=1.0;
		var sig, dry;
		sig = In.ar(in);
		
/*		sig = Normalizer.ar(sig, 1.0, [0.1, 0.15]);
		sig = Normalizer.ar(sig, 1.0, [0.2, 0.25]);
		sig = Normalizer.ar(sig, 1.0, [0.3, 0.35]);
*/		
		dry = [sig, sig];
		sig = [LPF.ar(sig, 1000), HPF.ar(sig, 1000)];
		sig = Compander.ar(sig, sig, thresh:(-24.dbamp), slopeAbove:0.05, slopeBelow:1, clampTime: 0.01, relaxTime: 0.01);
		sig = Mix.new(sig);
		sig = sig * 15.0;
		sig = Compander.ar(sig, sig, thresh:([-16.dbamp, -18.dbamp]), slopeAbove:0.05, slopeBelow:1, clampTime: [0.01, 0.02], relaxTime: [0.01, 0.02]);
		sig = sig * 6.0;
		sig = sig*mix + (dry*(1.0-mix));
		Out.ar(out, amp * sig);
	}).store;
	
	SynthDef.new(\patch_adc_mono, { arg in, out, level=1.0;
		Out.ar(out, SoundIn.ar(in) * level);
	}).store;
	
	SynthDef.new(\patch_pan, {arg in, out, pan=0.0, level=1.0;
		Out.ar(out, Pan2.ar(In.ar(in) * level, pan));
	}).store;
	
	SynthDef.new(\patch_sum, {arg in, out, level=1.0;
		Out.ar(out, Mix.new(In.ar(in, 2) * level));
	}).store;
	
	SynthDef.new(\patch_stereo, {arg in, out, level=1.0;
		Out.ar(out, In.ar(in, 2) * level);
	}).store;
	
	0.1.wait;
	
	~ig = Group.new(s);
	~xg = Group.after(~ig);
	~og = Group.after(~og);	
	
	~mic_in_b = Bus.audio(s, 2);
	~mic_in_s = Synth.new(\patch_adc_mono, [\in, 0, \out, ~mic_in_b.index], ~ig);	
	0.1.wait;
	
	~crawl_in_b = Bus.audio(s, 2);
	~crawl_out_b = Bus.audio(s, 2);
	
	// nomralizer splits mono to stereo
	~crawl_norm = Synth.new(\multicomp, [\in, ~mic_in_b.index, \out, ~crawl_in_b.index], ~ig, \addAfter);
	~crawl_norm.set(\mix, 0.5);
		~crawl_norm.set(\amp, 0.15);
	
	~pedals_in_b = Bus.audio(s, 1);
	~pedals_in_s = [
		Synth.new(\patch_adc_mono, [\in, 4, \out, ~pedals_in_b.index], ~ig), 
		Synth.new(\patch_adc_mono, [\in, 5, \out, ~pedals_in_b.index], ~ig), 
	];
	
	~pedals_crawl_patch = Synth.new(\patch_pan, [\in, ~pedals_in_b.index, \out, ~crawl_in_b.index], ~ig, \addAfter);
	~pedals_output_patch = Synth.new(\patch_pan, [\in, ~pedals_in_b.index, \out, 0], ~og, \addAfter);
	
	~crawl_output_patch = Synth.new(\patch_stereo, [\in, ~crawl_out_b.index, \out, 0], ~og);
	~crawl_output_patch.set(\level, -14.dbamp);
	~crawl_pedal_patch = Synth.new(\patch_stereo, [\in, ~crawl_out_b.index, \out, 2], ~og);
	
	0.1.wait;
	
	~crawl_bottom = Array.fill(8, {
		Crawl.new(s, ~xg, ~crawl_in_b.index, ~crawl_out_b.index);
	});
	
	~crawl_top = Array.fill(8, {
		Crawl.new(s, ~xg, ~crawl_in_b.index, ~crawl_out_b.index);
	});
	
	0.1.wait;
	
	~crawl_top.do({ arg crawl; crawl.rate = 0.5; });
}.play;