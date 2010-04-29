SynthDef.new(\phasedelay, {
	arg buf=0, in=0, out=0,
		inamp=1.0, memoryamp=0.0,
		delaytime=1.0,
		amp=1.0,
		feedback = 0.0;
	var play_phasor, rec_phasor, player, recorder,
		bufframes, bufsamplerate, bufdur, bufscale;
	
	bufscale = BufRateScale.kr(buf);
	
	play_phasor = Phasor.ar(0, bufscale);
	rec_phasor = (play_phasor + (delaytime * bufscale)).wrap(0.0, 1.0); 
	
	recorder = BufWr.ar( (In.ar(in, 1) * inamp) + (BufRd.ar(1, buf, rec_phasor) * memoryamp), buf, rec_phasor, 1);
	player = BufRd.ar(1, buf, play_phasor, 1);
	
	Out.ar(out, player * amp);
}).load(s);

~phasedel_buf = Buffer.alloc(s, 100 * s.sampleRate, 1);

~phasedel_in_b = Bus.audio(s, 1);
~phasedel_in = Synth.new(\in_hw, [\in, 6, \out, ~phasedel_in_b.index]);


~phasedel = Synth.new(\phasedelay, [\in, ~phasedel_in_b.index, \buf, ~phasedel_buf.bufnum], ~phasedel_in, \addAfter);

~phasedel.free;

PlayBuf