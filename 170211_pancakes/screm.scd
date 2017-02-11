~maxnumscrem = 8;
~scrembuflen = 8.0;

~screm = Array.fill(~maxnumscrem, { (
	buf: Buffer.alloc(s, ~scrembuflen * s.sampleRate, 1),
	rec: nil,
	syn: nil,
	dur:nil
)});

~capture_start = { arg i;
	~screm[i].rec = {
		RecordBuf.ar(SoundIn.ar(1), ~screm[i].buf);
	}.play;
	~screm[i].dur = SystemClock.seconds;
};


~capture_stop = { arg i;
	~screm[i].dur = SystemClock.seconds - ~screm[i].dur;
	~screm[i].rec.free;
};



SynthDef.new(\bufgrain_pan, {
	arg buf, out=0, amp=1.0, amplag = 0.1,
	rate=1.0, dur=1.0, trigrate=6.0, posrate= 1.0, pan=0.0, len=1.0,
	gate=1, fade=0.1;
	var pos, grains, trig, bufdur, env;
	bufdur = BufDur.kr(buf);
	pos = LFTri.kr(posrate / bufdur).wrap(0.0, len / bufdur);
	trig = Impulse.kr(trigrate);
	amp = Lag.kr(amp, amplag);
	grains = GrainBuf.ar(1, trig, dur, buf, rate, pos, 2);
	//env = EnvGate.new(0, gate, fade, 2);
	//Out.ar(out, Pan2.ar(grains * amp * env, pan));

	Out.ar(out, Pan2.ar(grains * amp, pan));
}).send(s);



~capture_start.value(0);
~capture_stop.value(0);

~capture_start.value(1);
~capture_stop.value(1);

/*
~screm[0].buf.plot;
*/

/*
z = Synth.new(\bufgrain_pan, [\buf, ~screm[0].buf, \len, ~screm[0].dur]);
z.free;
*/

~screm_b = Bus.audio(s, 2);
~screm_g = Group.new;

~screm_out_s = { arg amp=1.0, amplag = 0.1;
	amp = Lag.kr(amp, amplag);
	Out.ar(0, In.ar(~screm_b, 2) * amp);
}.play(target:~screm_g, addAction:\addAfter);

~doscrem = { arg screm, n, a, b, c, wait=0.2, amp=0.25;
	var qp, rs, pan, rate;
	Routine {
		qp = QuadPrimes.new(a, b, c);
		rs = qp.generate(n, 2.0);
		rs.postln;
		rs.do({
			arg r, i;
			pan = r.linlin(1.0, 2.0, -1.0, 1.0);
			post("pan : " ++ pan ++ "; ");
			post("rate : " ++ rate ++ "; ");

			Synth.new(\bufgrain_pan, [
				\buf, screm.buf,
				\rate, r * 0.75,
				\trigrate, r * 1.5,
				\posrate, 0.5,
				\pan, pan,
				\out, ~screm_b.index,
				\amp, amp;
			], ~screm_g);
			wait.wait;
		});

	}.play;
};

~doscrem.value(~screm[0], 35, 7, 11, 31);
~doscrem.value(~screm[1], 24, 5, 3, 17);
