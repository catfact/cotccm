
b = Buffer.alloc(s, 16 * s.sampleRate, 1);

SynthDef.new(\rec_1, {
	var aenv = EnvGen.ar(Env.asr(\attack.kr(1), 1, \release.kr(1)), \gate.kr(1), doneAction:2);
	RecordBuf.ar(SoundIn.ar(\in.kr(0), aenv), \buf.kr, doneAction:2);
}).send(s);

~rec = Synth.new(\rec_1, [\buf, b.bufnum]);
~rec.set(\gate, 0);
b.plot


SynthDef.new(\play_1, {
	var aenv = EnvGen.ar(Env.new(
		[0, 1, 1, 0],
		[\attack.ir(2), \sustain.ir(12), \release.ir(2)]), doneAction:2);
	Out.ar(\out.kr(0),
		Pan2.ar(LPF.ar(HPF.ar(
			PlayBuf.ar(1, \buf.kr, \rate.kr(1)),
			\hpf.kr(30)), \lpf.kr(12000)), \pos.kr(0))
		* \amp.kr(1, 1) * aenv)
}).send(s);

/// one state
r = Routine { inf.do {
	z = Synth.new(\play_1, [\buf, b.bufnum,
		\pos, -1, \rate, 1/3, \sustain, 6]);
	1.0.rand.wait;
	y= Synth.new(\play_1, [\buf, b.bufnum,
		\pos, 1, \rate, 1/3, \sustain, 6]);
	8.wait;
	1.0.rand.wait;
}}.play;

