~grbuflen = 128.0;

~grg = Group.new;

~grmaxbufs = 8;
~grbuf= Array.fill(~grmaxbufs, { Buffer.alloc(s, s.sampleRate * ~grbuflen, 1); });

SynthDef.new(\gr, {arg buf, out=0, amp=1.0,
	trigrate=0.0, trignoise = 0.5, trignoiserate=0.25,
	rate=1.0, posrate=0.25, len=1.0,
	durmin=0.24, durmax=0.4, durnoiserate=1.0,
	gate=1, atk=0.1, rel=0.1, curve=0.0,
	lpfhz=6000.0, hpfhz=20.0;

	var trig, snd, dur, pos, env;


	env = EnvGen.ar(Env.asr(atk, 1.0, rel, curve), gate, doneAction:2);

	trig = Impulse.kr(trigrate * (1.0 + LFNoise1.kr(trignoiserate, trignoise)));
	dur = LFNoise1.kr(durnoiserate, durmax-durmin, durmin);
	pos = LFTri.kr(posrate / len * (1.0 + LFNoise1.kr([0.5, 0.75], 0.125)),
		0, // initial phasae
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
		s.sync;
		buf.normalize;
		s.sync;

		~grsyn.add( Synth.new(\gr, [
			\buf, buf.bufnum,
			\amp, 0.5,
			\trigrate, 10.0,
			\trignoise, 0.5,
			\len, dur
			//			\len, dur / ~grbuflen * 0.9
		], ~grg) );
	}.play;
};

~grstopplay = {
	~grsyn.last.set(\gate, 0);
	~grsyn.pop;
};


~grkill = {
	~grg.set(\gate, 0);
	~grsyn.clear;
}