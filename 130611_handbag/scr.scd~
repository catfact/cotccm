/// . vocal rec 

~nvch = 8;
~vochlen = 32;

~vchbuf = Buffer.alloc(s, s.sampleRate * ~vochlen, 1);



/////////// (starts immediately at small downshift / small del)
/// . playback + small shift 

//// . ++ grrn


//// spectral invert
//// - white noise minus (high bins of?) input


// something like
SynthDef.new(\noise_inv, { arg in=0, out=0;
	var ins, chainSrc, chainMod, fftSize = 2048;
	chainSrc = FFT( LocalBuf(fftSize), WhiteNoise.ar );
	chainMod = FFT( LocalBuf(fftSize), SoundIn.ar(in) );
	chainSrc = chainSrc.pvcalc2(chainMod, fftSize, {
		arg magSrc, phaseSrc, magMod, phaseMod;
		[magSrc - magMod, phaseSrc + phaseMod]
	});
});