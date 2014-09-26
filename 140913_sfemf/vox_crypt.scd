// count of FFT frames
n = 512;

// key array
// arbitrarily re-ordered indices
k = Array.series(n, 0, 1).scramble;

// synthdef for scrambling frequency subbands (FFT bins) according to arbitrary map
SynthDef.new(\crypt, {
	arg in = 0;

	var son, chain;
	son = SoundIn.ar(in);
	chain = FFT(LocalBuf(n), son);

	chain = chain.pvcalc(n, { arg mag, phase;
		var scram = Array.fill(n, {
			/// will this work...
			arg i;
			mag[k[i]];
		});
		[scram, phase]
	});

	Out.ar(0, 0.5 * IFFT(chain).dup);

}).send(s);

x = Synth.new(\crypt);
/*
	x.free;
*/