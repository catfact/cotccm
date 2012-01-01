~driftdrag_ok = false;

/*
	Server.killAll;
*/
// s = Server.local;
// s.boot;

s.waitForBoot { Routine {
	
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
	//~drift_fft_in_buf = Buffer.alloc(s, 2048, 1);
	//~drift_fft_proc_buf = Array.fill(8, {Buffer.alloc(s, 2048, 1)});
	
	~vla_grainbuf_1 = Buffer.alloc(s, s.sampleRate * 10.0, 1);
	~vla_grainbuf_2 = Buffer.alloc(s, s.sampleRate * 10.0, 1);
	~vla_grainbuf_3 = Buffer.alloc(s, s.sampleRate * 10.0, 1);
	
	~vocode_delbuf = Buffer.alloc(s, s.sampleRate * 10.0);
	
	s.sync;
	
	
	//~drift_fft_proc_bufnum = ~drift_fft_proc_buf.collect({arg buf; buf.bufnum });
	//~drift_fft_proc_bufnum.postln;
	
	
	////////// IO synths
	~drag_out_s = Synth.new(\patch2, [\in, ~drag_out_b.index, \out, 0], ~out_g);

	/*
	/////// spectral freeze synth
	~drift_freeze 		= Array.fill(8, 1.0); //[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~drift_amp 		= Array.fill(8, 0.0); //[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
	~drift_amplag 		= Array.fill(8, 1.0); //[5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0];
	~drift_stretch		= Array.fill(8, 1.0); //[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~drift_shift		= Array.fill(8, 1.0); //[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~drift_stretchlag 	= Array.fill(8, 1.0); //[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~drift_shiftlag 	= Array.fill(8, 0.0625); // [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~drift_pan 		= Array.fill(8, 0.0); //Array.series(8, -1, (2/7));
	~drift_panlag 		= Array.fill(8, 1.0); // [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	
	~driftfreeze_s = Synth.new(\specfreeze_shift_8, [
		\in, ~vla_in_b.index,
		\buf, ~drift_fft_in_buf.bufnum,
		\proc_buf, ~drift_fft_proc_bufnum,
		\freeze, ~drift_freeze,
		\amp, ~drift_amp,
		\amplag, ~drift_amplag,
		\strech, ~drift_stretch,
		\shift, ~drift_shift,
		\stretchlag, ~drift_stretchlag,
		\shiftlag, ~drift_shiftlag,
		\pan, ~drift_pan,
		\panlag, ~drift_panlag,
		\out, ~drag_out_b.index,
	], ~in_g, \addAfter);
	
	~driftsnap = { arg which; Routine {
		~drift_freeze[which] = 0; ~driftfreeze_s.set(\freeze, ~drift_freeze);
		0.1.wait;
		~drift_freeze[which] = 1; ~driftfreeze_s.set(\freeze, ~drift_freeze);
	}.play; };
	
	~setamp = { arg which, amp;
		~drift_amp[which] = amp;
		~driftfreeze_s.set(\amp, ~drift_amp);
	};
	
	~setamplag = { arg which,lag;
		~drift_amplag[which] = lag;
		~driftfreeze_s.set(\amplag, ~drift_amplag); 
	};
	*/
	
	// schedeule spectral snapshots
	~drift_amp_thresh = -40.dbamp;
	~snap_p = 0.25;
	~snap_r = Routine {
		var specIdx = 0;
		inf.do({
			~vla_amp_b.get({ arg amp;
				amp.postln;
				if(amp > ~drift_amp_thresh, {
					postln("snap");
	//				~driftsnap.value(specIdx);
					specIdx = (specIdx + 1) % 8;
				});
			});
			~snap_p.wait;
		});
	}.play;
	
	// schedule oscilator chnages
	~specamp_p = 1.5;
	
	/*
	~specamp_r = Routine { 
		var specIdx = 0;
		inf.do({ arg i;
			postln(["amp", specIdx]);
			if((~drift_amp[specIdx] > 0.0) && ((specIdx%2) > 0)  , {
				~setamp.value(specIdx, 0.0);
			}, {
				~setamp.value(specIdx, 2.0);
			});
			specIdx = (specIdx + 3) % 8;
			~drift_shift[specIdx] = 0.5 + (0.5 * (i%2));
			~driftfreeze_s.set(\shift, ~drift_shift);
			~drift_amp.postln;
			~specamp_p.wait; // spectral playback period
		});
	}.play;
	*/
	
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
	/*
	~vocodemic = {
		var vocode, mic, del;
		mic = In.ar(~mic_in_b.index);
		del = BufDelayL.ar(~vocode_delbuf.bufnum, mic, 5.0, 5.0);
		vocode = Vocoder.ar(In.ar(~drag_out_b.index, 1), del, 32, low:880, hpfscale:0.1);
		Out.ar(0, vocode);
	}.play(~out_g, \addBefore);
	*/
	~mic_del_s.set(\delaytime, 2.5);
	~mic_del_s.set(\amp, 0.3);
	~mic_del_s.set(\fb, 0.3);
	~mic_del_s.set(\filtermix, 1.0);
	~mic_del_s.set(\hz, 880 * 2);
	~mic_del_s.set(\rq, 0.2);
	
	~driftdrag_end = {
		~snap_r.stop;
		~specamp_r.stop;
		~driftfreeze_s.free;
		~mic_del_s.free;
		~vla_grain1_s.free;	
		~vla_grain2_s.free;	
		~vla_grain3_s.free;
		~vocodemic.free;
		~drift_fft_in_buf.free;
		~drift_fft_proc_buf.do({ arg buf; buf.free; });
	
		~vla_grainbuf_1.free;
		~vla_grainbuf_2.free;
		~vla_grainbuf_3.free;
	
		~vocode_delbuf.free;

	};

}.play; };