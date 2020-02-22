~poll_data_clar = ~poll_data.select({arg ev;
	(ev.clar > 0.9) && (ev.amp > -40.dbamp);
}).sort({ arg a, b; a.clar > b.clar });

//p.minItem({arg ev; ev.flat});

p = ~poll_data_clar;
p.size.postln;

SynthDef.new(\sine1, {
	arg out=0, hz, pan=0, amp=0.1, fb=0,
	atk=1, dur=10, rel=1, curve=0;
	var snd, aenv;
	snd = SinOscFB.ar(hz, fb);
	aenv= EnvGen.ar(Env.new([0,1,1,0], [atk, dur, rel], curve), doneAction:2);
	Out.ar(out, Pan2.ar(snd * aenv * amp, pan));
}).send(s);

~pan = 0;
p.do({ arg ev;
	SystemClock.sched(ev.time * 6.0, {
		ev.postln;
		Synth.new(\sine1, [
			\hz, ev.hz,
			\amp, ev.amp * 0.25,
			\pan, ~pan,
			\atk, 4 + 4.rand,
			\dur, 16 + 8.rand,
			\rel, 8 + 8.rand
		]);

		~pan = (~pan + (0.05 + 0.6.rand)).wrap(-1.0, 1.0);
				Synth.new(\sine1, [
			\hz, ev.hz* 2,
			\amp, ev.amp * ev.flat,
			\pan, ~pan,
			\atk, 4 + 4.rand,
			\dur, 16 + 8.rand,
			\rel, 8 + 8.rand
		]);

		Synth.new(\sine1, [
			\hz, ev.hz*0.5,
			\amp, ev.amp * 0.25 * (1.0 - ev.flat),
			\pan, ~pan,
			\atk, 4 + 4.rand,
			\dur, 16 + 8.rand,
			\rel, 8 + 8.rand

		]);

	});
	~pan = (~pan + (0.05 + 0.6.rand)).wrap(-1.0, 1.0);
});
