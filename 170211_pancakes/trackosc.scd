
//--- setup
~tw = List.new;
~tw.add(TrackWaveThing.new(s));
~tw.add(TrackWaveThing.new(s));

//---- recxord
~tw[0].record(0).set(\median, 12);
~tw[1].record(1).set(\median, 12);


//--- play oscs
~tracks = List.new;
~trackg= Group.new;

~dum_b = Bus.audio(s, 1);

~tracks.add(~tw[0].play.set(\ratio, 0.5, \rate, 0.125, \out, ~dum_b.index).set(\ampscale, 1.0).moveToTail(~trackg));

~tracks.add(~tw[0].play.set(\ratio, 0.5 * 6/5, \rate, 0.12, \out,  ~dum_b.index).set(\ampscale, 1.0).moveToTail(~trackg));

~tracks.add(~tw[0].play.set(\ratio, 0.25, \rate, 0.135, \out,  ~dum_b.index).moveToTail(~trackg));
~tracks.add(~tw[0].play.set(\ratio, 0.25 * 3/2, \rate, 0.15, \out,  ~dum_b.index).moveToTail(~trackg));


~tracks.add(~tw[1].play.set(\ratio, 0.25, \rate, 0.25, \out,  ~dum_b.index).moveToTail(~trackg));
~tracks.add(~tw[1].play.set(\ratio, 0.5, \rate, 0.3, \out,  ~dum_b.index).moveToTail(~trackg));


~tracks.add(~tw[0].play.set(\ratio, 1.0, \rate, 0.15, \out,  ~dum_b.index).set(\ratio, 0.5 * 6/5).moveToTail(~trackg));

~tracks.add(~tw[0].play.set(\ratio, 1.0, \rate, 0.16, \out,  ~dum_b.index).set(\ampscale, 0.25).moveToTail(~trackg));

~tracks.do({arg s, i; s.set(\out, i % 2, \ampscale, 1.0, \amp, 0.125); });


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



~tracks.size.postln;



~tracks.do({ arg syn, i;
	~domod.value(syn,
		pan:i.linlin(0, ~tracks.size-1, -1.0, 1.0),
		a: i.linlin(0, ~tracks.size-1, 3.7, 3.9),
		wait: 1.0 * i,
		hz: 1.5 ** (i % 4)
	);
});


~domod.value(~tracks[0]);
~domod.value(~tracks[1]);

~domod.value(~tracks[2]);
~domod.value(~tracks[4], pan: -0.5, a: 3.71);
~domod.value(~tracks[5], pan: -0.5, a: 3.76, hz:3.0);
~domod.value(~tracks[4]);
~domod.value(~tracks[5]);

~tracks[0].set(\out, 0);

~trackg.set(\ampscale, 0.0);
~modsrcg.set(\hz, 300.0);
~modsrcg.set(\lpfhz, 100);

////// vocode piles