~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.default;
s.waitForBoot { Routine {

	SynthDef.new(\multicomp, {
		arg in=0, out=0, amp=0.24;
		var sig;
		sig = In.ar(in);
/*		sig = Normalizer.ar(sig, 1.0, [0.1, 0.15]);
		sig = Normalizer.ar(sig, 1.0, [0.2, 0.25]);
		sig = Normalizer.ar(sig, 1.0, [0.3, 0.35]);
*/
		sig = [LPF.ar(sig, 1000), HPF.ar(sig, 1000)];
		sig = Compander.ar(sig, sig, thresh:(-24.dbamp), slopeAbove:0.05, slopeBelow:1, clampTime: 0.01, relaxTime: 0.01);
		sig = Mix.new(sig);
		sig = sig * 15.0;
		sig = Compander.ar(sig, sig, thresh:([-16.dbamp, -18.dbamp]), slopeAbove:0.05, slopeBelow:1, clampTime: [0.01, 0.02], relaxTime: [0.01, 0.02]);
		sig = sig * 6.0;
		Out.ar(out, amp * sig);
	}).store;
	
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
	0.1.wait;
	
	~crawl_in_b = Bus.audio(s, 2);
	~crawl_out_b = Bus.audio(s, 2);
	
	// nomralizer splits mono to stereo
	~crawl_norm = Synth.new(\multicomp, [\in, ~mic_in_b.index, \out, ~crawl_in_b.index], ~ig, \addAfter);
	
	~pedals_in_b = Bus.audio(s, 1);
	~pedals_in_s = [
		Synth.new(\patch_adc_mono, [\in, 4, \out, ~pedals_in_b.index], ~ig), 
		Synth.new(\patch_adc_mono, [\in, 5, \out, ~pedals_in_b.index], ~ig), 
	];
	
	~pedals_crawl_patch = Synth.new(\patch_pan, [\in, ~pedals_in_b.index, \out, ~crawl_in_b.index], ~ig, \addAfter);
	~pedals_output_patch = Synth.new(\patch_pan, [\in, ~pedals_in_b.index, \out, 0], ~og, \addAfter);
	
	~crawl_output_patch = Synth.new(\patch_stereo, [\in, ~crawl_out_b.index, \out, 0], ~og);
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
	
	
	
	//============== frezze
	
	
	//Routine {
0.2.wait;

SynthDef.new(\specfreeze_shift_8, {
	arg in=0, out=0, buf=0,
		proc_buf 		= #[1, 2, 3, 4, 5, 6, 7, 8],
		freeze 		= #[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		amp 			= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
		amplag 		= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
		stretch		= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
		shift		= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
		stretchlag 	= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
		shiftlag 		= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
		pan 			= #[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		panlag 		= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
		
	var input, output, inputchain, outputchain;
	
	stretch = Lag.kr(stretch, stretchlag);
	shift = Lag.kr(shift, shiftlag);
	input = In.ar(in);
	inputchain = FFT(buf, input);
	outputchain = PV_Copy(inputchain, proc_buf);
	outputchain = PV_Freeze(outputchain, freeze);
	outputchain = PV_BinShift(outputchain, stretch, shift);
	output = IFFT(outputchain);
	amp = Lag.kr(amp, amplag);
	pan = Lag.kr(pan, panlag);
	output = Mix.new(Pan2.ar(output*amp, pan));
	Out.ar(out, output);
}).store;

0.1.wait;

~fft_in_buf = Buffer.alloc(s, 2048, 1);
~fft_proc_buf = Array.fill(8, {Buffer.alloc(s, 2048, 1)});

1.2.wait;

~fft_proc_bufnum = ~fft_proc_buf.collect({arg buf; buf.bufnum });
~fft_proc_bufnum.postln;

~freeze 		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
~amp 		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] * (-12.dbamp);
~amp 		= [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
~amplag 		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
~stretch		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
//~shift		= [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
~shift		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
~stretchlag 	= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
~shiftlag 	= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
~pan 		= Array.series(8, -1, (2/7)); //[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
~panlag 		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];

~freezer_s = Synth.new(\specfreeze_shift_8, [
	\in, ~mic_in_b.index,
	\buf, ~fft_in_buf.bufnum,
	\proc_buf, ~fft_proc_bufnum,
	\freeze, ~freeze,
	\amp, ~amp,
	\amplag, ~amplag,
	\strech, ~stretch,
	\shift, ~shift,
	\stretchlag, ~stretchlag,
	\shiftlag, ~shiftlag,
	\pan, ~pan,
	\panlag, ~panlag
], ~in_s, \addAfter);

~snapshot = { arg which; Routine {
	~freeze[which] = 0; ~freezer_s.set(\freeze, ~freeze);
	0.1.wait;
	~freeze[which] = 1; ~freezer_s.set(\freeze, ~freeze);
}.play; };

~freezetaps = Array.fill(8, {CfTapper.new});


	x.value("_gui.scd");
	

// }.play;
	
	
	/////////////==========
	
	
	
	
	
		
}.play; };
