Server.killAll

s.boot;

~fft_buf = Buffer.alloc(s, 2048);

SynthDef.new(\fft, {arg in=0, buf=0, out=0;
	Out.ar(0, FFT(buf, In.ar(in));
}).send(s);

SynthDef.new(\ifft, {arg out=0, buf=0;
	Out.ar(out, IFFT(buf, In.ar(in));
}).send(s);


~in_b = Bus.audio(s, 1);

~in_s = {Out.ar(~in_b.index, SoundIn.ar(0))}.play;

~fft_s = Synth.new(\fft, [\in, ~in_b.index, \buf, ~fft_buf.bufnum], ~in_s, \addAfter);

~fft_b = Bus.audio(s, 1);


SynthDef.new(\freeze8, {
	
});

Quarks.gui

PV_MagBuffer



(
s.boot.doWhenBooted{
	b = Buffer.alloc(s, 512);
};
)
// Reminder: This isn't the intended typical usage! It's OK to do this though.
(
x = {
	var mags, phases, chain, sig;
	// Create simple undulating magnitudes
	mags = {FSinOsc.kr(ExpRand(0.1, 1)).range(0, 1)}.dup(100);
	// Then give them a "rolloff" to make the sound less unpleasant
	mags = mags  * ((1, 0.99 .. 0.01).squared);
	// Let's turn the bins on and off at different rates, I'm *sure* that'll sound interesting
	mags = mags * {LFPulse.kr(2 ** IRand(-3, 5)).range(0, 1)}.dup(100);
	// Let's ignore phase for now
	phases = 0.dup(100);
	chain = FFTTrigger(b, 0.5);
	// Now we can do the packing
	chain = PackFFT(chain, 512, [mags, phases].flop.flatten, 0, 99, 1);
	sig = IFFT(chain);
	Out.ar(0, sig.dup);
}.play(s);
)
x.free;

x.run(true);
x.run(false);


SynthDef.new(\freezebuf, {arg buf, out=0, freeze=1;
	var chain;
	chain = FFTTrigger(buf, 0.5);
	chain = PV_Freeze(chain, freeze);
	Out.ar(out, IFFT.ar(chain));
}).send(s);

y = Synth.new(\freezebuf, [\buf, b.bufnum]);


b.free;


b.get(50, {arg buf, v; v.postln; });

PV_MagBuffer