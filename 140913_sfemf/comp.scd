// compress input before recording rhtm

// a bus
~comp_b = Bus.audio(s, 1);

SynthDef.new(\adc, {arg in=0, out=0, amp=1, amplag = 0.01;
	var sig;
	amp = Lag.kr(amp, amplag);
	sig = SoundIn.ar(in);
	Out.ar(out, sig * amp);
}).send(s);

~compin_s = Synth.new(\adc, [\in, 0, \out, ~compb.index], ~ig);





