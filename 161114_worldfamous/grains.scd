~grbuflen = 128.0;

~grg = Group.new;

~grmaxbufs = 8;
~grbuf= Array.fill(~grmaxbufs, { Buffer.alloc(s, s.sampleRate * ~grbuflen, 1); });

~norm_buf = Buffer.alloc(s, s.sampleRate * ~grbuflen, 1);

SynthDef.new(\gr, {arg buf, out=0, amp=1.0,
	trigrate=0.0, trignoise = 0.5, trignoiserate=0.25,
	rate=1.0, posrate=0.25, len=1.0,
	durnoise=0.25, durbase=1.5, durnoiserate=1.0,
	posnoise=0.125, posnoiserate=0.25,
	gate=1, atk=0.1, rel=0.1, curve=0.0,
	lpfhz=6000.0, hpfhz=20.0;

	var trig, snd, dur, pos, env;


	env = EnvGen.ar(Env.asr(atk, 1.0, rel, curve), gate, doneAction:2);

	trigrate = trigrate * (1.0 + LFNoise1.kr(trignoiserate, trignoise));
	trig = Impulse.kr(trigrate);
	dur = (1 + LFNoise1.kr(durnoiserate, durnoise, durbase)) / trigrate;
	//	pos = LFTri.kr(posrate / len * (1.0 + LFNoise1.kr([0.5, 0.75], 0.125)),
	
	pos = LFTri.kr(posrate / len * (1.0 + LFNoise1.kr(posnoiserate, posnoise)),
		0, // initial phase
		len / BufDur.kr(buf) * 0.9 // multiplier
	).abs; 
	snd = BufGrain.ar(trig, dur, buf, rate, pos);

	snd = LPF.ar(snd, lpfhz);
	snd = HPF.ar(snd, hpfhz);

	Out.ar(out, snd * env * amp);
}).send(s);

SynthDef.new(\rec, {arg buf, in;
	RecordBuf.ar(SoundIn.ar(in), buf);
}).send(s);

~grtap = CfTapper.new;
// list of synths
~grsyn = List.new;

~grstartrec = {
	~grtap.tap;
	~grrec = Synth.new(\rec, [\in, 1, \buf, ~grbuf.last.bufnum]);
};

~grstoprec = {
	var dur, buf;
	dur = ~grtap.tap;
	~grrec.free;
	postln("stop recording, dur: " ++ dur);
	buf = ~grbuf[~grsyn.size];
	Routine {
		buf.zero;
		s.sync;
		~grbuf.last.copyData(buf, numSamples:dur * s.sampleRate);
		~norm_buf.clear;
		s.sync;
		/*
		~grbuf.last.copyData(~norm_buf, numSamples:dur * s.sampleRate);
		~norm_buf.normalize;
		*/
		s.sync;
		//		buf.normalize;
		//		s.sync;

		~grsyn.addFirst( Synth.new(\gr, [
			\buf, buf.bufnum,
			\amp, 0.5,
			\trigrate, 4,
			\trignoise, 0.25,
			\len, dur,
			\posnoise, 0.0,
			\durmin: 2.245,
			\durmax: 2.8
			//			\len, dur / ~grbuflen * 0.9
		], ~grg) );
	}.play;
};

~grstopplay = {
	~grsyn.last.set(\gate, 0);
~grsyn.pop;
~grsyn.postln;
};


~grstopfirst = {
	~grsyn.first.set(\gate, 0);
~grsyn.removeAt(0);
~grsyn.postln;
};



~grkill = {
	~grg.set(\gate, 0);
	~grsyn.clear;
}