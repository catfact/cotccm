Routine {
	//~vl_buf.plot;
	~norm_buf = Buffer.alloc(s, 16 * 1.2 * s.sampleRate, 1);
	s.sync;
	~vl_buf.copyData(~norm_buf);
	s.sync;
	~norm_buf.normalize;
	s.sync;
	//~norm_buf.plot;

	//~beet_t = 60/55 * 0.5;
	~beet_t = 0.3 * 0.5;
	~beet_rbase = 0.0625;
	~beet_dur_base = 1.0;
	~beet_level = -6.dbamp;

	~beet_dur_seq = Pseq([
		2, 3, 2, 2, 3, 
		2, 2, 3, 2, 2, 3, 2,
		2, 3, 2, 2, 3, 2, 4, 3, 1, 
		2, 3, 2, 2, 3, 2
	], inf).asStream;

	~beet_rate_seq = Pseq([
		1, 2, 4, 1, 2, 4, 1, 2, 4, 1, 3, 8, 
		1, 2, 4, 1, 2, 4, 1, 4, 2,
		1, 2, 4, 1, 2 //, 4, 1, 4, 2,
		//	1, 2, 4, 1, 2, 4, 1
	], inf).asStream;



	~beet_io_seq = Pseq([
		1, 2, 1, 1, 2, 1, 1, 4, 2,

	], inf).asStream;



	~beet_r = Routine {
		var dur, rate, io, hz, rq, ratio, pos, trigrate;
		inf.do({ arg i;
			dur = ~beet_dur_seq.next * ~beet_t * ~beet_dur_base;
			rate = ~beet_rate_seq.next * ~beet_rbase;
			io = ~beet_io_seq.next * -32.dbamp;
			ratio =  (((i*3) % 2) + 1) + (((i * 5) % 4) * 2) * ~beet_rbase;
			hz = 220 * 4/5 * ratio;
			rq = (i%4) * 0.02 + 0.07;
			pos = ~beet_t * ((i*7) % 3) * 0.125;
			[i, ratio, rate, io, rq, pos].postln;
			
			//	dur.postln;
			Synth.new(\grain_1shot_rez_dist, [
				//		\buf, ~jl_bufs[i%4].bufnum, 
				\buf, ~norm_buf,
				\pos, pos,
				\dur, dur * 0.25,
				\rate, rate,
				\trigrate, (((i*4) %3) + 1) / ~beet_t,
				\hz, hz,
				\rq, rq,
				\insideout, io,
				\atk, 0.01, \rel, dur * 2.0,
				\level, ~beet_level, //i.min(32) / 32
			], s);
			dur.wait;
		});
	}.play;

	/*

		~beet_r.stop;


	*/
}.play;