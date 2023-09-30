~max_sine_hz = 600;
~min_sine_hz = 30;

~db_in_min= -40;
~db_amp_min = ~db_in_min.dbamp;
~db_out_min= -20;
~db_out_max= -8;

~rats1 = [2/3, 1, 3/2, 2];
~rats2 = [1, 5/4, 4/3, 2];
~sine_r = Routine {
	var amp, hz, atk;
	inf.do({
		~vla_amp_b.get({ arg v; amp = v;
			amp.postln;
			~vla_pitch_b.get({ arg w; hz = w;
				hz.postln;
				while ({hz > ~max_sine_hz}, {
					hz = hz / 2;
				});
				while ({hz < ~min_sine_hz}, {
					hz = hz * 2;
				});
				if((amp > ~db_amp_min) && (hz < 880) && (hz > 110), {
					var newamp;
					newamp = amp.ampdb.linlin(~db_in_min, 0, ~db_out_min, ~db_out_max).dbamp;
					atk = 0.05;
					if (0.7.coin, {atk = atk + 6.0.rand});
					[amp, newamp, hz].postln;

					Routine {
						var this_wait = 4.0.rand;
						(1 + 8.rand).do {
						{ var pan = 0.5.rand2;
								Out.ar(0, Pan2.ar(
							SinOsc.ar([hz * ~rats1.choose,
								hz * ~rats2.choose + 4.0.rand2] ) * newamp
									* EnvGen.ar(Env.linen(atk, 0, 8), doneAction:2)), pan) }.play;
						4.0.wait;
						this_wait.wait;
						0.25.rand.wait;
					} }.play;
				});
			});
		});
		1.0.wait;
		1.0.rand.wait;
	});

}.play;
