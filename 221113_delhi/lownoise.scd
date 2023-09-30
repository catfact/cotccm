s.waitForBoot {
	Routine {
		var inb;
		var bufdur = 64;
		var buf;
		var rec_s;
		var loops;
		var rec_t0;
		var rec_dur;
		s.sync;

		inb = ~vla_b.index;
		buf = Buffer.alloc(s, bufdur*s.sampleRate, 1);

		rec_s = {
			arg gate=0;
			var aenv = EnvGen.ar(Env.asr(2, 1, 2), gate);
//			aenv.poll;
			RecordBuf.ar(In.ar(inb) * aenv, buf.bufnum, run:aenv > 0);
			Silent.ar;
		}.play(~ig, addAction:\addAfter);

		~lownoise_start_rec = {
			rec_s.set(\gate, 1);
			rec_t0 = SystemClock.seconds;
		};

		~lownoise_stop_rec = {
			rec_s.set(\gate, 0);
			rec_dur = SystemClock.seconds - rec_t0;
		};

		~lownoise_buf = buf;


	}.play;
}