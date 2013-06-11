~rbl = 30.0;

~rb = Buffer.alloc(s, s.sampleRate * ~rbl, 1);

~inb = Bus.audio(s, 1);

~ins = { Out.ar(~inb.index, SoundIn.ar(0)); }.play(s);

SynthDef.new(\rec, {
	arg in=0, buf=0,
	reclevel=1.0, prelevel=0.0, offset=0.0, trig=1.0, loop=1, run=1;

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

SynthDef.new(\amptrig, {
	arg in=0, thresh = -32.dbamp, lagdown=1.0, lagup=0.001;
	var amp;
	amp = Amplitude.kr(In.ar(in));
	amp = LagUD.kr(amp, lagup, lagdown);
	SendTrig.kr(amp > thresh, 0, 1.0);
	SendTrig.kr(amp < thresh, 0, 0.0);
}).send(s);

~inb.scope;

o = OSCFunc({ arg msg, time;
	[time, msg].postln;
},'/tr', s.addr);


z = Synth("amptrig", [\in, ~inb.index], ~ins, \addAfter);
z.set(\thresh, -24.dbamp);
z.set(\lagdown, 2.0);


o.free;


