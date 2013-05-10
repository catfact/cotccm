Routine {
~db = Bus.audio(s);
~voxb = Bus.audio(s);

SynthDef.new(\fuckd, {
	arg out=0,
	in=1,
	shift=0.5,
	amp=1.0,
	dc = 0.0,
	distort = 0.5,
	del=0.05;

	var sig;
	sig = SoundIn.ar(in);
	sig = DelayN.ar(sig, del);
	sig = PitchShift.ar(sig, shift);
	sig = sig + (distort * (sig + dc).distort.distort.softclip);
	Out.ar(out, sig);
}).send(s);

SynthDef.new(\patch, {arg in, out; Out.ar(out, In.ar(in)); }).send(s);
SynthDef.new(\adc, {arg in, out; Out.ar(out, SoundIn.ar(in)); }).send(s);

SynthDef.new(\shitring, {
	arg inCar, inMod, out=0, amp=1.0,
	lpfHz=500;
	var car, mod;
	car = LPF.ar(InFeedback.ar(inCar), lpfHz);
	mod = InFeedback.ar(inMod);
	Out.ar(out, car * mod * amp); 
}).send(s);

s.sync;



~fuckd = Synth.new(\fuckd, [\in, 1, \out, ~db.index, \del, 0.2]);
~fuckd2 = Synth.new(\fuckd, [\in, 1, \out, ~db.index, \shift, 0.25, \amp, 2.0, \dc, 0.125], ~fuckd, \addBefore);

~vox = Synth.new(\adc, [\in, 0, \out, ~voxb.index], ~fuckd, \addAfter);
	
~shitring = Synth.new(\shitring, [\inCar, ~db.index, \inMod, ~voxb.index], ~vox, \addAfter);
~shitring.set(\amp, 5.0);

~fuckout = Synth.new(\patch, [\in, ~db.index, \out, 0], ~fuckd, \addAfter);


~fuckd_on = {
	"fucked on".postln;
	~vox.run(true);
	~fuckout.run(true);
};

~fuckd_off = {
	"fucked off".postln;
	~vox.run(false);
	~fuckout.run(false);
};

~fuckd_off.value;

}.play;
