~driftdrag_ok = false;

/*
	Server.killAll;
*/
// s = Server.local;
// s.boot;

s.waitForBoot { Routine {
	
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
	}).send(s);
	
	
	SynthDef.new(\grainer, { 
		arg buf, in=0, out=0,
		delay=1.0, amp=0.1, amplag = 30.0,
		grainRate = 1.0, 
		grainHz =  8.0,
		grainDur = 0.25,
		posRate = 0.25,
		pre=0.5;
	
		var input, output,
		frames, sr,
		trig, pos;
	
		frames = BufFrames.kr(buf);
		sr = SampleRate.ir;
		
		input = In.ar(in);
		trig = Impulse.kr(grainHz);
		
		RecordBuf.ar(input, buf, preLevel:pre, loop:1);
		pos = LFTri.kr(posRate / BufDur.kr(buf));
		
		output = GrainBuf.ar(sndbuf:buf, trigger:trig, pos:pos, dur:grainDur, rate:grainRate);
		amp = Lag.kr(amp, amplag);
		Out.ar(out, output.dup * amp);
	}).send(s);

	
	SynthDef.new(\patch2, { arg in, out, level=1.0;
		Out.ar(out, In.ar([in, in+1]) * level);
	}).send(s);
	
	SynthDef.new(\patch_split, { arg in, out, level=1.0;
		Out.ar(out, In.ar(in).dup * level);
	}).send(s);
	
	//// busses
	~drag_out_b = Bus.audio(s, 2);
	~out_g = Group.new(s, \addToTail);
	
	
	////// buffers
	~fft_in_buf = Buffer.alloc(s, 2048, 1);
	~fft_proc_buf = Array.fill(8, {Buffer.alloc(s, 2048, 1)});
	
	~vla_grainbuf_1 = Buffer.alloc(s, s.sampleRate * 10.0, 1);
	~vla_grainbuf_2 = Buffer.alloc(s, s.sampleRate * 10.0, 1);
	~vla_grainbuf_3 = Buffer.alloc(s, s.sampleRate * 10.0, 1);
	
	~vocode_delbuf = Buffer.alloc(s, s.sampleRate * 10.0);
	
	s.sync;
	
	
	~fft_proc_bufnum = ~fft_proc_buf.collect({arg buf; buf.bufnum });
	~fft_proc_bufnum.postln;
	
	
	////////// IO synths
	~drag_out_s = Synth.new(\patch2, [\in, ~drag_out_b.index, \out, 0], ~out_g);

	
	/////// spectral freeze synth
	~freeze 		= Array.fill(8, 1.0); //[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~amp 		= Array.fill(8, 0.0); //[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
	~amplag 		= Array.fill(8, 1.0); //[5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0];
	~stretch		= Array.fill(8, 1.0); //[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~shift		= Array.fill(8, 1.0); //[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~stretchlag 	= Array.fill(8, 1.0); //[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~shiftlag 	= Array.fill(8, 0.0625); // [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~pan 		= Array.fill(8, 0.0); //Array.series(8, -1, (2/7));
	~panlag 		= Array.fill(8, 1.0); // [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	
	~freezer_s = Synth.new(\specfreeze_shift_8, [
		\in, ~vla_in_b.index,
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
		\panlag, ~panlag,
		\out, ~drag_out_b.index,
	], ~in_g, \addAfter);
	
	~snapshot = { arg which; Routine {
		~freeze[which] = 0; ~freezer_s.set(\freeze, ~freeze);
		0.1.wait;
		~freeze[which] = 1; ~freezer_s.set(\freeze, ~freeze);
	}.play; };
	
	~setamp = { arg which, amp;
		~amp[which] = amp;
		~freezer_s.set(\amp, ~amp);
	};
	
	~setamplag = { arg which,lag;
		~amplag[which] = lag;
		~freezer_s.set(\amplag, ~amplag); 
	};
	
	// schedeule spectral snapshots
	~amp_thresh = -40.dbamp;
	~snap_p = 0.25;
	~snap_r = Routine {
		var specIdx = 0;
		inf.do({
			~vla_amp_b.get({ arg amp;
				amp.postln;
				if(amp > ~amp_thresh, {
					postln("snap");
					~snapshot.value(specIdx);
					specIdx = (specIdx + 1) % 8;
				});
			});
			~snap_p.wait;
		});
	}.play;
	
	// schedule oscilator chnages
	~specamp_p = 1.5;
	~specamp_r = Routine { 
		var specIdx = 0;
		inf.do({ arg i;
			postln(["amp", specIdx]);
			if((~amp[specIdx] > 0.0) && ((specIdx%2) > 0)  , {
				~setamp.value(specIdx, 0.0);
			}, {
				~setamp.value(specIdx, 2.0);
			});
			specIdx = (specIdx + 3) % 8;
			~shift[specIdx] = 0.5 + (0.5 * (i%2));
			~freezer_s.set(\shift, ~shift);
			~amp.postln;
			~specamp_p.wait; // spectral playback period
		});
	}.play;
	
	// grains
	~vla_grain1_s = Synth.new(\grainer, [
		\in, ~vla_in_b.index, \out, ~drag_out_b.index,
		\buf, ~vla_grainbuf_1.bufnum,
		\grainRate, 1.0,
		\posRate, 0.25,
		\amp, 0.0,
		\amplag, 60.0,
	], ~in_g, \addAfter);
	~vla_grain1_s.set(\amp, 2.0);
	~vla_grain1_s.set(\posRate, 0.2);
	
	
	// grains
	~vla_grain2_s = Synth.new(\grainer, [
		\in, ~vla_in_b.index, \out, ~drag_out_b.index,
		\buf, ~vla_grainbuf_2.bufnum,
		\grainRate, 1.5,
		\posRate, 0.3,
		\amp, 0.0,
		\amplag, 80.0,
	], ~in_g, \addAfter);
	~vla_grain2_s.set(\amp, 2.0);
	~vla_grain2_s.set(\posRate, 0.32);
	~vla_grain2_s.set(\grainHz, 10);
	
	
	// grains
	~vla_grain3_s = Synth.new(\grainer, [
		\in, ~vla_in_b.index, \out, ~drag_out_b.index,
		\buf, ~vla_grainbuf_3.bufnum,
		\grainRate, 2.0,
		\posRate, 0.2,
		\amp, 0.0,
		\amplag, 120.0,
	], ~in_g, \addAfter);
	~vla_grain3_s.set(\amp, 2.0);
	~vla_grain3_s.set(\grainHz, 12);
	
	/// mic delay / vocoder
	~vocodemic = {
		var vocode, mic, del;
		mic = In.ar(~mic_in_b.index);
		del = BufDelayL.ar(~vocode_delbuf.bufnum, mic, 5.0, 5.0);
		vocode = Vocoder.ar(In.ar(~drag_out_b.index, 1), del, 32, low:880, hpfscale:0.1);
		Out.ar(0, vocode);
	}.play(~out_g, \addBefore);
	
	~mic_del_s.set(\delaytime, 2.5);
	~mic_del_s.set(\amp, 0.3);
	~mic_del_s.set(\fb, 0.3);
	~mic_del_s.set(\filtermix, 1.0);
	~mic_del_s.set(\hz, 880 * 2);
	~mic_del_s.set(\rq, 0.2);
	
	~driftdrag_end = {
		~snap_r.stop;
		~specamp_r.stop;
		~freezer_s.free;
		~mic_del_s.free;
		~vla_grain1_s.free;	
		~vla_grain2_s.free;	
		~vla_grain3_s.free;
		~vocodemic.free;
		~fft_in_buf.free;
		~fft_proc_buf.do([arg buf; buf.free; });
	
		~vla_grainbuf_1.free;
		~vla_grainbuf_2.free;
		~vla_grainbuf_3.free;
	
		~vocode_delbuf.free;

	};

}.play; };