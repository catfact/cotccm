//x = { WhiteNoise.ar.dup }.play;
//x.free;


SynthDef.new(\normrlpf, {
	arg in=0, out=0, hz=110, rq=1.0, norm=0.5, amp=0.5, dur=1.0;

	var snd;

	snd = SoundIn.ar(in);
	//	snd = (snd * 1-norm) + (norm * Normalize.ar(snd), dur);
	snd = Normalizer.ar(snd, level:norm, dur:dur);

	snd = RLPF.ar(snd, hz, rq);

	Out.ar(out, snd * amp);
}).send(s);




z = Synth.new(\normrlpf);
z.set(\norm, 0.25);
z.set(\amp, 0.5);
z.set(\rq, 0.1);

z.set(\dur, 0.125);

~hzb = Bus.control(s, 1);

z.map(\hz, ~hzb);

~hzline = { Out.kr(~hzb.index, Line.kr(30, 4000, 120)) }.play;

~hzline = { Out.kr(~hzb.index, Line.kr(30, 90, 300).midicps) }.play;


~hzline.run(false);
~hzline.free;

~hzb.set(880);



~hzb.set(699);


~hzb.set(699 * 15/20);



16.midicps
20.midicps
30.midicps;
40.midicps

80.midicps
90.midicps


///