ZHbfCap {
	classvar bufDur = 32.0;
	classvar recRelease = 2.0;
	var <>buf;
	var <>dur; // capture duration
	var <>rec; // recording synth
	var <>t0;
	var <>isCapturing;
	var <>cancelClock;

	*new {
		^super.new.init;
	}

	*initDefs {
		var s = Server.default;
		SynthDef.new(\rec_1, {
			var aenv = EnvGen.ar(Env.asr(\attack.kr(1), 1, \release.kr(recRelease)), \gate.kr(1), doneAction:2);
			RecordBuf.ar(SoundIn.ar(\in.kr(0), aenv), \buf.kr, doneAction:2);
		}).send(s);
	}

	init {
		var s = Server.default;
		buf = Buffer.alloc(s, bufDur * s.sampleRate);
		isCapturing = false;
		cancelClock = TempoClock.new;
		dur = bufDur;
	}

	start {
		rec = Synth.new (\rec_1, [\buf, buf.bufnum]);
		t0 = SystemClock.seconds;
		isCapturing = true;
		cancelClock.sched(bufDur - recRelease, {
			if (isCapturing, {
				postln("reached buf duration; cancelling");
				this.stop;
			});
			nil
		});
	}

	stop {
		if (isCapturing, {
			rec.set(\gate, 0);
			dur = SystemClock.seconds - t0 + recRelease;
			cancelClock.clear;
		});
		isCapturing = false;
		^dur;
	}

}

ZHbfPb {
	var <>buf;
	var <>pb;
	var <>rats;
	var <>ratr;
	var <>dur = 32;

	*new { arg aBuf, aRats;
		^super.new.init(aBuf, aRats);
	}

	*initDefs {
		var s = Server.default;

		SynthDef.new(\play_inf_resf, {
			var rate = \rate.kr(1);
			var rateMul= rate.abs.reciprocal;
			var attack = \attack.kr(2) * rateMul;
			var sustain = \sustain.kr(12) * rateMul;
			var release = \release.kr(2) * rateMul;
			var duration = attack + sustain + release;
			var gate = \gate.kr(0);

			var trig = Impulse.kr(1.0 / (duration + LFNoise1.kr(\randRate.kr(1), \randMul.kr(1.0)).abs));

			var aenv = EnvGen.ar(Env.new([0, 1, 1, 0], [attack, sustain, release]), (trig * gate));

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


	}

	init { arg aBuf, aRats;
		buf = aBuf;
		pb = Synth.new(\play_inf_resf, [\buf, buf.bufnum]);
		rats = aRats;
		ratr = Routine { inf.do {
			var rate =  rats.choose;
			if (0.25.coin, { rate = rate * -1; });
			postln("rate: " ++ rate);
			pb.set(\rate, rate);
			(dur * (0.25 + 0.25.rand)).wait;
		} }.play;
	}

}