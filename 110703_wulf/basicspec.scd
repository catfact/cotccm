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