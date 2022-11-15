
// clicky click?
SynthDef.new(\pulsr, { arg out, buf,
	start, end, rate,
	trigLpf=20, thresh=0.1,
	attack=0.001, decay=0.2, amp=0.5,
	brown=0.25, pink=0.1, white=0.0, pan=0,
	fc=200, gain=0.2;

	var sr, phase, trig, trigAmp, env, snd;
	sr = BufSampleRate.ir(buf);
	phase = Phasor.ar(0, rate, start * sr, end*sr);
	trig = LPF.ar(BufRd.ar(1, buf, phase), trigLpf);

	trigAmp = Amplitude.kr(trig);
	trigAmp.poll;
	env = EnvGen.ar(Env.perc(attack, decay), trig,
		timeScale:trigAmp.linlin(0, 1, 1, 4));

	snd = env * Mix.new(BrownNoise.ar*brown, PinkNoise.ar * pink, WhiteNoise.ar*white);
	snd = MoogFF.ar(snd, fc, gain);
	Out.ar(out, Pan2.ar(snd*amp.lag(8), pan));
}).send(s);


~pulsz = List.new;

y = Synth.new(\pulsr, [\out, ~out_b.index, \buf, ~buf.tones.buf.bufnum,
	\start, 1, \end, 5, \rate, 1/84, \decay, 0.02,
	\thresh, -40.dbamp, \amp, -12.dbamp], ~xg);

y.set(\amp, -24.dbamp);
~pulsz.add(y);