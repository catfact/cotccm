/*
var pitch_b;
var clar_b;
var cent_b;
var flat_b;
*/


~poll_data = List.new;

~sort_data_by_clar = {
}


~group_by_pitch = { arg quant=0.5;
	ret = Dictionary.new;
	~poll_data.do({ arg ev;
		var pitch = ev.hz.cpsmidi.round(quant);
		if (ret[pitch].isNil, {

			ret[pitch] = List.new;
		});
		ret[pitch].add(ev);
	});
	ret
};

Routine {
	// ~pitch_b = Bus.control(s, 1);
	// ~clar_b = Bus.control(s, 1);
	// ~cent_b = Bus.control(s, 1);
	// ~flat_b = Bus.control(s, 1);
	//

	~spec_bus = Bus.control(s, 5);

	~fftbuf = Buffer.alloc(s, 2048, 1);


	s.sync;

	SynthDef.new(\spec, {
		arg out, trigid=1, hphz=200;
		var snd, fft, fft2, //fft3,
		amp, hz, clar, cent, flat; //,onsets;

		snd = SoundIn.ar(0);
		snd = HPF.ar(snd, hphz);

		fft = FFT(LocalBuf(2048), snd);
		fft2= PV_Copy(fft, LocalBuf(2048));
		fft3= PV_Copy(fft, LocalBuf(2048));

		amp = Amplitude.kr(snd);
		#hz, clar = Pitch.kr(snd, clar:1);
		cent = SpecCentroid.kr(fft);
		flat = SpecFlatness.kr(fft2);
		//
		// onsets = Onsets.kr(fft3, odftype:'wphase');
		// SendTrig.kr(onsets, trigid);

		Out.kr(out, hz);
		Out.kr(out+1, clar);
		Out.kr(out+2, cent);
		Out.kr(out+3, flat);
	}).play(s, [\out, ~spec_bus]);



	~poll_period = 0.1;
	~clar_thresh = 0.5;

	r = Routine {
		var t = 0;
		inf.do {

			~spec_bus.get({ arg vals;
				//vals.postln;
				if (vals[1] > ~clar_thresh, {
					~poll_data.add(
						(
							time: t;
							amp: vals[0],
							hz: vals[1],
							clar: vals[2],
							cent: vals[3],
							flat: vals[4]
						)
					);
					vals.postln;
				});
			});
			t = t + ~poll_period;
			~poll_period.wait;
		}
	}.play;


	// OSCFunc({
	// 	~spec_bus.get({ arg vals;
	// 	["trig", vals].postln; });
	// }, '/tr', s.addr);

}.play;