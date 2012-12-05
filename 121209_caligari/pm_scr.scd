
// scale
~scale = [ 1, 15/16, 9/8, 6/5, 5/4, 64/45, 4/3, 3/2, 8/5, 10/6, 16/9, 30/16];
~scale.size.postln;

//----------- voice 1
/// score: [degree, octave, duration]
/////
~scr1 = [
	[0, 0, 4],
	[2, 0, 3],
	[8, -1, 5],
	[0, 0, 6], 
	[2, 0, 3],
	[8, -1, 5],
	[10, -1, 3],
	[7, -1, 4],
	[0, 0, 4],
	[2, 0, 3],
	[8, -1, 5],
	[0, 0, 6], 
	[2, 0, 3],
	[8, -1, 5],
	[10, -1, 3],
	[7, -1, 4],
	[1, 0, 2]
];

//// synthesis group for voices
~v1g = Group.new(s);

~v1_hz = 110;
~v1r = Routine { 
	var scr;
	var deg, oct, dur;
	var pm12, pm23, pm31, hz2, hz3;
	var syn;
	inf.do { arg i;
		scr = ~scr1[i % (~scr1.size)];
		deg = scr[0];
		oct = scr[1];
		dur = scr[2] * 2.0;

		pm12 = (0.0625 * ( ( i * 17) % 8)).wrap(0, 0.8);
		pm23 = (0.125 * ( ( i * 13) % 6)).wrap(0, 0.8);
		pm31 = (0.0625 * (( i * 19) % 7)).wrap(0, 0.8);
		
		syn = Synth.new(\pm3_1shot, [
			\hz1, ~v1_hz * (2 ** oct) * ~scale[deg],
			\sus, dur,
			\atk, dur * 0.125,
			\rel, dur * 0.5,
			\pm12, 0,
			\pm23, 0,
			\pm31, 0,
			\pm12lag, dur,
			\pm23lag, dur,
			\pm31lag, dur,
		], ~v1g);
		
		syn.set(\pm12, pm12);
		syn.set(\pm23, pm23);
		syn.set(\pm31, pm31);

		(dur * 4.0).wait;
	} 
}.play;


//----------- voice 2
/// score: [degree, octave, duration]
/////
~scr2 = [
	[3, 1, 1.5],
	[5, 1, 1.5],
	[7, 1, 2],
	[5, 1, 1.5], 
	[2, 1, 2],
	[2, 1, 2],
	[3, 1, 3],
	[5, 1, 1.5],
	[2, 1, 1],
	[11, 0, 3],
	[0, 1, 4],

	[3, 1, 1.5],
	[5, 1, 1.5],
	[7, 1, 4],
	[8, 1, 2],
	[5, 1, 3], 
	[2, 1, 2],
	[2, 1, 2],
	[3, 1, 2],
	[5, 1, 1.5],
	[2, 1, 1],
	[11, 0, 3],
	[0, 1, 5]
];


//// synthesis group for voices
~v2g = Group.new(s);

~v2_hz = 220;
~v2r = Routine { 
	var scr;
	var deg, oct, dur;
	var pm12, pm23, pm31, hz2, hz3;
	var syn;
	inf.do { arg i;
		scr = ~scr2[i % (~scr2.size)];
		deg = scr[0];
		oct = scr[1];
		dur = scr[2] * 2.0;

		pm12 = (0.0625 * ( ( i * 17) % 8)).wrap(0, 0.6);
		pm23 = (0.125 * ( ( i * 13) % 6)).wrap(0, 0.4);
		pm31 = (0.0625 * (( i * 19) % 7)).wrap(0, 0.5);
		
		syn = Synth.new(\pm3_1shot, [
			\hz1, ~v1_hz * (2 ** oct) * ~scale[deg],
			\hz2, ~v1_hz * (2 ** oct) * ~scale[deg] * ~scale[deg],
			\hz3, ~v1_hz * (2 ** oct) * ~scale[deg] * ~scale[deg]  * ~scale[deg],
			\sus, dur,
			\atk, dur * 0.125,
			\rel, dur * 0.5,
			\pm12, 0,
			\pm23, 0,
			\pm31, 0,
			\pm12lag, dur,
			\pm23lag, dur,
			\pm31lag, dur,
			\amp, -24.dbamp
		], ~v1g);
		
		syn.set(\pm12, pm12);
		syn.set(\pm23, pm23);
		syn.set(\pm31, pm31);

		(dur * 4.0).wait;
	} 
}.play;




/*
~v1r.stop;
*/