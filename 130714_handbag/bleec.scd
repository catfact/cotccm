Routine {
	//~beet_t = 60/55 * 0.5;
	~beet_t = 60/55 * 2;
	//	~beet_rbase = 0.0625;
	~beet_rbase = 0.5;
	~beet_dur_base = 1.0;
	~beet_dur_len_mul = 4.0;
	~beet_level = -24.dbamp;
	~beet_trig_rbase = 1.0;

	//	~hz_base = Array.fill(~frN, { 220 });
	~hz_base = [ 118.03624725342, 62.485549926758, 62.494869232178, 62.500381469727, 62.496398925781, 62.506252288818, 62.494106292725, 62.50231552124 ] * 4/3;

	~rq_base = 0.5;

	~beet_dur_seq = Pseq([
		1, 1, 1, 0.5, 1, 1, 1.5
	], inf).asStream;

	~beet_rate_seq = Pseq(
		
		[4, 5, 6, 7, 8, 11, 13, 14].scramble.wrapExtend(32) / [8, 9, 10, 11, 12, 13, 14, 15].scramble.wrapExtend(32)
		, inf).asStream;

	~beet_buf_seq = Pseq([
		0, 0, 1, 0, 0, 2, 0, 3, 1, 4, 1, 5, 1, 6, 1, 7
	], inf).asStream;

	~beet_trig_seq = Pseq([ 
		1.0
	], inf).asStream;
	

	~beet_io_seq = Pseq([
		1, 2, 1, 1, 2, 1, 1, 4, 2,
	], inf).asStream;


	~beet_r = Routine {
		var dur, rate, io, hz, rq, ratio, pos, trigrate, buf, rezmix;
		inf.do({ arg i;
			dur = ~beet_dur_seq.next * ~beet_t * ~beet_dur_base;
			rate = ~beet_rate_seq.next * ~beet_rbase;
			io = ~beet_io_seq.next * -32.dbamp;
			buf = ~beet_buf_seq.next;
			ratio =  (((i*3) % 2) + 1) + (((i * 5) % 4) * 2) * ~beet_rbase;
			//			hz = ~hz_base * 4/5 * ratio;
			hz = ratio * ~hz_base[buf];
			while ( {hz > (~hz_base[buf] * 2)}, { hz = hz * 0.5 });
			rq = (i%4) * 0.02 + ~rq_base;
			//			rq = 0.8;
			pos = ~beet_t * ((i*7) % 3) * 0.125;
			[i, ratio, rate, io, rq, pos].postln;
			~row.value(5, 1 << buf);

			rezmix = 1.0 - (i / 5);
			//	dur.postln;
			Synth.new(\grain_1shot_rez_env, [
				//		\buf, ~jl_bufs[i%4].bufnum, 
				\buf, ~frBuf[buf].bufnum,
				\pos, pos,
				\dur, dur * 0.25 * ~beet_dur_len_mul * ~beet_t,
				\rate, rate,
				\trigrate, ~beet_trig_seq.next / ~beet_t  * ~beet_trig_rbase,
				\hz, hz,
				\rq, rq,
				\insideout, io,
				\atk, dur, \rel, dur * 4.0,
				\level, ~beet_level, //i.min(32) / 32
				\pan, 0,
				\rezmix, rezmix
			], s);
			dur.wait;
		});
	}.play;


	~beet_r2 = Routine {
		var dur, rate, io, hz, rq, ratio, pos, trigrate, buf, rezmix;
		inf.do({ arg i;
			dur = ~beet_dur_seq.next.next * ~beet_t * ~beet_dur_base;
			rate = ~beet_rate_seq.next.next * ~beet_rbase;
			io = ~beet_io_seq.next * -32.dbamp;
			buf = ~beet_buf_seq.next;
			ratio =  (((i*4) % 3) + 1) + (((i * 5) % 4) * 2) * ~beet_rbase;
			//			hz = ~hz_base * 4/5 * ratio;
			hz = ratio * ~hz_base[buf];
			while ( {hz > (~hz_base[buf] * 2)}, { hz = hz * 0.5 });
						rq = (i%4) * 0.02 + ~rq_base;
			//rq = 0.8;
			pos = ~beet_t * ((i*7) % 3) * 0.125;
			[i, ratio, rate, io, rq, pos].postln;
			~row.value(6, 1 << buf);
			rezmix = 1.0 - (i / 5);
			//			buf.postln;
			//	dur.postln;
			Synth.new(\grain_1shot_rez_env, [
				//		\buf, ~jl_bufs[i%4].bufnum, 
				\buf, ~frBuf[buf].bufnum,
				\pos, pos,
				\dur, dur * 0.25 * ~beet_dur_len_mul * ~beet_t,
				\rate, rate,
				\trigrate, ~beet_trig_seq.next.next.next / ~beet_t * ~beet_trig_rbase,
				\hz, hz,
				\rq, rq,
				\insideout, io,
				\atk, dur, \rel, dur * 4.0,
				\out, 1,
				\level, ~beet_level, //i.min(32) / 32
				\pan, 0.0,
				\rezmix, rezmix
			], s);
			dur.wait;
		});
	}.play;


	/*

		~beet_r.stop;
		~beet_r2.stop;

	*/
}.play;