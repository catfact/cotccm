Routine {
	var bufdur = 64;

	var init_buf = {
		arg inb;

		var buf;
		var rec_s;

		var ev = Event.new;

		s.sync;

		buf = Buffer.alloc(s, bufdur*s.sampleRate, 1);

		rec_s = {
			arg gate=0, preLevel=0, preLag=1.0;
			var aenv = EnvGen.ar(Env.asr(2, 1, 2), gate);
			var pre = (1-aenv).max(Lag.kr(preLevel, preLag));
			RecordBuf.ar(In.ar(inb) * aenv, buf.bufnum, run:aenv > 0, preLevel:pre, loop:1);
			Silent.ar;
		}.play(~ig, addAction:\addAfter);

		ev.rec_s = rec_s;
		ev.buf = buf;
		ev.inb = inb;
		ev.total_dur = 0;

		ev.start_rec = {
			ev.rec_s.set(\gate, 1);
			ev.rec_t0 = SystemClock.seconds;
		};

		ev.stop_rec = {
			ev.rec_s.set(\gate, 0);
			ev.rec_dur = SystemClock.seconds - ev.rec_t0;
			ev.total_dur = ev.total_dur + ev.rec_dur;
		};
	};

	~buf = (
		noise: init_buf.value(~vla_b.index),
		tones: init_buf.value(~vla_b.index),
	);

	postln("done initialiazing buffers");
	c.unhang;
}.play;