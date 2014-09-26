
SynthDef.new(\pm3, { 
	arg out=0, amp=0.25, amplag=1.0,
	hz1=220, hz2=330, hz3=110,
	shape1=0, shape2=0, shape3=0,
	pm12=0, pm23=0, pm31=0,
	pm12del=0, pm23del=0, pm31del=0,
	amp1=1, amp2=1, amp3=1,
	amp1lag=1.0, amp2lag=2.0, amp3lag=3.0,
	hz1lag=0, hz2lag=0, hz3lag=0,
	pm12lag=0, pm23lag=0, pm31lag=0,
	lpfhz = 880, lpfrq = 0.8;

	var osc1, osc2, osc3, sig;

	amp = Lag.kr(amp, amplag);

	hz1 = Lag.kr(hz1, hz1lag);
	hz2 = Lag.kr(hz2, hz2lag);
	hz3 = Lag.kr(hz3, hz3lag);

	amp1 = Lag.kr(amp1, amp1lag);
	amp2 = Lag.kr(amp2, amp2lag);
	amp3 = Lag.kr(amp3, amp3lag);
	
	pm12 = Lag.kr(pm12, pm12lag);
	pm23 = Lag.kr(pm23, pm23lag);
	pm31 = Lag.kr(pm31, pm31lag);

	osc1 = SinOsc.ar(hz1, DelayL.ar(LocalIn.ar(1) * pm31 * pi, 1.0, pm31del));
	osc2 = SinOsc.ar(hz2, DelayL.ar(osc1 * pm12 * pi, 1.0, pm12del));
	osc3 = SinOsc.ar(hz3, DelayL.ar(osc2 * pm23 * pi, 1.0, pm23del));
	LocalOut.ar(osc3);

	sig = Mix.ar([osc1 * amp1, osc2 * amp2, osc3 * amp3]);
	sig = RLPF.ar(sig, lpfhz, lpfrq);

	Out.ar(0, sig * amp);
	
}).send(s);

SynthDef.new(\pm3_1shot, { 
	arg out=0, amp=0.25, amplag=1.0,
	hz1=220, hz2=330, hz3=110,
	shape1=0, shape2=0, shape3=0,
	pm12=0, pm23=0, pm31=0,
	pm12del=0, pm23del=0, pm31del=0,
	amp1=1, amp2=1, amp3=1,
	amp1lag=1.0, amp2lag=2.0, amp3lag=3.0,
	hz1lag=0, hz2lag=0, hz3lag=0,
	pm12lag=0, pm23lag=0, pm31lag=0,
	atk=1.0, sus=1.0, rel=1.0,
	lpfhz = 880, lpfrq = 0.8,
	lpfhzlag=4.0, lpfrqlag = 4.0;

	var osc1, osc2, osc3;
	var sig, env;

	lpfhz = Lag.kr(lpfhz, lpfhzlag);
	lpfrq = Lag.kr(lpfrq, lpfrqlag);
	
	amp = Lag.kr(amp, amplag);

	hz1 = Lag.kr(hz1, hz1lag);
	hz2 = Lag.kr(hz2, hz2lag);
	hz3 = Lag.kr(hz3, hz3lag);

	amp1 = Lag.kr(amp1, amp1lag);
	amp2 = Lag.kr(amp2, amp2lag);
	amp3 = Lag.kr(amp3, amp3lag);
	
	pm12 = Lag.kr(pm12, pm12lag);
	pm23 = Lag.kr(pm23, pm23lag);
	pm31 = Lag.kr(pm31, pm31lag);

	osc1 = SinOsc.ar(hz1, DelayL.ar(LocalIn.ar(1) * pm31 * pi, 1.0, pm31del));
	osc2 = SinOsc.ar(hz2, DelayL.ar(osc1 * pm12 * pi, 1.0, pm12del));
	osc3 = SinOsc.ar(hz3, DelayL.ar(osc2 * pm23 * pi, 1.0, pm23del));
	LocalOut.ar(osc3);

	sig = Mix.ar([osc1 * amp1, osc2 * amp2, osc3 * amp3]) * amp;
	sig = RLPF.ar(sig, lpfhz, lpfrq);

	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);

	sig = RLPF.ar(sig, lpfhz, lpfrq);

	Out.ar(0, sig * env);
	
}).send(s);

