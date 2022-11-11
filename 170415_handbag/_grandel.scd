~grain_g = Group.after(~in_g);

~grbuflen = 36.0;
~grbuf = Buffer.alloc(s, s.sampleRate * ~grbuflen);

SynthDef.new(\bufgrain, {
	arg buf, out=0, amp=0.25,
	rate=1.0, trigrate=4.0, posrate=0.25, dur=0.5,
	lpfhz=4000, hpfhz=800, pan=0;

	var grains, trig, pos;
	trig = Impulse.kr(trigrate);
	pos = Phasor.kr(0, posrate / BufDur.kr(buf));
	grains = GrainBuf.ar(1, trig, dur, buf, rate, pos);
//	grains = BufGrain.ar(trig, dur, buf, rate, pos);
	grains = LPF.ar(grains, lpfhz);
	grains = HPF.ar(grains, hpfhz);
	Out.ar(out, Pan2.ar(grains, pan), amp);
}).send(s);

// testing..

~testbuf = Buffer.read(s, p ++ "believing.wav");
//~testbuf.plot;

~testbus = Bus.audio(s, 1);
~testplay = { Out.ar(~testbus.index, PlayBuf.ar(1, ~testbuf.bufnum, loop:1)); }.play;

~testbus.scope;
~grbuf.zero;
~grandel = Synth.new(\grandel, [\in, ~testbus.index, \buf, ~grbuf.bufnum], ~testplay, \addAfter);

~grandel.free;

~testmon = { Out.ar(0, In.ar(~testbus.index).dup * 0.125) }.play(target:~testplay, addAction:\addAfter);
~testmon.free;

~grrec = Synth.new(\rec_smooth, [\buf, ~grbuf.bufnum, \in, ~testbus.index, \loop, 1], ~testplay, \addAfter);

~grrec = { RecordBuf.ar(SoundIn.ar(0), ~grbuf.bufnum) }.play(s);

~grrec.free;
~grbufplay = Synth.new(\bufgrain, [\buf, ~grbuf.bufnum, \pan, -1]);
~grbufplay.set(\rate, 1.5);
~grubfplay.free;

~grbufplay2 = Synth.new(\bufgrain, [\buf, ~grbuf.bufnum, \rate, 2.0, \pan, 1]);
~grbufplay2.set(\posrate, 0.25);
~grbufplay2.set(\rate, 1.25);

~grbufplay3 = Synth.new(\bufgrain, [\buf, ~grbuf.bufnum, \rate, 1.0, \pan, 1]);
~grbufplay3.set(\posrate, 0.2);
~grbufplay3.set(\rate, 1.25);
~grbufplay3.set(\pan, 0.1);

~grbufplay.set(\gate, 0);
~grbufplay2.set(\gate, 0);

~grbufplay.free;
~grbufplay2.free;
~grbufplay3.free;