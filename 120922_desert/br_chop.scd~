Routine { 

SynthDef.new('rlpfbuf', { arg buf, out, amp, atk, rel, sus, rate, pos, hz, rq;
	var ampenv, sig;
	ampenv = EnvGen.ar(Env.linen(atk, sus, rel), 1, doneAction:2);
	//	sig = SinOsc.ar(110).dup;
	sig = PlayBuf.ar(1, buf, rate, startPos:pos);
	sig = RLPF.ar(sig, hz, rq);
	sig = sig * ampenv * amp;
	sig = sig.dup;
	Out.ar(out, sig);
}).send(s);

s.sync;

	/*
~gr = { arg pos;
	pos = pos * ~bbuf.sampleRate;
	Synth.new(\rlpfbuf, [
		\buf, ~bbuf.bufnum,
		\pos, pos,
		\amp, 1.0,
		\atk, 1.0,
		\sus, 2.0,
		\rel, 2.0,
		\rate, 0.5, 
		\hz, 1000, 
		\rq, 1.0, 
		//		\out, c.out_b.index
		\out, 0
	], target:c.xg);
};


~gr.value(0.0);
~gr.value(20.0);
~gr.value(20.0);
	*/

~pos = 60.0;
~atk = 0.25;
~sus = 1.0;
~rel = 1.0;
~hz = 400;
~rate = 0.25;
~rq = 0.25;
~tw = 0.5;
~twr = 1.2;

~tr = Routine{ inf.do {
		Synth.new(\rlpfbuf, [
		\buf, ~bbuf.bufnum,
		\pos, 44100 * ~pos,
		\amp, 0.25,
		\atk, ~atk,
		\sus, ~sus,
		\rel, ~rel,
		\rate, ~rate, 
		\hz, ~hz, 
		\rq, ~rq, 
		//		\out, c.out_b.index
		\out, 0
	], target:c.xg);
	~tw.wait;
} }.play;



~tr2 = Routine{ inf.do {
		Synth.new(\rlpfbuf, [
		\buf, ~bbuf.bufnum,
		\pos, 44100 * ~pos,
		\amp, 0.25,
		\atk, ~atk * ~twr,
		\sus, ~sus * ~twr,
		\rel, ~rel * ~twr,
		\rate, ~rate, 
		\hz, ~hz, 
		\rq, ~rq, 
		//		\out, c.out_b.index
		\out, 0
	], target:c.xg);
	(~tw * ~twr).wait;
} }.play;



}.play;


	/*

~pos = 120.0;

~tr.stop;
~tr2.stop;


~pos = 120.0;
~rq = 0.25;
~hz = 440;


	*/