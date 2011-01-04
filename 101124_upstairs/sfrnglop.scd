SynthDef.new(\in, {arg in=0, out=0; Out.ar(out, SoundIn.ar(in, 1)); }).load(s);
SynthDef.new(\rec, {arg in=0, buf=0; RecordBuf.ar(In.ar(in), buf, loop:0, doneAction:2);  }).load(s);
SynthDef.new(\play, {arg out=0, buf=0; Out.ar(out, PlayBuf.ar(1, buf, loop:0, doneAction:2)) }).load(s);

SynthDef.new(\ringlpfloop, {
	arg out=0, buf=0,
		pan=0.0, rate=1.0,
		level=1.0, loop=1, shift=0.125, windowsize=0.125,
		wet=1.0, dry=0.5, ringlpfhz=10.0, lpfhz=8000.0, doneAction=0;
	var ring, play;
	play = PlayBuf.ar(1, buf, rate, loop:loop, doneAction:doneAction);
	ring = LPF.ar(PitchShift.ar(play, windowsize, shift), ringlpfhz);
	Out.ar(out, Pan2.ar(
		LPF.ar(
			(play*dry) + (play*wet*ring),
			lpfhz
		), pan) * level
	);		
}).load(s);

////////


~in_b = Bus.audio(s, 1);

~buf0 = Buffer.alloc(s, 44100 * 180, 1);
~buf1 = Buffer.alloc(s, 44100 * 200, 1);
~buf2 = Buffer.alloc(s, 44100 * 160, 1);

~in_s = Synth.new(\in, [\in, 1, \out, ~in_b.index]);
~in0_s = Synth.new(\in, [\in, 0, \out, ~in_b.index]);


/////////
~rec0 = Synth.new(\rec, [\in, ~in_b.index, \buf, ~buf0.bufnum], s, \addToTail);

x = Synth.new(\ringlpfloop, [\buf, ~buf0.bufnum, \windowsize, 2.0, \loop, 1], s);
x.set(\ringlpfhz, 8.0);
x.set(\lpfhz, 8000);
x.set(\shift, 1/128);
x.set(\dry, 1.0);
x.set(\wet, 0.0);
x.set(\level, 1.0);
//x.free;

y = Synth.new(\ringlpfloop, [\buf, ~buf0.bufnum, \windowsize, 2.0, \loop, 1], s);
y.set(\ringlpfhz, 16.0);
y.set(\lpfhz, 12000);
y.set(\shift, 1/256);
y.set(\dry, 1.0);


/////////
~rec1 = Synth.new(\rec, [\in, ~in_b.index, \buf, ~buf1.bufnum], s, \addToTail);
//~rec1.free;
w = Synth.new(\ringlpfloop, [\buf, ~buf1.bufnum, \windowsize, 2.0, \loop, 1], s);
w.set(\ringlpfhz, 8.0);
w.set(\lpfhz, 8000);
w.set(\shift, 1/256);
w.set(\dry, 1.0);


z = Synth.new(\ringlpfloop, [\buf, ~buf1.bufnum, \windowsize, 1.0, \loop, 1], s);
z.set(\ringlpfhz, 16.0);
z.set(\lpfhz, 12000);
z.set(\shift, 1/512);
z.set(\dry, 0.5);
z.set(\wet, 0.0);
z.set(\rate, 1.0);

q = Synth.new(\ringlpfloop, [\buf, ~buf1.bufnum, \windowsize, 1.0, \loop, 1], s);
q.set(\ringlpfhz, 16.0);
q.set(\lpfhz, 12000);
q.set(\shift, 1/256);
q.set(\dry, 0.5);
q.set(\wet, 0.0);
q.set(\rate, 1.0);



/////////
// ~rec2 = Synth.new(\rec, [\in, ~in_b.index, \buf, ~buf2.bufnum], s, \addToTail);

a = Synth.new(\ringlpfloop, [\buf, ~buf1.bufnum, \windowsize, 2.0, \loop, 1], s);
a.set(\ringlpfhz, 8.0);
a.set(\lpfhz, 8000);
a.set(\shift, 1/128);
a.set(\dry, 1.0);
a.set(\wet, 0.0); //125);


b = Synth.new(\ringlpfloop, [\buf, ~buf0.bufnum, \windowsize, 2.0, \loop, 1], s);
b.set(\ringlpfhz, 16.0);
b.set(\lpfhz, 12000);
b.set(\shift, 1/256);
b.set(\dry, 1.0);
b.set(\wet, 0.0); //125);



c = Synth.new(\ringlpfloop, [\buf, ~buf1.bufnum, \windowsize, 2.0, \loop, 1], s);
c.set(\ringlpfhz, 8.0);
c.set(\lpfhz, 8000);
c.set(\shift, 1/128);
c.set(\dry, 1.0);
c.set(\wet, 0.0); //25);
d.set(\rate, 1023/1024);


d = Synth.new(\ringlpfloop, [\buf, ~buf0.bufnum, \windowsize, 2.0, \loop, 1], s);
d.set(\ringlpfhz, 16.0);
d.set(\lpfhz, 12000);
d.set(\shift, 1/256);
d.set(\dry, 1.0);
d.set(\wet, 0.0; //125);
d.set(\rate, 257/256);


d = Synth.new(\ringlpfloop, [\buf, ~buf0.bufnum, \windowsize, 2.0, \loop, 1], s);
d.set(\ringlpfhz, 16.0);
d.set(\lpfhz, 12000);
d.set(\shift, 1/256);
d.set(\dry, 1.0);
d.set(\wet, 0.0); //125);
d.set(\rate, 257/256);


/////////
x.free;	
y.free;

z.free;
w.free;
q.free;


a.free;
b.free;
c.free;
d.free;



