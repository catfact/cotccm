/*
z = { PinkNoise.ar.dup * 0.0625 }.play
z.free;
*/

// screms

// pile up


// record pitch, amp to buf

~tw = List.new;
~tw.add(TrackWaveThing.new(s));
~tw[0].record(1);

~tw[0].hz_buf.plot
~tw[0].amp_buf.plot

// playback buf to osc

~tracks = List.new;
~trackg= Group.new;

~tracks.add(~tw[0].play.set(\ratio, 0.5, \rate, 0.125, \out, 1).moveToTail(~trackg));
~tracks.add(~tw[0].play.set(\ratio, 0.5 * 6/5, \rate, 0.125, \out, 0).moveToTail(~trackg));

~tracks.add(~tw[0].play.set(\ratio, 0.25, \rate, 0.125, \out, 1).moveToTail(~trackg));
~tracks.add(~tw[0].play.set(\ratio, 0.25 * 3/2, \rate, 0.125, \out, 0).moveToTail(~trackg));

~tw.add(TrackWaveThing.new(s));

~tw[1].record(1);
~tracks.add(~tw[1].play.set(\ratio, 0.25, \rate, 0.25, \out, 0).moveToTail(~trackg));
~tracks.add(~tw[1].play.set(\ratio, 0.5, \rate, 0.25, \out, 1).moveToTail(~trackg));


//... &c...


z = ~tw[0].play.set(\ratio, 1.0, \rate, 0.15, \out, 1);
z.set(\ratio, 0.5 * 6/5);

y = ~tw[0].play.set(\ratio, 1.0, \rate, 0.15, \out, 0);
y.set(\ampscale, 0.5);


// modulate
SynthDef.new(\mulpan, {
	arg in, mod, out, lpfhz, pan=0.0;
	Out.ar(out, Pan2.ar(In.ar(in) * In.ar(mod), pan));
}).send(s);

~modg = Group.after(~trackg);
~modsrcg = Group.before(~modg);
//~mong = Group.after(~modg);

~mod_b = Bus.audio(s, 1);
~in_b = Bus.audio(s, 1);
~mods = Synth.new(\mulpan, [\in, ~in_b.index, \mod, ~mod_b.index], ~modg);
~tracks[0].set(\out, ~in_b.index);

c = CubOsc.new(s);
~csyn = c.play(~modsrcg).set(\out, ~mod_b.index);
~csyn.set(\hz, 6.0);



~domod = { arg syn;
	var in_b, mod_b, mod_s, mon_s;
	in_b = Bus.audio(s, 1);
	mod_b = Bus.audio(s, 1);
	mod_s = Synth.new(\mul, [\in, in_b.index, \mod, mod_b.index], ~modg);
	syn.set(\out, in_b);

};


////// vocode piles