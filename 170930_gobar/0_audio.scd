//s.options.memSize = 8192 * 128;
s = Server.default;
//s.options.memSize = 2 ** 20; // 512 MB
//s.options.device = "Tapco USB Interface";

s.waitForBoot { Routine {

	SynthDef.new(\adc, { arg in, out, level=1.0;
		Out.ar(out, SoundIn.ar(in) * level);
	}).send(s);

	SynthDef.new(\patch, { arg in, out, level=1.0;
		Out.ar(out, In.ar(in) * level);
	}).send(s);

	SynthDef.new(\amplitude, { arg in=0, out=0;
		Out.kr(out, Amplitude.kr(In.ar(in)));
	}).send(s);

	SynthDef.new(\pitch, { arg in=0, out=0;
		Out.kr(out, Pitch.kr(In.ar(in)));
	}).send(s);

	// record with some level smoothing
	SynthDef.new(\rec_smooth, {
		arg buf, in, offset=0, rec=1, pre=0, lag=0.01,
		run=1, loop=0, trig=0, done=0;
		var ins, pres, recs;
		ins = In.ar(in);
		pres = Lag.ar(K2A.ar(pre), lag);
		recs = Lag.ar(K2A.ar(rec), lag);
		RecordBuf.ar(ins, buf,
			recLevel:rec, preLevel:pre,
			offset:offset, trigger: InTrig.kr(trig),
			loop:loop, doneAction: done);
	}).send(s);

	s.sync;

	// groups
	~in_g = Group.new(s);

	// busses
	~mic_in_b    = Bus.audio(s, 1);
	~vla_in_b    = Bus.audio(s, 1);
	~vla_amp_b   = Bus.control(s, 1);
	~vla_pitch_b = Bus.control(s, 1);

	// synths
	~mic_in_s    = Synth.new(\adc, [\in, 0, \out, ~mic_in_b.index], ~in_g);
	~vla_in_s    = Synth.new(\adc, [\in, 1, \out, ~vla_in_b.index], ~in_g);

	~vla_amp_s   = Synth.new(\amplitude, [\in, ~vla_in_b.index, \out, ~vla_amp_b.index], ~in_g, \addAfter);
	~vla_pitch_s = Synth.new(\pitch, [\in, ~vla_in_b.index, \out, ~vla_pitch_b.index], ~in_g, \addAfter);

	// viola EQ insert
	~vla_eq_s = {
		var bus = ~vla_in_b.index;
		var snd = In.ar(bus);
		snd = BHiShelf.ar(snd, 5200,0.8, -8);
		snd = BPeakEQ.ar(snd, 2200, 0.8, -9);
		snd = BHiPass.ar(snd, 100);
		ReplaceOut.ar(bus, snd);
	}.play(target:~vla_in_s, addAction:\addAfter);

	// viola monitor
	~vla_monitor_s = {
		var bus = ~vla_in_b.index;
		var snd = In.ar(bus);
		Out.ar(0, snd.dup);
	}.play(target:~vla_eq_s, addAction:\addAfter);

}.play; };