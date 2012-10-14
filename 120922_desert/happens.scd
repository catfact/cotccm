Routine { 

~rec.free;	
~bct = SystemClock.seconds - ~bct;

x.value("bc_chop.scd");

~analist = ~analist.sort({ arg a, b; a.pitch < b.pitch });
~hzl = ~analist.collect({ arg ev; ev.pitch });

x.value("sines.scd");


SynthDef.new('rlpfsawsin', { arg out=0, amp=0.25, atk=4.0, rel=4.0, sus=1.0, hz, fhz=10000, rq=1.0, sine=1.0, saw=0.0;
	var ampenv, sig;
	ampenv = EnvGen.ar(Env.linen(atk, sus, rel), 1, doneAction:2);
	//	sig = SinOsc.ar(110).dup;
	//		sig = PlayBuf.ar(1, buf, rate, startPos:pos);
	sig = SinOsc.ar(hz) * sine;
	sig = Mix.new(sig + (Saw.ar(hz) * saw));
	sig = RLPF.ar(sig, fhz, rq);
	sig = sig * ampenv * amp;
	sig = sig.dup;
	Out.ar(out, sig);
}).send(s);

s.sync;

x.value("sine_seq.scd");



}.play;