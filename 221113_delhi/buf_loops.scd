

SynthDef.new(\stereo_loop, {
	arg buf, amp=05,
	rate1=0.2, rate2= 0.25,
	hpf=10, lpf=16000,
	trigDur1=inf, trigDur2=inf, startPos=0, loop=1;

	var trig = Impulse.ar(1/[trigDur1, trigDur2]);
	var snd = PlayBuf.ar(1, buf, [rate1, rate2], trig, startPos, loop);

	snd = LPF.ar(HPF.ar(snd, hpf), lpf);
	Out.ar(~out_b.index, snd*amp)
}).send(s);


~bl = {
	arg bufObj,
	rate1=1, rate2=1,
	startPos=0;

	var dur = bufObj.total_dur.min(bufObj.buf.duration);
	var trigDur1 = dur / rate1;
	var trigDur2 = dur / rate2;

	Synth.new(\stereo_loop, [
		\buf, bufObj.buf.bufnum,
		\rate1, rate1, \rate2, rate2,
		\trigDur1, trigDur1, \trigDur2, trigDur2,
		\startPos, startPos
	], ~xg);
};