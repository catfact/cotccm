
SynthDef.new(\adc, {arg in=0, out=0, amp=1, amplag = 0.01;
	var sig;
	amp = Lag.kr(amp, amplag);
	sig = SoundIn.ar(in);
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
	arg out=0, buf=0,
	pos=0.0, rate=1.0, loop=0,
	atk=0.01, dur=10.0, rel=0.01, gate=1, doneaction=2,
	looptime=2.0;
	var sig, amp, env, trig;
	env = Env.asr(atk, 1.0, rel);
	amp = EnvGen.ar(env, gate, doneAction:doneaction);
	trig = Impulse.kr(1.0 / looptime);
	sig = PlayBuf.ar(1, buf, rate, trig, pos, loop:loop);
	Out.ar(out, sig * amp);
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
	dur=4.0;
	
	var ampenv, pos, trig, phase, read,
	sr, frames, ratescale, framediff;
	
	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	framediff = maxframes - minframes;
	
	ampenv = EnvGen.ar(Env.linen(atk, dur, rel), gate:gate, doneAction:2);
	
	trig = Impulse.ar(choprate);
	
	pos = LFSaw.kr(posrate / framediff * sr, 0, framediff, minframes).wrap(minframes, maxframes - (sr / choprate));
	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:1);
	
	Out.ar(out, read * ampenv * level);
}).send(s);


SynthDef.new(\echo, {
	arg in, out, time, maxtime=1.0, amp=1.0;
	Out.ar(out, DelayL.ar(In.ar(in), maxtime, time) * amp);
}).send(s);

SynthDef.new(\cmpcho, {
	arg in, out, time, maxtime=1.0, amp=1.0,
		thresh=0.125, slopebelow=100000.0, slopeabove=1.0, clamp=0.1, relax=0.1;
	var input, del;
	input = In.ar(in);
	del =  DelayL.ar(input, maxtime, time);
	del = Compander.ar(del, input, thresh, slopebelow, slopeabove, clamp, relax);
	Out.ar(out, del * amp);
}).send(s);