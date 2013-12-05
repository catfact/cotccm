SynthDef.new(\adc, {arg in=0, out=0, amp=1, amplag = 0.01;
	var sig;
	amp = Lag.kr(amp, amplag);
	sig = SoundIn.ar(in);
	Out.ar(out, sig * amp);
}).send(s);

SynthDef.new(\patch_pan, {arg in=0, out=0, amp=1, amplag = 0.01, pan=0.0;
	var sig;
	amp = Lag.kr(amp, amplag);
	sig = In.ar(in);
	Out.ar(out, Pan2.ar(sig * amp, pan));
}).send(s);

SynthDef.new(\patch, {arg in=0, out=0, amp=1, amplag = 0.01, pan=0.0;
	var sig;
	amp = Lag.kr(amp, amplag);
	sig = In.ar(in);
	//	Out.ar(out, Pan2.ar(sig * amp, pan));
	Out.ar(out, sig * amp);
}).send(s);


SynthDef.new(\rec, {
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
		trigger:trig
	);
}).send(s);


SynthDef.new(\rec_loop, {
	arg in=0, buf=0,
		reclevel=1.0, prelevel=0.0, offset=0.0, loop=0, run=1,
		atk=0.01, rel=0.01, gate=1,
		looptime=2.0;
	var trig;
	trig = Impulse.ar(1.0/looptime);
	RecordBuf.ar(In.ar(in, 1),
		bufnum: buf, 
		offset:0,
		recLevel:reclevel,
		preLevel:prelevel,
		run:run,
		loop:loop,
		trigger:trig
	);
}).send(s);

SynthDef.new(\play, {arg out=0, buf=0, trig=0, pos=0.0, rate=1.0, loop=0, atk=0.01, rel=0.01, gate=1, doneaction=2;
	var sig, amp, env;
	env = Env.asr(atk, 1.0, rel);
	amp = EnvGen.ar(env, gate, doneAction:doneaction);
	sig = PlayBuf.ar(1, buf, rate, trig, pos, loop:loop);
	Out.ar(out, sig * amp);
}).send(s);


SynthDef.new(\play_loop, {
	arg out=0, buf=0, level=1.0,
	pos=0.0, rate=1.0, loop=0,
	atk=0.01, dur=10.0, rel=0.01, gate=1, doneaction=2,
	looptime=2.0;
	var sig, amp, env, trig;
	env = Env.asr(atk, 1.0, rel);
	amp = EnvGen.ar(env, gate, doneAction:doneaction);
	trig = Impulse.kr(1.0 / looptime);
	sig = PlayBuf.ar(1, buf, rate, trig, pos, loop:loop);
	Out.ar(out, sig * amp * level);
}).send(s);


SynthDef.new(\chopgrain, {
	arg buf, out=0, level=1.0,
	rate=1.0, choprate=1.0, posrate=0.25,
	atk=1.0, rel=1.0, gate=1,
	minframes=0, maxframes=44100;
	
	var ampenv, pos, trig, phase, read,
	sr, frames, ratescale, framediff;
	
	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	framediff = maxframes - minframes;
	
	ampenv = EnvGen.ar(Env.asr(atk, 1.0, rel), gate:gate, doneAction:2);
	
	trig = Impulse.ar(choprate);
	
	pos = LFSaw.kr(posrate / framediff * sr, 0, framediff, minframes).wrap(minframes, maxframes - (sr / choprate));
	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:1);
	
	Out.ar(out, read * ampenv * level);
}).send(s);


SynthDef.new(\chopgrain_1shot, {
	arg buf, out=0, level=1.0,
	rate=1.0, choprate=1.0, posrate=0.25,
	atk=1.0, rel=1.0, gate=1,
	minframes=0, maxframes=44100,
	dur=4.0, posphase=0.0;
	
	var ampenv, pos, trig, phase, read,
	sr, frames, ratescale, framediff;
	
	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	framediff = maxframes - minframes;
	
	ampenv = EnvGen.ar(Env.linen(atk, dur, rel), gate:gate, doneAction:2);
	
	trig = Impulse.ar(choprate);
	
	pos = LFSaw.kr(posrate / framediff * sr, posphase, framediff, minframes).wrap(minframes, maxframes - (sr / choprate));
	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:1);
	
	Out.ar(out, (read * ampenv * level * 0.6).dup);
}).send(s);


SynthDef.new(\chopgrain_1shot_fixpos, {
	arg buf, out=0, level=1.0,
	rate=1.0, choprate=1.0, posrate=0.25,
	atk=1.0, rel=1.0, gate=1,
	minframes=0, maxframes=44100,
	dur=4.0, pos=0.0;
	
	var ampenv, trig, phase, read,
	sr, frames, ratescale, framediff;
	
	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	framediff = maxframes - minframes;
	
	ampenv = EnvGen.ar(Env.linen(atk, dur, rel), gate:gate, doneAction:2);
	
	trig = Impulse.ar(choprate);
	
	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:1);
	
	Out.ar(out, (read * ampenv * level * 0.6).dup);
}).send(s);


SynthDef.new(\chopgrain_1shot_rez_dist, {
	arg buf, out=0, level=1.0,
	hz=(440 * 8/9), rq=0.4,
	rate=1.0, choprate=1.0, posrate=0.25,
	atk=1.0, rel=1.0, gate=1,
	minframes=0, maxframes=44100,
	dur=4.0, posphase=0.0, insideout=0.0;
	
	var ampenv, pos, trig, phase, read,
	sr, frames, ratescale, framediff;
	
	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	framediff = maxframes - minframes;
	
	ampenv = EnvGen.ar(Env.linen(atk, dur, rel), gate:gate, doneAction:2);
	
	trig = Impulse.ar(choprate);
	
	pos = LFSaw.kr(posrate / framediff * sr, posphase, framediff, minframes).wrap(minframes, maxframes - (sr / choprate));
	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:1);
	
	//	read = read + InsideOut.ar(read, insideout);
	
	read = Resonz.ar(read, hz, rq);
	
	Out.ar(out, (read * ampenv * level * 0.6).dup);
}).send(s);



	SynthDef.new(\echo, {
	arg in, out, time, maxtime=1.0, amp=1.0;
	Out.ar(out, DelayL.ar(In.ar(in), maxtime, time) * amp);
}).send(s);

SynthDef.new(\echo_buf, {
	arg buf, in, out, time, amp=1.0;
	Out.ar(out, BufDelayL.ar(buf, In.ar(in), time, amp));
}).send(s);


SynthDef.new(\cmpcho, {
	arg in, out, time, maxtime=1.0, amp=1.0,
		thresh=0.125, slopebelow=4.0, slopeabove=1.0, clamp=0.7, relax=0.3;
	var input, del;
	input = In.ar(in);
	del =  DelayL.ar(input, maxtime, time);
	del = Compander.ar(del, input, thresh, slopebelow, slopeabove, clamp, relax);
	Out.ar(out, del * amp);
}).send(s);

SynthDef.new(\buf_ringz_lpf_env, {
	arg out=0,
	buf=0,
	amp = 1.0,
	ringhz = 200,
	lpfhz = 2000,
	pulsehz = 1.0,
	ringmix = 0.0625,
	envattack=0.01, envdecay = 5.0,
	ringdecay =  0.01,
	startpos=0.0,
	rate=1.0,
	level = 1.0,
	loop = 0,
	trig = 0;
	
	var pulse, player, env, ring, lpf, output;
	
	pulse = Impulse.ar(pulsehz);
	player = PlayBuf.ar(1, buf, rate:rate, trigger:trig, startPos:startpos, loop:loop);
	player = PlayBuf.ar(1, buf, rate:rate, trigger:pulse, startPos:startpos, loop:loop);
	ring = Ringz.ar(player, ringhz, ringdecay);
	ring = (ring * ringmix) + (player * (1.0 - ringmix));
	lpf = LPF.ar(ring, lpfhz);
	//	env = Decay2.ar(pulse, envattack, envdecay);
	//output = env * lpf * amp;
	//	output = player * amp;
	output = lpf * amp;
	Out.ar(out, Pan2.ar(output) * level);
}).load(s);



SynthDef.new(\grain_1shot_rez_dist, {
	arg buf, out=0, level=1.0,
	hz=(440 * 8/9), rq=0.4, rezmix=1.0,
	rate=1.0, pos=0.0,
	atk=1.0, rel=1.0, gate=1,
	minframes=0, maxframes=44100,
	dur=4.0, insideout=0.0,
	trigrate = 1;
	
	var ampenv, trig, phase, read,
	sr, frames, ratescale, framediff;
	
	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	framediff = maxframes - minframes;
	
	trig = LFPulse.ar(trigrate);
	
	ampenv = EnvGen.ar(Env.linen(atk, dur, rel), gate:gate, doneAction:2);
	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:0);
	//	read = read + InsideOut.ar(read, insideout);
	read = (read * (1.0 - rezmix)) + Resonz.ar(read, hz, rq) * rezmix;
//	read = BPF.ar(read, hz, rq) * rezmix;
	Out.ar(out, (read * ampenv * level * 0.6).dup);
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

SynthDef.new(\saw_1shot_rez_dist, {
	arg buf, out=0, level=1.0,
	hz=440, rhz = 880, rq=0.4,
	rate=1.0, choprate=1.0, posrate=0.25,
	atk=1.0, rel=1.0, gate=1,
	minframes=0, maxframes=44100,
	dur=4.0, posphase=0.0, insideout=0.0,
	pan=0.0;
	
	var ampenv, pos, trig, phase, read,
	sr, frames, ratescale, framediff;
	
	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	framediff = maxframes - minframes;
	
	ampenv = EnvGen.ar(Env.linen(atk, dur, rel), gate:gate, doneAction:2);
	
	//	trig = Impulse.ar(choprate);
	
	//	pos = LFSaw.kr(posrate / framediff * sr, posphase, framediff, minframes).wrap(minframes, maxframes - (sr / choprate));
	//	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:1);
	
	//	read = read + InsideOut.ar(read, insideout);
	
	
	read = SinOsc.ar(hz * 0.5) + Saw.ar(hz);
	read = Resonz.ar(read, rhz, rq);
	
	Out.ar(out, Pan2.ar(read * ampenv * level * 0.6, pan) );
}).send(s);


SynthDef.new(\sine_1shot, {
	arg buf, out=0, level=1.0,
	hz=440, rhz = 880, rq=0.4,
	rate=1.0, choprate=1.0, posrate=0.25,
	atk=1.0, rel=1.0, gate=1,
	minframes=0, maxframes=44100,
	dur=4.0, posphase=0.0, insideout=0.0,
	pan=0.0;
	
	var ampenv, pos, trig, phase, read,
	sr, frames, ratescale, framediff;
	
	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	framediff = maxframes - minframes;
	
	ampenv = EnvGen.ar(Env.linen(atk, dur, rel), gate:gate, doneAction:2);
	
	//	trig = Impulse.ar(choprate);
	
	//	pos = LFSaw.kr(posrate / framediff * sr, posphase, framediff, minframes).wrap(minframes, maxframes - (sr / choprate));
	//	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:1);
	
	//	read = read + InsideOut.ar(read, insideout);
	
	
	read = SinOsc.ar(hz);
	//	read = Resonz.ar(read, rhz, rq);
	
	Out.ar(out, Pan2.ar(read * ampenv * level * 0.6, pan) );
}).send(s);

SynthDef.new(\noise_1shot_rez, {
	arg buf, out=0, level=1.0,
	hz=440, rhz = 880, rq=0.4,
	rate=1.0, choprate=1.0, posrate=0.25,
	atk=1.0, rel=1.0, gate=1,
	minframes=0, maxframes=44100,
	dur=4.0, posphase=0.0, insideout=0.0,
	pan=0.0;
	
	var ampenv, pos, trig, phase, read,
	sr, frames, ratescale, framediff;
	
	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	framediff = maxframes - minframes;
	
	ampenv = EnvGen.ar(Env.linen(atk, dur, rel), gate:gate, doneAction:2);
	
	//	trig = Impulse.ar(choprate);
	
	//	pos = LFSaw.kr(posrate / framediff * sr, posphase, framediff, minframes).wrap(minframes, maxframes - (sr / choprate));
	//	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:1);
	
	//	read = read + InsideOut.ar(read, insideout);
	
	
	read = WhiteNoise.ar;
	read = Resonz.ar(read, rhz, rq);
	
	Out.ar(out, Pan2.ar(read * ampenv * level * 0.6, pan) );
}).send(s);
