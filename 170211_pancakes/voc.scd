
~scremvoc = {
	var car, mod, voc, modshift = 0.5;
	car = Normalizer.ar( In.ar(~screm_b.index, 2) );
	mod = PitchShift.ar(SoundIn.ar(0).dup, pitchRatio:modshift);

	voc = Vocoder.ar(car, mod, 6);
}.play(target:s, addAction:\addToTail);

//~screm_out_s.run(false);


//~scremvoc.free;