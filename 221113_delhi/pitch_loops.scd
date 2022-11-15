~maxDur = 56;

~sine_b = Bus.audio(s, 2);
~sine_out_s = { arg amp=1, lagtime=4.0;
	Out.ar(~out_b.index, In.ar(~sine_b.index, 2) * amp.lag(lagtime));
}.play(target:~og, addAction:\addBefore);

SynthDef.new(\sine_1shot, {
	arg out, amp=0.2, pan=0, hz=110,
	ampLag=1, panLag=1, hzLag=1,
	atk, sus, rel;
	var snd = SinOsc.ar(hz.lag(hzLag));
	snd = snd * EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
	snd = Pan2.ar(snd, pan.lag(panLag), amp.lag(ampLag));
	Out.ar(out, snd);
}).send(s);


~pl = {
	arg n=8, timescale=1, ampscale=0.5,
	atkSeq=#[0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25],
	susSeq=#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5],
	relSeq=#[0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25],
	durSeq = #[1, 1, 1, 1, 1, 1, 1, 1],
	ratSeq = #[1, 1, 1, 1, 1, 1, 1, 1],
	panSeq=#[0, 0, 0, 0, 0, 0, 0, 0];

	var e;
	var hist;
	var dn = ~dowse.data.size;
	var evList = Array.fill(n, { arg i;
		var ev = ~dowse.data[dn - 2 - i];
		(hz:ev.pitch, amp:ev.amp, dur:ev.dur)
	});
	var step=0;

	Routine {
		inf.do {
			evList.do { arg ev;
				var dur = (ev.dur * durSeq.wrapAt(step));
				dur = dur.min(~maxDur);
				Synth.new(\sine_1shot, [
					\hz, ev.hz * ratSeq.wrapAt(step),
					\amp, ev.amp.min(0.1).max(0.5) * ampscale,
					\pan, panSeq.wrapAt(step),
					\atk, atkSeq.wrapAt(step) * dur,
					\sus, susSeq.wrapAt(step) * dur,
					\rel, susSeq.wrapAt(step) * dur,
					\out, ~sine_b.index
				], ~xg);
				dur.wait;
			}
		}
	}.play

}