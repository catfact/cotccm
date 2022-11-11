

// simple stereo loop, ok
z = {
	arg rate1=0.2, rate2= 0.25, amp=0.5, hpf=10;
	var snd = PlayBuf.ar(1, ~lownoise_buf.bufnum, [rate1, rate2], loop:1);
	snd = HPF.ar(snd, hpf);
	Out.ar(~out_b.index, snd*amp)
}.play(~xg);

z.set(\amp, 0.05);

z.free;

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
	Out.ar(out, Pan2.ar(snd*amp, pan));
}).send(s);



y = Synth.new(\pulsr, [\out, ~out_b.index, \buf, ~lownoise_buf.bufnum,
	\start, 1, \end, 5, \rate, 1/84, \decay, 0.02,
	\thresh, -40.dbamp, \amp, -12.dbamp], ~xg);

y.set(\rate, 1/256);
y.set(\decay, 0.2);
y.set(\attack, 0);
y.set(\fc, 200);
y.set(\gain, 3.3);

y.free;


//-----------------------
~dowse.bus.scope

g = ~dowse.grab;


~dowse.data.do({ arg ev, i; [i, ev].postln; });
~dowse.grab.postln;
(~dowse.grab).value(callback:{ arg ev; postln("!!!!"); ev.postln; });nil
~dowse.data