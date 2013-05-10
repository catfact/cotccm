Routine {
	//~beet_t = 60/55 * 0.5;
	//	~beet_t = 0.3 * 0.5;
	~beet_t = 60.0 / 80.0;
	~beet_rbase = 0.125;
	~beet_dur_base = 4.0;
	~beet_dur_len_mul = 6.0;
	~beet_level = 6.dbamp;
	~beet_trig_rbase = 0.0625;
	~hz_base = Array.fill(~frN, { 220 * 8/9 });

	~rq_base = 0.5;

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

	~beet_buf_seq = Pseq([
		0, 1, 0, 3, 0, 5, 0, 7,
		0, 0, 2, 0, 4, 0, 6, 0,
		0, 1, 0, 3, 0, 0, 6, 0,
		0, 1, 2, 0, 0, 5, 6, 0,
		0, 0, 0, 3, 4, 0, 0, 7
	], inf).asStream;

	~beet_trig_seq = Pseq([
		1, 2, 2, 1, 2, 3, 1, 1, 2, 2, 4, 1, 1
	], inf).asStream;
	

	~beet_io_seq = Pseq([
		1, 2, 1, 1, 2, 1, 1, 4, 2,

	], inf).asStream;


	~beet_r = Routine {
		var dur, rate, io, hz, rq, ratio, pos, trigrate, buf;
		inf.do({ arg i;
			dur = ~beet_dur_seq.next * ~beet_t * ~beet_dur_base;
			rate = ~beet_rate_seq.next * ~beet_rbase;
			io = ~beet_io_seq.next * -32.dbamp;
			buf = ~beet_io_seq.next;
			ratio =  (((i*3) % 2) + 1) + (((i * 5) % 4) * 2) * ~beet_rbase;
			//			hz = ~hz_base * 4/5 * ratio;
			hz = ratio * ~hz_base[buf];
			while ( {hz > (~hz_base[buf] * 2)}, { hz = hz * 0.5 });
			rq = (i%4) * 0.02 + ~rq_base;
			pos = ~beet_t * ((i*7) % 3) * 0.125;
			//			[i, ratio, rate, io, rq, pos].postln;
			~row.value(5, 1 << buf);
			//	dur.postln;
			Synth.new(\grain_1shot_rez_env, [
				//		\buf, ~jl_bufs[i%4].bufnum, 
				\buf, ~frBuf[buf].bufnum,
				\pos, pos,
				\dur, dur * 0.25 * ~beet_dur_len_mul,
				\rate, rate,
				\trigrate, ~beet_trig_seq.next / ~beet_t  * ~beet_trig_rbase,
				\hz, hz,
				\rq, rq,
				\insideout, io,
				\atk, 0.01, \rel, dur * 4.0,
				\level, ~beet_level, //i.min(32) / 32
			], s);
			dur.wait;
		});
	}.play;


	~beet_r2 = Routine {
		var dur, rate, io, hz, rq, ratio, pos, trigrate, buf;
		inf.do({ arg i;
			dur = ~beet_dur_seq.next.next * ~beet_t * ~beet_dur_base;
			rate = ~beet_rate_seq.next.next * ~beet_rbase;
			io = ~beet_io_seq.next * -32.dbamp;
			buf = ~beet_io_seq.next;
			ratio =  (((i*4) % 3) + 1) + (((i * 5) % 4) * 2) * ~beet_rbase;
			//			hz = ~hz_base * 4/5 * ratio;
			hz = ratio * ~hz_base[buf];
			while ( {hz > (~hz_base[buf] * 2)}, { hz = hz * 0.5 });
			rq = (i%4) * 0.02 + ~rq_base;
			pos = ~beet_t * ((i*7) % 3) * 0.125;
			//			[i, ratio, rate, io, rq, pos].postln;
			~row.value(6, 1 << buf);
			//	dur.postln;
			Synth.new(\grain_1shot_rez_env, [
				//		\buf, ~jl_bufs[i%4].bufnum, 
				\buf, ~frBuf[buf].bufnum,
				\pos, pos,
				\dur, dur * 0.25 * ~beet_dur_len_mul,
				\rate, rate,
				\trigrate, ~beet_trig_seq.next.next / ~beet_t * ~beet_trig_rbase,
				\hz, hz,
				\rq, rq,
				\insideout, io,
				\atk, 0.01, \rel, dur * 4.0,
				\out, 1,
				\level, ~beet_level, //i.min(32) / 32
			], s);
			dur.wait;
		});
	}.play;


	/*

		~beet_r.stop;
		~beet_r2.stop;

	*/
}.play;


