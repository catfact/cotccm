
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

	Out.ar(out, sig * amp);
	
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

	Out.ar(out, sig * env);
	
}).send(s);

SynthDef.new(\brown, {
	arg out, amp;
	Out.ar(out, BrownNoise.ar * amp);
});

SynthDef.new(\rlpf, {
	arg out, in, amp, amplag, hz, hzlag, rq, rqlag;
	hz = Lag.kr(hz, hzlag);
	rq = Lag.kr(rq, rqlag);
	amp = Lag.kr(amp, amplag);
	ReplaceOut.ar(out, RLPF.ar(In.ar(in), hz, rq) * amp );
}).send(s);
	
SynthDef.new(\rlpf_rep, {
	arg out, in, amp, amplag, hz, hzlag, rq, rqlag;
	hz = Lag.kr(hz, hzlag);
	rq = Lag.kr(rq, rqlag);
	amp = Lag.kr(amp, amplag);
	ReplaceOut.ar(out, RLPF.ar(In.ar(in), hz, rq) * amp );
}).send(s);

SynthDef.new(\echo_rlpf_shift_dist, {
	arg in=0, 
	out=0,
	buf=0,
	amp = 1.0, amplag = 1.0,
	inputamp = 1.0,
	delaytime= 1.0,
	feedback = 0.0,
	hz=9000, rq=0.8,
	hzlag, rqlag,
	fmix = 0.5,
	fmixlag = 2.0,
	shift=0.5,
	shiftmix = 0.5,
	shiftwin = 0.25,
	shiftdisp = 0.1,
	shiftlag = 0.01,
	distmix;

	var delay, os;

	hz = Lag.kr(hz, hzlag);
	rq = Lag.kr(rq, rqlag);
	amp = Lag.kr(amp, amplag);
	fmix = Lag.kr(fmix, fmixlag);
	shift = Lag.kr(shift, shiftlag);

	delay = BufDelayL.ar(buf, (In.ar(in) * inputamp) + (LocalIn.ar(1)), delaytime) * amp;
	os = delay * (1.0 - shiftmix) + (shiftmix * PitchShift.ar(delay, shiftwin, shift));
	os = (1.0 - distmix) * os + (distmix * os.distort.distort.distort.softclip);
	os = (1.0 - fmix)*os + (fmix * RLPF.ar(os, hz, rq) );
	LocalOut.ar(os * feedback);
	Out.ar(out, (os * amp));
}).send(s);


/*
SynthDef.new(\varsaw_rlpf_env, {
	arg out=0, amp=0.0, hz=110, gate = 1,
	atk_amp = 0.01, dec_amp=0.0, sus_amp=1.0, rel_amp=1.0,
	atk_hz = 0.01, dec_hz=0.0, sus_hz=1.0, rel_hz=1.0,
	atk_fhz = 0.01, dec_fhz=0.0, sus_fhz=1.0, rel_fhz=1.0,
	atk_rq = 0.01, dec_rq=0.0, sus_rq=1.0, rel_rq=1.0,
	atk_shape = 0.01, dec_shape=0.0, sus_shape=1.0, rel_shape=1.0,
	env_amp, env_hz, env_fhz, env_rq;


	var _amp, _hz, _fhz, _rq, _shape, xosc;

	//...
});
*/