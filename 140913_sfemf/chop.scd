Routine {



	~chop_blen = 16.0;
	~chop_buf = Buffer.alloc(s, s.sampleRate * ~chop_blen);


	s.sync;
	~recBuf.value(~chop_buf, 0, {

		Routine {
			~chop_buf.normalize;

			//// playback synth...

			//~beet_t = 60/55 * 0.5;
			~beet_t = 11/16;
			~beet_rbase = 2.25;
			~beet_dur_base = 1.0;
			~beet_dur_len_mul = 4.0;
			~beet_level = -16.dbamp;
			~beet_trig_rbase = 0.25;

			~hz_base = [ 118.03624725342, 62.485549926758, 62.494869232178, 62.500381469727, 62.496398925781, 62.506252288818, 62.494106292725, 62.50231552124 ];



			~rq_base = 0.05;

			~beet_dur_seq = Pseq([
				2, 7/4, 1, 9/8, 3,
				23/12, 2, 3, 11/8, 2, 3, 2,
				2, 3, 2, 15/8, 3, 2, 7/16, 3, 1,
				2, 3, 2, 2, 3, 2
			], inf).asStream;

			~beet_rate_seq = Pseq([
				1, 2, 4, 17/16, 2, 22/16, 1, 2, 4, 9/8, 3, 8,
				1, 2, 15/8, 3, 2, 4, 12/5, 1, 4, 7/4, //, 4, 1, 4, 2,
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
				1, 2, 9/4, 1, 2, 3, 11/8, 1, 23/16, 15/8, 4, 9/8, 1
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
					buf = ~beet_buf_seq.next;
					ratio =  (((i*3) % 2) + 1) + (((i * 5) % 4) * 2) * ~beet_rbase;
					//			hz = ~hz_base * 4/5 * ratio;
					hz = ratio * ~hz_base[buf];
					hz = ratio * rate;
					while ( {hz > (~hz_base[buf] * 2)}, { hz = hz * 0.5 });
					rq = (i%4) * 0.02 + ~rq_base;
					pos = ~beet_t * ((i*7) % 3) * 0.125;
					//			[i, ratio, rate, io, rq, pos].postln;
					// ~row.value(5, 1 << buf);
					//	dur.postln;
					Synth.new(\grain_1shot_rez_env, [
						//		\buf, ~jl_bufs[i%4].bufnum,
						\buf, ~chop_buf.bufnum,
						\pos, pos * (buf / ~chop_blen * 0.125),
						\dur, dur * 0.25 * ~beet_dur_len_mul,
						\rate, rate,
						\trigrate, ~beet_trig_seq.next / ~beet_t  * ~beet_trig_rbase,
						\hz, hz,
						\rq, rq,
						\insideout, io,
						\atk, dur, \rel, dur * 4.0,
						\level, ~beet_level, //i.min(32) / 32
						\pan, -0.5
					], s);

					if( 0.25.coin, { dur = ~beet_dur_seq.next * ~beet_t * ~beet_dur_base});
					dur.wait;
				});
			}.play;


			~beet_r2 = Routine {
				var dur, rate, io, hz, rq, ratio, pos, trigrate, buf;
				inf.do({ arg i;
					dur = ~beet_dur_seq.next.next * ~beet_t * ~beet_dur_base;
					rate = ~beet_rate_seq.next.next * ~beet_rbase;
					io = ~beet_io_seq.next * -32.dbamp;
					buf = ~beet_buf_seq.next;
					ratio =  (((i*7) % 5) + 1) + (((i * 5) % 3) * 2) * ~beet_rbase;
					//			hz = ~hz_base * 4/5 * ratio;
					hz = ratio * ~hz_base[buf];
					while ( {hz > (~hz_base[buf] * 2)}, { hz = hz * 0.5 });
					rq = (i%4) * 0.02 + ~rq_base;
					pos = ~beet_t * ((i*7) % 3) * 0.125;
					//			[i, ratio, rate, io, rq, pos].postln;
					~row.value(6, 1 << buf);
					buf.postln;
					//	dur.postln;
					Synth.new(\grain_1shot_rez_env, [
						//		\buf, ~jl_bufs[i%4].bufnum,
						\buf, ~chop_buf.bufnum,
						\pos, pos,
						\dur, dur * 0.25 * ~beet_dur_len_mul,
						\rate, rate,
						\trigrate, ~beet_trig_seq.next.next.next / ~beet_t * ~beet_trig_rbase,
						\hz, hz,
						\rq, rq,
						\insideout, io,
						\atk, dur,
						\rel, dur * 4.0,
						\out, 0,
						\level, ~beet_level,
						\pan, 0.5
					], s);
					dur.wait;
				});
			}.play;


			/*
			~beet_r.stop;
			~beet_r2.stop;
			*/
		}.play;



	});

	/*
	~chop_buf.plot;
	*/


}.play;