
SynthDef.new(\patch_adc_mono, { arg in, out, level=1.0;
	Out.ar(out, SoundIn.ar(in) * level);
}).store;

SynthDef.new(\patch_pan, {arg in, out, pan=0.0, level=1.0;
	Out.ar(out, Pan2.ar(In.ar(in) * level, pan));
}).store;

SynthDef.new(\patch_sum, {arg in, out, level=1.0;
	Out.ar(out, Mix.new(In.ar(in, 2) * level));
}).store;

SynthDef.new(\patch_stereo, {arg in, out, level=1.0;
	Out.ar(out, In.ar(in, 2) * level);
}).store;

SynthDef.new(\record_adc, { arg in=0, buf=0, loop=1, recLevel=1.0, preLevel=0.0, offsetSamps=0;
	RecordBuf.ar(SoundIn.ar(in), buf, loop:loop, recLevel:recLevel, preLevel:preLevel, offset:offsetSamps);
}).store;

SynthDef.new(\sampleloop, {
	arg out=0, buf=0, delayBuf=1,
		level=1.0, rate=1.0,
		loopTime=1.0, fadeRatio=0.125,
		resetTrigger=0.0, offsetSamps=0, offsetRamp=1.0;
	
	var phaseA, phaseB, playA, playB, envA, envB, output, loopSamps, tick, gateA, gateB;
	
	tick = LFPulse.ar(2.0/loopTime);
	phaseA = Phasor.ar(trig:K2A.ar(resetTrigger), rate:rate, start:0, end:loopTime * 2 * SampleRate.ir * rate);
//	phaseB = BufDelayL.ar(delayBuf, phaseA, loopTime);
	phaseB = (phaseA + (SampleRate.ir * loopTime * rate)).wrap(0, loopTime * 2 * SampleRate.ir * rate);
	playA = BufRd.ar(1, buf, (phaseA + offsetSamps).wrap(0, BufFrames.kr(buf) - 1));
	playB = BufRd.ar(1, buf, (phaseB + offsetSamps).wrap(0, BufFrames.kr(buf) - 1));
	gateB = ToggleFF.kr(tick + Trig.kr(resetTrigger));
	gateA = 1 - gateB;
//	envA = EnvGen.ar(Env.new([0.001, 1.0, 1.0, 0.001], [fadeRatio, 1.0, fadeRatio], 'linear'), timeScale:loopTime, gate:(phaseA>0));
//	envB = EnvGen.ar(Env.new([0.001, 1.0, 1.0, 0.001], [fadeRatio, 1.0, fadeRatio], 'linear'), timeScale:loopTime, gate:(phaseB>0));
	envA = EnvGen.ar(Env.new([0.001, 1.0, 1.0, 0.001], [fadeRatio, 1.0, fadeRatio], 'linear'), timeScale:loopTime, gate:gateA);
	envB = EnvGen.ar(Env.new([0.001, 1.0, 1.0, 0.001], [fadeRatio, 1.0, fadeRatio], 'linear'), timeScale:loopTime, gate:gateB);
	//envA = 1.0;
	//envB = 1.0;
	output = playA*envA + playB*envB;
	//output=0;
	Out.ar(out, output * level);	
}).send(s);

