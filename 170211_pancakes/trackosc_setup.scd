
//--- setup
~tw = List.new;
~tw.add(TrackWaveThing.new(s));
~tw.add(TrackWaveThing.new(s));



//--- play oscs
~tracks = List.new;
~trackg= Group.new;

~dum_b = Bus.audio(s, 1);


//----------- modulate
SynthDef.new(\mulpan, {
	arg src, mod, out, pan=0.0;
	Out.ar(out, Pan2.ar(In.ar(src) * In.ar(mod), pan));
}).send(s);



~modg = Group.after(~trackg);
~modsrcg = Group.before(~modg);


~domod = { arg syn, pan=0.0, a=3.77, wait=0.2, hz=6.0;
	var src_b, mod_b, mod_s, cube, mod_src_s;
	Routine {
		src_b = Bus.audio(s, 1);
		mod_b = Bus.audio(s, 1);
		mod_s = Synth.new(\mulpan, [\src, src_b.index, \mod, mod_b.index, \pan, pan], ~modg);

		syn.set(\out, src_b.index);
		syn.set(\ampscale, 0.25);
		cube = CubOsc.new(s);
		s.sync;
		mod_src_s = cube.play(mod_b.index, ~modsrcg);
		wait.wait;
//		s.sync;
//		mod_src_s.set(\out, mod_b.index);
		{ mod_b.scope; }.defer;
		cube.x = 0.8;
		cube.a = a;
		cube.hz = hz;
	}.play;
//	(\in_b:in_b, \mod_b:mod_b, \mod_s:mod_s, \cube:cube)
};

