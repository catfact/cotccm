~grain_g = Group.after(~in_g);

~grbuflen = 6.0;
~grbuf = Buffer.alloc(s, s.sampleRate * ~grbuflen);

SynthDef.new(\bufgrain, {
	arg buf, out=0, amp=0.25,
	rate=1.0, trigrate=4.0, posrate=0.25, dur=0.5,
	lpfhz=4000, hpfhz=300;

	var grains, trig, pos;
	trig = Impulse.kr(trigrate);
	pos = Phasor.kr(0, posrate / BufDur.kr(buf));
	grains = BufGrain.ar(trig, dur, buf, rate, pos);
	grains = LPF.ar(grains, lpfhz);
	grains = HPF.ar(grains, hpfhz);
	Out.ar(out, grains * amp);
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

~grrec.free;
~grbufplay = Synth.new(\bufgrain, [\buf, ~grbuf.bufnum]);
~grbufplay.set(\rate, 2.0);

~grbufplay2 = Synth.new(\bufgrain, [\buf, ~grbuf.bufnum]);
~grbufplay2.set(\posrate, 0.35);
~grbufplay2.set(\rate, 1.5);

~grbufplay.set(\gate, 0);
~grbufplay2.set(\gate, 0);

~grbufplay.free;
~grbufplay2.free;
