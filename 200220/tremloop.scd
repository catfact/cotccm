var nbuf, buflen, buf;
var rec, run, free;

// set up buffers
nbuf = 4;
buflen = 8.0;

buf = Array.fill(nbuf, {Buffer.alloc(s, buflen * s.sampleRate, 1); });


// mono->stereo tremolo
SynthDef.new(\trem, { arg in, out=0, amp=1.0,
	hz=1.0, fb=0.0, pan=0.0, depth=1.0;
	var snd, aenv;
	snd = In.ar(in);
	aenv = SinOscFB.ar(hz, fb) * 0.5 + 0.5;
	snd = SelectX.ar(depth, [snd, snd * aenv]);
	Out.ar(out, Pan2.ar(amp * snd, pan));
}).send(s);

// 1-shot mono buffer record
SynthDef.new(\adc_rec1, {
	arg in=0, buf;
	RecordBuf.ar(SoundIn.ar(in), buf, loop:0, doneAction:2);
}).send(s);

// 1-shot mono buffer playback
SynthDef.new(\play1, {
	arg buf, out=0, amp=1.0, rate=1.0, pos=0,
	atk=0.1, rel=0.1, dur=1.0, curve=0;
	var snd, aenv;
	snd = PlayBuf.ar(1, buf, rate, startPos:pos);
	aenv= EnvGen.ar(Env.new([0,1,1,0], [atk, dur, rel], curve), doneAction:2);
	Out.ar(out, amp * aenv * snd);
}).send(s);


// one-shot record function (entire single buffer)
rec = { arg self, ix, chan=0;
	("rec: " ++ ix).postln;
	Synth.new(\adc_rec1, [\buf, buf[ix], \in, chan]);
};


run = { arg self, ix, amp=1.0, pan=0.0,
	tremrate=1.0, looprate=2.0, dur=1.0,
	bufrate=1.0, pos=0;

	var b, g, fx, r, e;

	//("play: " ++ self).postln;
	("run: " ++ ix).postln;

	b = Bus.audio(s, 1);
	g = Group.new(s);
	fx = Synth.new(\trem, [
		\in, b.index,
		\hz, tremrate,
		\amp, amp,
		\pan, pan
	], target:g);
	r = Routine { inf.do {
		Synth.new(\play1, [
			\out, b.index,
			\buf, buf[ix],
			\pos, pos,
			\rate, bufrate,
		], target:g);
		dur.wait;
	}}.play;

	// return an Event with the all the things
	(
		ix: ix, amp:amp, pan:pan,
		tremrate:tremrate, looprate:looprate, dur:dur,
		pos:pos, bufrate:bufrate,
		b: b, g: g, fx: fx, r:r
	)
};

free = { arg self, loop;
	loop.r.stop;
	loop.g.free;
	loop.b.free;
};

(
nbuf:nbuf, buflen: buflen, buf: buf,
rec: rec, run: run, free: free
)