s = Server.default;
s.waitForBoot {
// groups, busses, synths
~ig = Group.new; ~xg = Group.after(~ig); ~og = Group.after(~xg);
~ib = Bus.audio(s, 2);
~ob = Bus.audio(s, 2);

// output compressor
~comp_o = {
	arg amp_in=1.0, amp_out = 1.0, thresh=0.5, slope=4.0, atk=0.001, rel=0.02;
	var son = In.ar(~ob.index, 2) * amp_in;
	Out.ar(0, Compander.ar(son, son, thresh, 1.0, slope, atk, rel, amp_out));
}.play(target:~og, addAction:\addToTail);

// sine test
Routine {
	SynthDef.new(\sineenv,
	{ arg out=~og.index, hz=220, detune = 2.0, atk=10.0, rel=20.0, amp=0.5;
		Out.ar(out, EnvGen.ar(Env(times:[atk, rel]), levelScale:0.5, doneAction:2)
		* SinOsc.ar([hz+detune, hz-detune])
			);
	}).send(s);
	s.sync;
	Synth.new(\sineenv, target:~xg);
	10.wait;
	Synth.new(\sineenv, [\hz, 110], target:~xg);
	10.wait;
	Synth.new(\sineenv, [\hz, 55], target:~xg);
}.play;

} // waitForBoot
