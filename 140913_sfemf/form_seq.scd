// store a copy
~analist_unsorted = ~analist.copy;
// sort by pitch
~analist_pitch = ~analist.sort({ arg ana1, ana2; ana1.pitch > ana2.pitch }).reverse;

~syn_amp = -24.dbamp;

~sstk = { arg tbase=32.0, start=100, num=6, end=200;
	var step;
	//	end = end.min(~analist.size - 1);
	step = ((end - start) / num).floor;
	Routine { num.do({ arg i;

		~anasyn.value(
			start + (step * i), // analist idx
			tbase / num * i + (tbase / num),// atk,
			tbase, //sus
			tbase / num * (num-i) + (tbase / num)  , // rel

		);
		(tbase / num * 0.75).wait;
	});
	tbase.wait;

	}.play;
};

~siner  = List.new;
/*
~siner.do({ arg r; r.stop; });
*/
Routine {

	SynthDef.new(\noise_form, {
		arg out=0, amp=0.25, pan=0.0,
		atk=4.0, rel=4.0, sus=1.0,
		hz,
		lpf_hz=10000, rq=1.0,
		form_hz, form_bw,
		sine_mix=0.5, form_mix = 0.5, noise_mix=0.0;
		var ampenv, sine, form, noise, sig;

		ampenv = EnvGen.ar(Env.linen(atk, sus, rel), 1, doneAction:2);
		sine = SinOsc.ar(hz) * sine_mix;
		form = Formant.ar(hz, form_hz, form_bw) * form_mix;
		noise = WhiteNoise.ar * noise_mix;
		sig = Mix.new([sine, form, noise]);
		sig = RLPF.ar(sig, lpf_hz, rq);

		Out.ar(out, Pan2.ar(sig * ampenv * amp, pan));

	}).send(s);

	s.sync;

	~syng = Group.after(~xg);

	~anasyn = { arg idx, atk=1.0, sus=2.0, rel=4.0;
		var ana = ~analist_pitch.wrapAt(idx);
		var rat = 1.0;
		idx.post; " ::: ".post;
		ana.postln;

		if((idx % 4) == 0, { rat = 0.5; }, { rat = 1.0; });
		if((idx % 10) == 0, { rat = 0.25; }, { rat = 1.0; });
		Synth.new(\noise_form, [
			\noise_mix, ana.flat * 30.0,
			\sine_mix, ana.clar * 0.5,
			\hz, ana.pitch * 0.5 * rat,
			\form_hz, ana.cent * 0.5 * (1.0 / rat),
			\lpf_hz, ana.cent,
			\width_hz, ana.cent + ana.pitch,
			\rq, 1.0 - ana.flat,
			\amp, ~syn_amp
		], ~syng);
	};


	/* test:
	x = ~anasyn.value(~analist.size.rand)
	*/



	~siner.add( Routine { inf.do {
		~sstk.value(num:5, tbase:16, start:0, end:500);
		(16 * 2).wait;
	} }.play );

	16.wait;

	~siner.add( Routine { inf.do {
		~sstk.value(num:4, tbase:23, start:2, end:60);
		(23 * 2).wait;
	} }.play );

	23.wait;


	57.wait;

	~siner.add( Routine { inf.do {
		~sstk.value(num:8, tbase:60, start:17, end:300);
		(60 * 2).wait;
	} }.play );

	60.wait;

}.play;

