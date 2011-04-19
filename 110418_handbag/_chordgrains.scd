~interval_1 = 8/9; // buf 1 is in G, 1 whole step down
~interval_2 = 9/5; // buf 1 is in D, minor third up

// this is the chord progression:
// I I I I  V V iii iii vi IV 
~ratios = [
	[1, 2, 1/2, 3/2],
	[1, 2, 1/2, 3/2],
	[1, 2, 1/2, 3/2],
	[1, 2, 1/2, 3/2],
	
	[3/4, 3, 9/4, 3/2],
	[3/4, 3, 9/4, 3/2],
	[3/4, 3, 9/4, 3/2],
	[3/4, 3, 9/4, 3/2],
	
	[5/4, 5/8, 10/4, 15/8],
	[5/4, 5/8, 10/4, 15/8],
	[5/4, 5/8, 10/4, 15/8],
	[5/4, 5/8, 10/4, 15/8],
	
	// [4/5, 2/5, 8/5, 6/5],
	[4/3, 2/3, 8/3, 2],
	[4/3, 2/3, 8/3, 2],
	[4/3, 2/3, 8/3, 2],
	[4/3, 2/3, 8/3, 2]
];

~grains1 = { arg rates, atk=0.25, dur=1.75, rel=0.5;
	
	Synth.new(\chopgrain_1shot, [
		\buf, ~vla_loop1_buf.bufnum, 
		\minframes, 0, \maxframes, s.sampleRate * 8.0,
		\choprate, 1.0,
		\rate, rates[0],
		\atk, atk,
		\rel, rel,
		\dur, dur,
		\level, 0.5
	]);
	
	Synth.new(\chopgrain_1shot, [
		\buf, ~vla_loop1_buf.bufnum, 
		\minframes, 0, \maxframes, s.sampleRate * 8.0,
		\choprate, 2.0,
		\rate, rates[1],
		\atk, atk,
		\rel, rel,
		\dur, dur,
		\level, 0.5
	]);
	
	Synth.new(\chopgrain_1shot, [
		\buf, ~vla_loop1_buf.bufnum, 
		\minframes, 0, \maxframes, s.sampleRate * 8.0,
		\choprate, 2.0,
		\posrate, 0.25,
		\rate, rates[2],
		\atk, atk,
		\rel, rel,
		\dur, dur,
		\level, 0.5
	]);
	
	Synth.new(\chopgrain_1shot, [
		\buf, ~vla_loop1_buf.bufnum, 
		\minframes, 0, \maxframes, s.sampleRate * 8.0,
		\choprate, 4.0,
		\posrate, 0.5,
		\rate, rates[3],
		\atk, atk,
		\rel, rel,
		\dur, dur,
		\level, 0.5
	]);
};


~grains2 = { arg rates, atk=0.25, dur=1.75, rel=0.5;
	
	Synth.new(\chopgrain_1shot, [
		\buf, ~vla_loop2_buf.bufnum, 
		\minframes, 0, \maxframes, s.sampleRate * 8.0,
		\choprate, 2,
		\rate, rates[0],
		\atk, atk,
		\rel, rel,
		\dur, dur,
		\level, 0.2
	]);
	
	Synth.new(\chopgrain_1shot, [
		\buf, ~vla_loop2_buf.bufnum, 
		\minframes, 0, \maxframes, s.sampleRate * 8.0,
		\choprate, 0.75,
		\rate, rates[1],
		\atk, atk,
		\rel, rel,
		\dur, dur,
		\level, 0.18
	]);
	
	Synth.new(\chopgrain_1shot, [
		\buf, ~vla_loop2_buf.bufnum, 
		\minframes, 0, \maxframes, s.sampleRate * 8.0,
		\choprate, 0.5,
		\posrate, 0.25,
		\rate, rates[2],
		\atk, atk,
		\rel, rel,
		\dur, dur,
		\level, 0.17
	]);
	
	Synth.new(\chopgrain_1shot, [
		\buf, ~vla_loop2_buf.bufnum, 
		\minframes, 0, \maxframes, s.sampleRate * 8.0,
		\choprate, 1.0,
		\posrate, 0.5,
		\rate, rates[3],
		\atk, atk,
		\rel, rel,
		\dur, dur,
		\level, 0.16
	]);
};

~chordgrains_r = Routine { inf.do({ arg i; ~ratios.do({ arg rats;
	rats.postln;
	
	8.do({ arg i;
		~jl_play_s[i].set(\ratelag, 0.1 + 0.1.rand);
		~jl_play_s[i].set(\rate, rats[i % (rats.size)] * ~interval_1);
	});
	
	~grains1.value(rats * ~interval_1);
	
	if (i > 31, {~grains2.value(rats * ~interval_2)});
	2.0.wait;
}); }); }.play;

~tempo = 1.0;

~vox_delay.set(\time, 8*4);
~vox_delay2.set(\time, 8*4*2);
~vox_delay3 = Synth.new(\echo, [\in, ~vox_in_b.index, \maxtime, 4*4*5, \time, 4*4*8, \out, 0, \amp, -6.dbamp], ~xg);
~vox_delay2.set(\time, 8*4+4);

~vla_delay.set(\time, 8 * 4);
//~vla_delay2 = Synth.new(\echo, [\in, ~vla_in_b.index, \maxtime, 4*4*5, \time, 4*4*4, \out, 0, \amp, -6.dbamp], ~xg);
~vla_delay3 = Synth.new(\echo, [\in, ~vla_in_b.index, \maxtime, 4*9, \time, 4*8, \out, 0, \amp, -6.dbamp], ~xg);
~vla_delay3.set(\time, 8 * 8);



/*
~grains1.value(~ratios[0]);

///// f maj 7
x.set(\rate, 9/10);
y.set(\rate, 9/5 * 3/2);
z.set(\rate, 18/10);
w.set(\rate, 9/5 * 5/4)

w.set(\gate, 0);
x.set(\gate, 0);
y.set(\gate, 0);
z.set(\gate, 0);

*/