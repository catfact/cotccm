SynthDef.new(\recOnce, {
	arg in=0, buf=0,
	reclevel=1.0, prelevel=0.0, offset=0.0, trig=1.0, loop=0, run=1,
	atk=0.01, rel=0.01, gate=1;

	RecordBuf.ar(In.ar(in, 1),
		bufnum: buf,
		offset:0,
		recLevel:reclevel,
		preLevel:prelevel,
		run:run,
		loop:loop,
		trigger:trig,
		doneAction:2
	);
}).send(s);


SynthDef.new(\grain_1shot_rez_env, {
	arg buf, out=0, level=1.0,
	hz=(440 * 8/9), hz2 = 220, rq=0.4, rezmix=1.0,
	rate=1.0, pos=0.0,
	atk=1.0, rel=1.0, gate=1,
	minframes=0, maxframes=44100,
	dur=4.0, insideout=0.0,
	trigrate = 1,
	rezenv = 1/64, rezdec=0.1,
	pan = 0.0;

	var ampenv, trig, phase, read,
	sr, frames, ratescale, framediff;

	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	framediff = maxframes - minframes;

	trig = LFPulse.ar(trigrate);

	ampenv = EnvGen.ar(Env.linen(atk, dur, rel), gate:gate, doneAction:2);

	rezenv = trig * rezenv;
	rezenv = Decay.ar(rezenv, rezdec);

	//	rq = rq * (1 + rezenv);
	//	hz = Line.ar(hz, hz2, dur);
	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:0);
	//	read = read + InsideOut.ar(read, insideout);
	//	read = Resonz.ar(read, hz, rq) * rezmix;
	read = (read * (1.0 - rezmix)) + RLPF.ar(read, hz, rq) * rezmix;
	//	read = BPF.ar(read, hz, rq) * rezmix;
	Out.ar(out, Pan2.ar(read * ampenv * level * 0.6, pan));
}).send(s);



SynthDef.new(\krbuspangrain, {
	arg buf=0, out=0, amp=0.25,
	trig_bus = 0,
	pos_bus = 1,
	dur_bus = 2,
	rate_bus = 3,
	pan_bus = 4,
	maxgrains = 64,
	env_buf = -1,
	amplag=4.0;

	var trig, pos, dur,
	rate, pan,
	snd;

	trig = In.kr(trig_bus);
	pos = In.kr(pos_bus);
	dur = In.kr(dur_bus);
	rate = In.kr(rate_bus);
	pan = In.kr(pan_bus);

	amp = Lag.kr(amp, amplag);

	snd = GrainBuf.ar(
		numChannels:2,
		trigger:trig,
		dur:dur,
		sndbuf:buf,
		rate:rate,
		pos:pos,
		interp:2,
		pan:pan,
		envbufnum:env_buf,
		maxGrains:maxgrains,
		mul:amp);

	Out.ar(out, snd);
}).send(s);