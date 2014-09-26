~sine_r = Routine { 
	var amp, hz, atk;
	inf.do({
		arg i;
		~amp_b.get({ arg v; amp = v;
			~pitch_b.get({ arg w; hz = w;
				//				[amp, hz].postln;
				if((amp > -30.dbamp) && (hz < 880) && (hz > 110), {
					atk = 0.05;
					if (0.7.coin, {atk = atk + 6.0.rand});
					[amp, hz].postln;
					//					hz = hz * 0.25;
					{ Out.ar(0, SinOsc.ar([hz * [1, 1, 1.5, 2].choose, hz * [1, 1, 1.25, 1.3333].choose + 4.0.rand2] ) * (-32.dbamp) * amp * EnvGen.ar(Env.linen(atk, 0, 8), doneAction:2)); }.play;
				});
			});
		});

		((~beet_t) * ( 1 + ( (i % 2) * (16 + 8.rand)) )).wait;
	});
	
}.play;


/*
	~sine_r.stop;
*/