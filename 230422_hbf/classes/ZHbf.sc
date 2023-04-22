ZHbfCap {
	classvar bufDur = 16.0;
	classvar recRelease = 2.0;
	var <>buf;
	var <>dur; // capture duration
	var <>rec; // recording synth
	var <>t0;

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
	}

	start {
		rec = Synth.new (\rec_1, [\buf, buf.bufnum]);
		t0 = SystemClock.seconds;
	}

	stop {
		rec.set(\gate, 0);
		dur = SystemClock.seconds - t0 + recRelease;
		^dur;
	}

}

ZHbfPb {
	var <>buf;
	var <>pb;

	*new { arg aBuf;
		^super.new.init(aBuf);
	}

	*initDefs {
		var s = Server.default;

		// SynthDef.new(\play_1, {
		// 	var aenv = EnvGen.ar(Env.new(
		// 		[0, 1, 1, 0],
		// 	[\attack.ir(2), \sustain.ir(12), \release.ir(2)]), doneAction:2);
		// 	Out.ar(\out.kr(0),
		// 		Pan2.ar(LPF.ar(HPF.ar(
		// 			PlayBuf.ar(1, \buf.kr, \rate.kr(1)),
		// 		\hpf.kr(30)), \lpf.kr(12000)), \pos.kr(0))
		// 	* \amp.kr(1, 1) * aenv)
		// }).send(s);

		SynthDef.new(\play_inf, {
			var attack = \attack.ir(2);
			var sustain = \sustain.ir(12);
			var release =  \release.ir(2);
			var duration = attack + sustain + release;

			var trig =Impulse.kr(1.0 / duration + LFNoise1.kr(\randRate.kr(1), \randMul.kr(1.0)).abs);

			var aenv = EnvGen.ar(Env.new(
				[0, 1, 1, 0],
				[attack, sustain, release]), trig * \gate.kr(0));

			Out.ar(\out.kr(0),
				Pan2.ar(LPF.ar(HPF.ar(
					PlayBuf.ar(1, \buf.kr, \rate.kr(1), trig),
					\hpf.kr(30)), \lpf.kr(12000)), \pos.kr(0))
				* \amp.kr(1, 1) * aenv)
		}).send(s);

	}

	init { arg aBuf;
		buf = aBuf;
		pb = Synth.new(\play_inf, [\buf, buf.bufnum]);
	}

}