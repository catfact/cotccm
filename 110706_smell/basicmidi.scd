s.boot;

SynthDef.new(\simplemidisine, {arg in=0, out=0,
	preamp=1.0, postamp=1.0,
	quantize=1,
	outmidi=nil;
	
	var input, hz, midi, amp, ampatk=0.1, ampdec=0.25;
	
	/*
	midi = if(
		quantize, 
		Pitch.kr(In.ar(in) * preamp).cpsmidi,
		Pitch.kr(In.ar(in) * preamp).cpsmidi.round(1.0)
	);
	*/
	
	input = In.ar(in) * preamp;
	hz = Pitch.kr(input);
	amp = Amplitude.kr(input, ampatk, ampdec);
	
//	if(outmidi, {Out.kr(outmidi, midi)});

		
	Out.ar(out, SinOsc.ar(hz).dup * amp * postamp);
	
}).send(s);

~in_b = Bus.audio(s, 1);

~in_s = {Out.ar(~in_b.index, SoundIn.ar(0))}.play;

x = Synth.new(\simplemidisine, [\in, ~in_b.index], ~in_s, \addAfter);

x.trace