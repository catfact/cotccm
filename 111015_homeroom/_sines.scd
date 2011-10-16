~sine_r = Routine { 
	var amp, hz;
	inf.do({
		~vla_amp_b.get({ arg v; amp = v;
			~vla_pitch_b.get({ arg w; hz = w;
				if((amp > -24.dbamp) && (hz < 880) && (hz > 110), {
					[amp, hz].postln;
					{ Out.ar(0, SinOsc.ar(hz) * 0.25 * EnvGen.ar(Env.linen(8, 2, 12), doneAction:2)); }.play;
				});
			});
		});
		12.0.wait;	
	});
	
}.play;
