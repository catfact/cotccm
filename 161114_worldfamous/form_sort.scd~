
~analist_clar = ~analist.sort({ arg ana1, ana2; ana1.clar > ana2.clar });
~analist_flat = ~analist.sort({ arg ana1, ana2; ana1.flat > ana2.flat });


~syn_sort_amp = -24.dbamp;
~pitchmax = 900;

~clar = { arg n=8, sus=8.0, off=0;
	n.do({
		arg i;
		var ana = ~analist_clar[i+off];
		var pitch;
		var durscale;
		if(0.85.coin, {

			pitch = ana.pitch;
			durscale = (pitch.cpsmidi.linlin(0.0, 64.0, 16.0, 0.0));
		}, {
			"low: ".post;
			pitch = ana.pitch * 0.5;
			durscale = (pitch.cpsmidi.linlin(0.0, 64.0, 16.0, 0.0));
		});

		
		
		[i, pitch, durscale].postln;

		Synth.new(\noise_form, [
			\noise_mix, ana.flat * 20.0,
			\sine_mix, ana.clar * 0.3,
			\hz, pitch,
			\form_hz, ana.cent,
			\lpf_hz, ana.cent * 2,
			\width_hz, ana.cent + ana.pitch,
			// \rq, 1.0 - ana.flat,
			\rq, (1.0 - (ana.flat * 10.0)).max(0.1),
			\amp, ~syn_sort_amp ,
			\atk, i / 64.0 + 0.001 + if(0.5.coin, { durscale }, {0}),
			\rel, sus + (n - i) + durscale,
			\sus, sus * durscale * 0.125,
			\pan, i.linlin(0, n-1, 1.0, -1.0),
			\out, ~ob.index
		], ~syng);
	});
};


~flat = { arg n=8, sus=8.0, off=0;
	n.do({
		arg i;
		var ana = ~analist_flat[i+off];
	var pitch;
		var durscale;
		if(0.85.coin, {

			pitch = ana.pitch;
			durscale = (pitch.cpsmidi.linlin(0.0, 64.0, 16.0, 0.0));
		}, {
			"low: ".post;
				pitch = ana.pitch * 0.5 * [0.5, 1.0].choose;
			durscale = (pitch.cpsmidi.linlin(0.0, 64.0, 16.0, 0.0));
		});


		[i, pitch, durscale].postln;

		Synth.new(\noise_form, [
			\noise_mix, ana.flat * 20.0,
			\sine_mix, ana.clar * 0.3,
			\hz, pitch,
			\form_hz, ana.cent,
			\lpf_hz, ana.cent * 2,
			\width_hz, ana.cent + ana.pitch,
			// \rq, 1.0 - ana.flat,
			\rq, (1.0 - (ana.flat * 10.0)).max(0.1),
			\amp, ~syn_sort_amp ,
			\atk, i / 64.0 + 0.001 + if(0.5.coin, { durscale }, {0}),
			\rel, sus + (n - i) + durscale,
			\sus, sus * durscale * 0.125,
			\pan, i.linlin(0, n-1, 1.0, -1.0),
			\out, ~ob.index
		], ~syng);
	});
};

