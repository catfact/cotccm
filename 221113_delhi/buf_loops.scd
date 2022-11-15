SynthDef.new(\stereo_loop, {
	arg buf, out=0, amp=0.5, amplag=4,
	gate=1, atk=4, rel=6,
	rate1=0.2, rate2= 0.25,
	hpf=10, lpf=16000,
	start1=0, start2=0,
	dur1=32, dur2=32,
	rateLag=2;

	var sr = BufSampleRate.ir(buf);
	var phase = [
		Phasor.ar(0, Lag.kr(rate1, rateLag), 0, sr*dur1),
		Phasor.ar(0, Lag.kr(rate2, rateLag), 0, sr*dur2)
	];
		// + sr*[start1, start2];
	var snd = BufRd.ar(1, buf, phase);
//	snd = LPF.ar(HPF.ar(snd, hpf), lpf);
	snd = snd * EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	Out.ar(out, snd*amp.lag(amplag))
}).send(s);


~bl = {
	arg bufObj,
	rate1=1, rate2=1,
	dur1=nil, dur2=nil,
	startPos=0;

	if (dur1.isNil, {dur1 = bufObj.buf.duration;});
		if (dur2.isNil, {dur2 = bufObj.buf.duration;});
	Synth.new(\stereo_loop, [
		\out, ~out_b.index,
		\buf, bufObj.buf.bufnum,
		\rate1, rate1, \rate2, rate2,
		\dur1, dur1, \dur2, dur2,
		\startPos, startPos
	], ~xg);
};