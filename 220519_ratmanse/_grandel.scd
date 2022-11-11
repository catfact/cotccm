Routine {
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

	s.sync;

	~grbuf.zero;

	//~grrec = Synth.new(\rec_smooth, [\buf, ~grbuf.bufnum, \in, ~testbus.index, \loop, 1], ~testplay, \addAfter);
	~grrec = { arg pre=0; RecordBuf.ar(SoundIn.ar(0), ~grbuf.bufnum, preLevel:pre) }.play(s);
	~grrec.set(\pre, 0.125);

	/*
	~grrec.free;
	*/
	~grbufplay = Synth.new(\bufgrain, [\buf, ~grbuf.bufnum, \pan, -1]);
	~grbufplay.set(\rate, -2/3);
	~grubfplay.free;

	~grbufplay2 = Synth.new(\bufgrain, [\buf, ~grbuf.bufnum, \rate, 2.0, \pan, 1]);
	~grbufplay2.set(\posrate, 0.2);
	~grbufplay2.set(\rate, 1);
		~grbufplay2.set(\hpfhz, 100);

	~grbufplay3 = Synth.new(\bufgrain, [\buf, ~grbuf.bufnum, \rate, 1.0, \pan, 1]);
	~grbufplay3.set(\posrate, 0.18);
	~grbufplay3.set(\rate, 5/4);
	~grbufplay3.set(\pan, 0.1);
			~grbufplay3.set(\hpfhz, 100);


	/*
	~grbufplay.set(\gate, 0);
	~grbufplay2.set(\gate, 0);

	~grbufplay.free;
	~grbufplay2.free;
	~grbufplay3.free;
	*/
}.play;