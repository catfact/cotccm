SynthDef.new(\chopgrain, {
	
	arg buf, out=0, level=1.0,
	rate=1.0, choprate=1.0, posrate=0.25,
	atk=1.0, rel=1.0, gate=1,
	minframes=0, maxframes=44100;
	
	var ampenv, pos, trig, phase, read,
	sr, frames, ratescale;
	
	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	
	ampenv = EnvGen.ar(Env.asr(atk, 1.0, rel), gate:gate, doneAction:2);
	
	pos = Phasor.kr(1, posrate * ratescale, minframes, maxframes);
	trig = Impulse.ar(1.0 / choprate);
	
	phase = Phasor.ar(trig, rate * ratescale, resetPos:pos).wrap(minframes, maxframes);
	read = BufRd.ar(1, buf, phase);
	
	Out.ar(out, read * ampenv * level);
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
//	pos = Phasor.kr(1, posrate * ratescale, minframes, maxframes);
//	phase = Phasor.ar(trig, rate * ratescale, resetPos:pos).wrap(minframes, maxframes);
//	read = BufRd.ar(1, buf, phase);
	
	pos = LFSaw.kr(posrate / framediff * sr, 0, framediff, minframes).wrap(minframes, maxframes - (sr / choprate));
	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:1);
	
	Out.ar(out, read * ampenv * level);
}).send(s);



w = Synth.new(\chopgrain, [
	\buf, ~vla_loop1_buf.bufnum, 
	\minframes, 0, \maxframes, s.sampleRate * 8.0,
	\choprate, 1.0
]);

x = Synth.new(\chopgrain, [
	\buf, ~vla_loop1_buf.bufnum, 
	\minframes, 0, \maxframes, s.sampleRate * 8.0,
	\choprate, 2.0
]);

y = Synth.new(\chopgrain, [
	\buf, ~vla_loop1_buf.bufnum, 
	\minframes, 0, \maxframes, s.sampleRate * 8.0,
	\choprate, 1.5,
	\rate, 2.0, \posrate, 0.25
]);

z = Synth.new(\chopgrain, [
	\buf, ~vla_loop1_buf.bufnum, 
	\minframes, 0, \maxframes, s.sampleRate * 8.0,
	\choprate, 4.0,
	\rate, 4.0, \posrate, 0.5
]);

///// f maj 7
x.set(\rate, 9/10);
y.set(\rate, 9/5 * 3/2);
z.set(\rate, 18/10);
w.set(\rate, 9/5 * 5/4)

w.set(\gate, 0);
x.set(\gate, 0);
y.set(\gate, 0);
z.set(\gate, 0);


~vla_loop1_buf.plot