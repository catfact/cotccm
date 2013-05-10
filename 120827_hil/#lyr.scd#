// a simple multitrack overdubbing looper
///???

s = Server.local;
c = CfAudioContext.new(s, 2, { Routine {

	
	SynthDef.new(\phase, {
		arg out=0, trig=0, rate=1, start=0, end=1, pos=0;
		Out.ar(out, Phasor.ar(trig, rate, start, end, pos));
	}).send(s);

	SynthDef.new(\bufrd, {
		arg out, buf, phasebus, amp=1.0, amplag=1.0, loop=1;
		var sig;
		amp = Lag.kr(amp, amplag);
		sig = BufRd.ar(1, buf, In.ar(phasebus), loop);
		Out.ar(out, sig * amp);
	}).send(s);

	SynthDef.new(\bufwr, {
		arg in, buf, phasebus, pre=0.0, prelag=1.0;
		var sig, phase;
		phase = In.ar(phasebus);
		pre = Lag.kr(pre, prelag);
		sig = In.ar(in) + BufRd.ar(1, buf, phase) * pre;
		BufWr.ar(sig, buf, phase);
	}).send(s);

	s.sync;

	~blen = 360.0;
	~buf = List.new;
	~buf.add(Buffer.alloc(s, s.sampleRate * ~blen, 1));
	~phb = Bus.audio(s, 1);
	~phs = Synth.new(\phase, [
		\hz, 1.0, 
		\out, ~phb.index, 
		\end, ~buf[0].numFrames
	], c.ig, \addAfter);

	s.sync;

	~recs0 = Synth.new(\bufwr, [
		\in, c.in_b.index, 
		\buf, ~buf[0],
		\phasebus, ~phb.index,
		\pre, 0.0
	], ~phs, \addAfter);

	AppClock.sched(0, {	
		~bw0 = Window.new("b_0");
		CfBufferDisplay.new(s, ~buf[0], ~bw0, 64);
		~bw0.front;
		nil 
	});

	~echs = { Out.ar(0, DelayN.ar(In.ar(c.in_b.index), 1.0, 1.0)) }.play(c.ig, \addAfter);
	~echso = { Out.ar(0, DelayN.ar(SoundIn.ar(0), 1.0, 1.0)) }.play(s);
	~echso.free;
	
}.play; });