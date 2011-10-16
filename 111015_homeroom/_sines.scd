~sine_r = Routine { 
	var amp, hz, atk;
	inf.do({
		~vla_amp_b.get({ arg v; amp = v;
			~vla_pitch_b.get({ arg w; hz = w;
				if((amp > -30.dbamp) && (hz < 880) && (hz > 110), {
					atk = 0.05;
					if (0.7.coin, {atk = atk + 6.0.rand});
					[amp, hz].postln;
					{ Out.ar(0, SinOsc.ar(hz * [1, 1, 1, 1, 2, 2, 1.5, 4].choose) * 0.25 * EnvGen.ar(Env.linen(0.2 , 0, 8), doneAction:2)); }.play;
				});
			});
		});
		6.0.wait;	
	});
	
}.play;
