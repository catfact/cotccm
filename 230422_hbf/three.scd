SynthDef.new(\play_inf_resf, {
	var rate = \rate.kr(1);
	var rateMul= rate.abs.reciprocal;
	var attack = \attack.kr(2) * rateMul;
	var sustain = \sustain.kr(12) * rateMul;
	var release =  \release.kr(2) * rateMul;
	var duration = attack + sustain + release;

	var trig =Impulse.kr(1.0 / (duration + LFNoise1.kr(\randRate.kr(1), \randMul.kr(1.0)).abs));

	var aenv = EnvGen.ar(Env.new( [0, 1, 1, 0], [attack, sustain, release]), trig * \gate.kr(0));

	var snd = PlayBuf.ar(1, \buf.kr, rate, trig);

	/// centroid-following filter
	var fft = FFT(LocalBuf(1024), snd);
	var centroid = SpecCentroid.kr(fft);
	// var centroidMidi = centroid.cpsmidi;
	// var centroidSlewRate = \centroidSlew.kr(6);
	// var centroidSlewMidi = Slew.kr(centroidMidi, centroidSlewRate, centroidSlewRate);
	// var centroidSlew = centroidSlewMidi.midicps;
	// var fc = SelectX.kr(\centroidFcAmount.kr(0), [\fcBase.kr(12000), centroidSlew]);
	var centroidLag = Lag.kr(centroid, \centroidLagTime.kr(4));
	var fc = SelectX.kr(\centroidFcAmount.kr(0), [\fcBase.kr(1200), centroidLag]);

	var band = LPF.ar(HPF.ar(snd, \hpf.kr(30)), \lpf.kr(12000));
	fc = Lag.kr(fc, \fcLagTime.kr(2));
//	[centroidLag, fc].poll;

	snd = SelectX.ar(\resBlend.kr(0), [band, Resonz.ar(snd, fc, \bwr.kr(0.5, 2.0))]);
	//	snd = band;
	Out.ar(\out.kr(0), Pan2.ar(snd, \pos.kr(0)) * \amp.kr(1, 4) * aenv)
}).send(s);


/*
z.cap[0].buf.plot;
z.cap[0].dur
z.cap[0].dur - (2+2)
x = Synth.new(\play_inf_resf, [\buf, z.cap[0].buf.bufnum, \sustain, z.cap[0].dur - (2+2)]);
x.set(\gate, 1);
x.set(\rate, 4/3);
x.set(\pos, -0.5);

y = Synth.new(\play_inf_resf, [\buf, z.cap[0].buf.bufnum, \sustain, z.cap[0].dur - (2+2)]);
y.set(\rate, 3/2)
y.set(\gate, 1);
y.set(\pos, 0.7);

x.set(\fcBase, 800);
x.set(\resBlend, 0.8);
x.set(\centroidFcAmount, 0.6);

y.set(\fcBase, 800);
y.set(\resBlend, 0.8);
y.set(\centroidFcAmount, 0.6);

x.free;

*/