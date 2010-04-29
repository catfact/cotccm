s = Server.internal;
/*
s.quit;
*/
s.boot;

SynthDef.new(\adc, {
	arg in=0, out=0;
	Out.ar(out, SoundIn.ar(in));
}).load(s);

SynthDef.new(\buf_phasor, {
	arg buf, out, rate=1.0;
	Out.ar(out, Phasor.ar(0, rate * BufRateScale.kr(buf), 0.0, BufFrames.kr(buf)));
}).load(s);

SynthDef.new(\bufwr_mono, {
	arg in, buf, phasebus;
	BufWr.ar(In.ar(in, 1), buf, In.ar(phasebus, 1));
}).load(s);

SynthDef.new(\bufrd_del_mono, {
	arg out=0, buf=0, phasebus=0, delaytime=0.0, amp=1.0, amplag=0.01, allowSilence=1;
	var sig;
	amp = Lag.kr(amp, amplag);
	sig = BufRd.ar(1, buf, (In.ar(	) + (delaytime * SampleRate.ir.neg)).wrap(0.0, BufFrames.kr(buf) - 1));
	Out.ar(out, sig * amp);
	FreeSelf.kr(amp.max(allowSilence));
}).load(s);


SynthDef.new(\buf_phase_offset_grain, {
	arg out=0, buf=0, amp=1.0,
		attacktime=0.0, sustaintime=1.0, releasetime=0.0, curve=0.0,
		phasebus=0, rate=1.0, offset = -1.0;
	
	var phasor, sig, frames, env;
	frames = BufFrames.kr(buf);
	phasor = Phasor.ar(0, rate * BufRateScale.kr(buf), 0.0, frames);
	phasor = (phasor + DC.ar(In.ar(phasebus)) + offset).wrap(0.0, frames);
	sig = BufRd.ar(1, buf, phasor, 1, 4);
	env = EnvGen.ar(
		Env.new([0.0, 1.0, 1.0, 0.0], [attacktime, sustaintime, releasetime], curve),
		doneAction:2
	);
	Out.ar(out, env * amp * sig);
}).load(s);


SynthDef.new(\buf_pos_offset_grain, {
	arg out=0, buf=0, amp=1.0,
		attacktime=0.0, sustaintime=1.0, releasetime=0.0, curve=0.0,
		phasebus=0, rate=1.0, offsetframes = -1.0;
	
	var frames, pos, sig, env;
	frames = BufFrames.kr(buf);
	pos = DC.ar(In.ar(phasebus)) + offsetframes;
	pos = pos.wrap(0.0, frames);
	sig = PlayBuf.ar(1, buf, rate, 0, pos, 1);
	env = EnvGen.ar(
		Env.new([0.0, 1.0, 1.0, 0.0], [attacktime, sustaintime, releasetime], curve),
		doneAction:2
	);
	Out.ar(out, env * amp * sig);
}).load(s);




//////////////
//////////////

~buf = Buffer.alloc(s, s.sampleRate * 30.0, 1);

~in_b = Bus.audio(s, 1);
~phase_b = Bus.audio(s, 1);

~in_s = Synth.new(\adc, [\in, 0, \out, ~in_b.index], s);
~phase_s = Synth.new(\buf_phasor, [\buf, ~buf.bufnum, \out, ~phase_b.index], ~in_s, \addAfter);
~bufwr_s = Synth.new(\bufwr_mono, [\in, ~in_b.index, \buf, ~buf.bufnum, \phasebus, ~phase_b.index], ~phase_s, \addAfter);

~buf.plot;

~gg = Group.after(~bufwr_s);

~wait = 1.0;
~deltime = 1.0;
~rate = 1.0;
~rate = 0.5;
~dur = 4.0;
~attack = 1.0;
~release = 1.0;

/*
r = Routine({ inf.do ({
	Synth.new(\buf_phase_offset_grain, [
		\attacktime, ~attack, \sustaintime, ~dur - ~attack - ~release, \releasetime, ~release,
		\buf, ~buf.bufnum,
		\phasebus, ~phase_b.index,
		\offset, s.sampleRate * ~deltime * -1.0,
		\rate, ~rate
	], ~gg, \addToTail);
	~wait.wait;
}) });
*/

r = Routine({ inf.do ({
	Synth.new(\buf_pos_offset_grain, [
		\attacktime, ~attack, \sustaintime, ~dur - ~attack - ~release, \releasetime, ~release,
		\buf, ~buf.bufnum,
		\phasebus, ~phase_b.index,
		\offsetframes, ~deltime * s.sampleRate * -1.0,
		\rate, ~rate
	], ~gg, \addToTail);
	~wait.wait;
}) });


~mono = { Out.ar(1, In.ar(0)) }.play(~gg, addAction:\addAfter);

r.play;


~dur = 8.0;
~wait = 1.5;
~attack = 0.25;
~release = 0.25;
~deltime = 2.0;

r.stop;

~gg.trace;