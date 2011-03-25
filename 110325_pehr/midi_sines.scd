//s = Server.internal.boot;

SynthDef.new(\sine_shaper, {
	arg out=0, hz=220.0, shapebuf=0, level=0.25,
		attack=0.01, release=0.5, decay=0.0, sustain=1.0, gate=1,
		beat=0.2, beatspread=0.5,
		shapemix=0.4;
	
	var sine, env, output;
	
	sine = SinOsc.ar([hz - (beat * 0.5), hz + (beat * 0.5)]);
	sine = sine*(1.0 - shapemix) + Shaper.ar(shapebuf, sine, shapemix);
	env = EnvGen.ar(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	output = sine * env;
	output = output * beatspread + Pan2.ar(Mix.new(output) * (1.0 - beatspread), 0);
	Out.ar(out, output * level);
	//Out.ar(out, sine * level);
}).send(s);

~shapebuf = Buffer.alloc(s, 512, 1, { |buf| buf.chebyMsg([1,0,0.5,0,0.25])});
/*
~shapebuf.free;
*/
~sines = Array.newClear(128);
~sinelevel = -20.dbamp;
~sinefundamental = 165;
~sineoctave = -3;
~sineoffset = -4;
~sineshape = 0.15;
~sineattack=0.004;
~sinerelease=0.05;

// 4/3 limit
~sinetuning = [
	1.0,
	16/15,
	9/8,
	4/3 * 4/3 * 4/3 / 2,
	5/4,
	4/3,
	7/5,
	3/2,
	4/3 * 4/3 * 4/3 / 3 * 2,
	5/3,
	4/3 * 4/3,
	15/8
];

~sinegroup = Group.new(s);
~sinebus = Bus.audio(s, 1);
~sine_out_s = { Out.ar(0, In.ar(~sinebus.index, 2)) }.play(~sinegroup, \addAfter);

~sine_on_r = NoteOnResponder({ |src,chan,note,vel|
	var hz, n, ratio;
	[src,chan,note,vel].postln;
	n = note + ~sineoffset;
	ratio = ~sinetuning[n % 12];
	hz = ratio * ~sinefundamental * (2**((n / 12).floor + ~sineoctave));
	hz.postln;
	~sines[note] = Synth.new(\sine_shaper, [
		\out, ~sinebus.index,
		\hz, hz,
		\level, ~sinelevel,
		\beat, ratio / 4,
		\shapebuf, ~shapebuf.bufnum,
		\shapemix, ~sineshape,
		\release, ~sinerelease,
		\attack, ~sineattack
	], ~sinegroup);
}, nil, nil, nil, nil);

~sine_off_r = NoteOffResponder({ |src,chan,note,vel|
	[src,chan,note,vel].postln;
	~sines[note].set(\gate, 0);
}, nil, nil, nil, nil);


/*
NoteOnResponder.removeAll
NoteOffResponder.removeAll
*/

~sine_panic = {
	~sinegroup.freeAll;	
			
};

~sine_cleanup = {
	~sine_on_r.remove;
	~sine_off_r.remove;
	~sinegroup.free;
	~shapebuf.freel
};