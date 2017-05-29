~sines_b = Bus.audio(s, 2);
~sines_g = Group.new;
~sines_out_s = {
	var snd;
	snd = In.ar(~sines_b.index, 2);
	snd = FreeVerb2.ar(snd[0], snd[1], room:0.9, damp:0.8);
	Out.ar(0, snd);
}.play(target:~sines_g, addAction:\addAfter);

~sine_ratios = [1, 1, 1, 0.5, 1.5, 0.75];

~sines_r = Routine {
	var amp, hz, atk;
	inf.do({
		~vla_amp_b.get({ arg v; amp = v;
			~vla_pitch_b.get({ arg w; hz = w;
				if((amp > -30.dbamp) && (hz < 880) && (hz > 110), {
					atk = 0.05;
					if (0.7.coin, {atk = atk + 6.0.rand});
					[amp, hz].postln;
					Routine {
						var this_wait = 4.0.rand;
						(1 + 8.rand).do {
							{
								var snd;
								snd = SinOsc.ar([
									hz * ~sine_ratios.choose,
									hz * ~sine_ratios.choose + 4.0.rand2
								] ) * (-32.dbamp);
								snd = snd * EnvGen.ar(Env.linen(atk, 0, atk * 2.0), doneAction:2);
								Out.ar(~sines_b.index, snd);
							}.play(target:~sines_g);
						4.0.wait;
						this_wait.wait;
						0.25.rand.wait;
					} }.play;
				});
			});
		});
		4.0.wait;
		4.0.rand.wait;
	});

}.play;
