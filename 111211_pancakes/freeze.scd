Routine {
	SynthDef.new(\specfreeze_shift_8, {
		arg in=0, out=0, buf=0,
		lpf=3000,
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
		output = LPF.ar(output, lpf);
		Out.ar(out, output);
	}).store;
	
	0.1.wait;
	
	~fft_in_buf = Buffer.alloc(s, 2048, 1);
	~fft_proc_buf = Array.fill(8, {Buffer.alloc(s, 2048, 1)});
	
	0.2.wait;
	
	~fft_proc_bufnum = ~fft_proc_buf.collect({arg buf; buf.bufnum });
//	~fft_proc_bufnum.postln;
	
	~freeze 		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	//~amp 		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] * (-12.dbamp);
	~amp 		= [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
	~amplag 		= [30.0, 30.0, 30.0, 30.0, 60.0, 60.0, 10.0, 60.0];
	~stretch		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~shift		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~stretchlag 	= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~shiftlag 	= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~pan 		= Array.series(8, -1, (2/7));
	~panlag 		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	
	~ctx.postln;
	
	~freezer_s = Synth.new(\specfreeze_shift_8, [
		\in, ~gr_b.index,
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
	], ~gr_g, \addAfter);
	
	~snapshot = { arg which; Routine {
		~freeze[which] = 0; ~freezer_s.set(\freeze, ~freeze);
		0.1.wait;
		~freeze[which] = 1; ~freezer_s.set(\freeze, ~freeze);
	}.play; };
	
	~freezetaps = Array.fill(8, {CfTapper.new});
}.play;

