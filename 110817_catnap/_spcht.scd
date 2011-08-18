s = Server.local.waitForBoot { Routine {
	
	SynthDef.new(\spch, {
		arg in, out, delbuf, fftbuf,
			freeze, shift=0.0, stretch=1.0,
			shiftlag=0.1, stretchlag=0.1,
			maxdel=2.0, del=0.25,
			amp=0.5, pan=0, fb=0.0;
		var input, chain, output;
		shift = Lag.kr(shift, shiftlag);
		stretch = Lag.kr(stretch, stretchlag);
		
		input = SoundIn.ar(in) + BufDelayL.ar(delbuf, LocalIn.ar(1) * fb, del);
		chain = FFT(fftbuf, input);
		chain = PV_Freeze(chain, freeze);
		chain = PV_BinShift(chain, stretch, shift);
		output = IFFT(chain);
		Out.ar(out, Pan2.ar(output * amp, pan));
		LocalOut.ar(output, 1);
	}).send(s);
	
	~spch_fft_buf = Buffer.alloc(s, 2048, 1);
	~spch_del_buf = Buffer.alloc(s, s.sampleRate * 30.0, 1);
	
	s.sync;
	~spch_s = Synth.new(\spch, [
		\in, 0, \out, 0,
		\fftbuf, ~spch_fft_buf.bufnum,
		\delbuf, ~spch_del_buf.bufnum,
		\fb, 0.8
	], s);
	~spch_s.set(\amp, 1.0);
	
	~spch_freezebase = 2.5;
	~spch_freezemod = 2.0;
	~spch_freeze_r = Routine  { inf.do({ arg i;
		var wait = 1.0;
		~spch_s.set(\freeze, i % 2);
		wait = ~spch_freezebase - (~spch_freezemod * (i%2));
		wait.wait;
	}) }.play;
	
	~spch_rats = [1.5, 6/5, 1.0, 1.0];
	~spch_stretch_r = Routine  { inf.do({ arg i;
		var wait, lag, ratio;
		wait = (i * 27) % 4 * 0.75;
		lag = (i * 31) % 5 * 0.25;
		ratio = ~spch_rats.choose ** (((i * 43) % 3 ) - 2);
		~spch_s.set(\lag, lag);
		~spch_s.set(\stretch, ratio);
		wait.wait;
	}) }.play;
	
	~spch_tbase = 0.25;
	~spch_time_r = Routine  { inf.do({ arg i;
		var wait, time;
		wait = (i * 11) % 3 * 1.25;
		time = ~spch_tbase * ((i * 17) % 8 + 1);
		~spch_s.set(\del, time);
		wait.wait;
	}) }.play;
	
}.play; };

/*
~spch_stretch_r.stop;
~spch_time_r.stop;
~spch_freeze_r.stop;
~spch_s.free;
*/