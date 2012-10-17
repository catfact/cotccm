Routine {
	// fft buffer:
	~fftbuf = Buffer.alloc(s, 2048, 1);

	// analysis busses:
	~cent_b = Bus.control(s, 1);
	~flat_b = Bus.control(s, 1);
	~pitch_b = Bus.control(s, 1);
	~clar_b = Bus.control(s, 1);
	~amp_b = Bus.control(s, 1);

	// analysis synth:
	SynthDef.new(\analysis_all, {
		arg in, buf,

		out_flat, out_cent,
		out_pitch, out_clar,
		out_amp;

		var input, chain,
		flat, cent, pitch, amp, clar;
		
		input = In.ar(in);
		chain = FFT(buf, input);
		flat = SpecFlatness.kr(chain);
		cent = SpecCentroid.kr(chain);
		#pitch, clar = Pitch.kr(input, clar:1);
		amp = Amplitude.kr(input);
		
		Out.kr(out_flat, flat);
		Out.kr(out_cent, cent);
		Out.kr(out_pitch, pitch);
		Out.kr(out_clar, clar);
		Out.kr(out_amp, amp);
	}).send(s);

	s.sync;

	Synth.new(\analysis_all, [
		\in, c.in_b.index + 1,
		\buf, ~fftbuf.bufnum,
		\out_flat, ~flat_b.index,
		\out_cent, ~cent_b.index,
		\out_pitch, ~pitch_b.index,
		\out_clar, ~clar_b.index,
		\out_amp, ~amp_b.index
	], target:c.xg, addAction:\addAfter
	);

	~ana_wait = 0.125;

	~ampt = -32.dbamp;
	~clart = 0.5;

	~analist = List.new;

	~anar = Routine {
		var amp, pitch, clar, flat, cent;
		inf.do { 
			
			~amp_b.get({ arg v; amp = v; });
			~pitch_b.get({ arg v; pitch = v; });
			~clar_b.get({ arg v; clar = v; });
			~flat_b.get({ arg v; flat = v; });
			~cent_b.get({ arg v; cent = v; });
			
			s.sync;
			
			if(amp > ~ampt, {
				if(clar > ~clart, {
					//					pitch.postln;
					if(pitch > 100, {
						~analist.add(Event.with(
							\amp->amp, 
							\pitch->pitch,
							\clar->clar,
							\flat->flat,
							\cent->cent
						));
					});
					
					~analist.last.postln;
					
				});			
			});

			~ana_wait.wait;		
		}
	}.play;

}.play;