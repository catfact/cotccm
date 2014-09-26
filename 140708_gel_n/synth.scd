Routine {
	SynthDef.new(\noise_form, {
		arg out=0, amp=0.25, 
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
		
		Out.ar(out, sig.dup * ampenv * amp);
		
	}).send(s);

	s.sync;

	~syng = Group.new(s);
	
	~anasyn = { arg idx, atk=1.0, sus=2.0, rel=4.0; 
		var ana = ~analist.wrapAt(idx);
		var rat = 1.0;
				idx.post; " ::: ".post;
				ana.postln;

			if((idx % 4) == 0, { rat = 0.5; }, { rat = 1.0; });
			if((idx % 10) == 0, { rat = 0.25; }, { rat = 1.0; });
		Synth.new(\noise_form, [
			\noise_mix, ana.flat * 10.0,
			\sine_mix, ana.clar * 0.6,
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


}.play;