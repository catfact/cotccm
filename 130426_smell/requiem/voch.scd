Routine {

	SynthDef.new(\echo_rlpf_shift_dist, {
		arg in=0, 
		out=0,
		buf=0,
		amp = 1.0, amplag = 1.0,
		inputamp = 1.0,
		delaytime= 1.0,
		feedback = 0.0,
		hz=9000, rq=0.8,
		hzlag, rqlag,
		fmix = 0.5,
		fmixlag = 2.0,
		shift=0.5,
		shiftmix = 0.5,
		shiftwin = 0.25,
		shiftdisp = 0.1,
		shiftlag = 0.01,
		distmix;

		var delay, os;

		hz = Lag.kr(hz, hzlag);
		rq = Lag.kr(rq, rqlag);
		amp = Lag.kr(amp, amplag);
		fmix = Lag.kr(fmix, fmixlag);
		shift = Lag.kr(shift, shiftlag);

		delay = BufDelayL.ar(buf, (SoundIn.ar(in) * inputamp) + (LocalIn.ar(1)), delaytime) * amp;
		os = delay * (1.0 - shiftmix) + (shiftmix * PitchShift.ar(delay, shiftwin, shift));
		os = (1.0 - distmix) * os + (distmix * os.distort.distort.distort.softclip);
		os = (1.0 - fmix)*os + (fmix * RLPF.ar(os, hz, rq) );
		LocalOut.ar(os * feedback);
		Out.ar(out, (os * amp));
	}).send(s);
	
	
	~vochlen = 32.0;
	~nvoch = 8;
	~voch_buf = Array.fill(~nvoch, { Buffer.alloc(s, s.sampleRate * ~vochlen); });

	s.sync;

	~voch_s = ~voch_buf.collect({ arg buf, i;
		Synth.new(\echo_rlpf_shift_dist, [
			\in, 0,
			\out, 0,
			\buf, buf,
			\amp, 0.0,
			\shift, 1.0,
			\feedback, -3.dbamp,
			\distmix, 0.5,
			\delaytime, 0.0625 * ( i + 1),
			\hzlag, 5.0,
			\rqlag, 5.0
		], s );
	});

}.play;

/*
~voch_s.do({ arg syn; syn.free; });
*/