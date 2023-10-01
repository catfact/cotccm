
Routine {

	SynthDef.new(\play_inf_resf, {
		var rate = \rate.kr(1);
		var rateMul= rate.abs.reciprocal;
		var attack = \attack.kr(2) * rateMul;
		var sustain = \sustain.kr(12) * rateMul;
		var release = \release.kr(2) * rateMul;
		var duration = attack + sustain + release;
		var gate = \gate.kr(0);

		var trig = Impulse.kr(1.0 / (duration + LFNoise1.kr(\randRate.kr(1), \randMul.kr(1.0)).abs));

		var aenv = EnvGen.ar(Env.new([0, 1, 1, 0], [attack, sustain, release]), (trig * gate) + Impulse.kr(0));

		var snd = PlayBuf.ar(1, \buf.kr, rate, trig, loop:1);

		/// centroid-following filter
		var fft = FFT(LocalBuf(1024), snd);
		var centroid = Latch.kr(SpecCentroid.kr(fft), Amplitude.kr(snd) > \ampThresh.kr(-24.dbamp));
		var centroidLag = Lag.kr(centroid, \centroidLagTime.kr(8));
		var fc = SelectX.kr(\centroidFcAmount.kr(0), [\fcBase.kr(1200), centroidLag]);

		var band = LPF.ar(HPF.ar(snd, \hpf.kr(30)), \lpf.kr(12000));
		fc = Lag.kr(fc, \fcLagTime.kr(2));
		//	[centroidLag, fc].poll;

		snd = SelectX.ar(\resBlend.kr(0), [band, Resonz.ar(snd, fc, \bwr.kr(0.5, 2.0))]);
		//	snd = band;
		Out.ar(\out.kr(0), Pan2.ar(snd, \pos.kr(0)) * \amp.kr(1, 4) * aenv)
	}).send(s);

	s.sync;

	x = Synth.new(\play_inf_resf, [\buf, z.cap[1].buf.bufnum, \sustain, z.cap[0].dur - (2+2)]);

	s.sync;
	x.set(\gate, 1);
	x.set(\rate, 4/3);
	x.set(\pos, -0.5);
//	x.set(\buf, z.cap[1].buf);
	y = Synth.new(\play_inf_resf, [\buf, z.cap[1].buf.bufnum, \sustain, z.cap[0].dur - (2+2)]);
	s.sync;
	y.set(\rate, 3/2);
	y.set(\gate, 1);
	y.set(\pos, 0.7);

	x.set(\fcBase, 800);
	x.set(\resBlend, 0.8);
	x.set(\centroidFcAmount, 1);
	x.set(\bwr, 0.24);

	y.set(\fcBase, 800);
	y.set(\resBlend, 0.8);
	y.set(\centroidFcAmount, 1);
	y.set(\bwr, 0.24);
//	y.set(\buf, z.cap[1].buf);

	~xr = Routine { inf.do {
		var rate = [4/3, 10/6].choose;
		if (0.25.coin, { rate = rate * -1; });
		postln("xrate: " ++ rate);
		x.set(\rate, rate);
		(z.cap[0].dur * (0.25 + 0.25.rand)).wait;
	} }.play;

	~yr = Routine { inf.do {
		var rate =  [3/2, 12/7].choose;
		if (0.25.coin, { rate = rate * -1; });
		postln("yrate: " ++ rate);
		y.set(\rate, rate);
		(z.cap[0].dur * (0.25 + 0.25.rand)).wait;
	} }.play;



}.play;


/*


z.cap[0].buf.plot;
z.cap[0].dur
z.cap[0].dur - (2+2)
x
y

x.free;

*/