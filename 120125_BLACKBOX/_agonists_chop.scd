Routine {
	
	~interval_1 = 1.0;
	~interval_2 = 1.0;

	~vox_echo1_buf = Buffer.alloc(s, s.sampleRate * 150.0, 1, completionMessage: { });
	~vox_echo2_buf = Buffer.alloc(s, s.sampleRate * 150.0, 1, completionMessage: { });
	~vox_echo3_buf = Buffer.alloc(s, s.sampleRate * 150.0, 1, completionMessage: { });
	~vla_echo1_buf = Buffer.alloc(s, s.sampleRate * 150.0, 1, completionMessage: { });
	~vla_echo2_buf = Buffer.alloc(s, s.sampleRate * 150.0, 1, completionMessage: { });
	~vla_echo3_buf = Buffer.alloc(s, s.sampleRate * 150.0, 1, completionMessage: { });

	s.sync;
	~tempo = 0.5;
	
	
	~ig = Group.new(s);
	~xg = Group.after(~ig);
	~og = Group.after(~xg);
	
	~vox_in_b = Bus.audio(s, 1);
	~vox_adc = Synth.new(\adc, [\in, 0, \out, ~vox_in_b.index], ~ig);
	
	~vox_echo_pre = Synth.new(\cmpcho, [\in, ~vox_in_b.index, \out, ~vox_in_b.index, \time, ~tempo /3, \maxtime, ~tempo, \amp, 0.7], ~ig, \addAfter);
	~vox_echo_out = Synth.new(\cmpcho, [\in, ~vox_in_b.index, \out, 0, \time, ~tempo /3, \maxtime, ~tempo, \amp, 0.7], ~ig, \addAfter);

	~vox_delay = Synth.new(\echo_buf, [\in, ~vox_in_b.index, \buf, ~vox_echo1_buf.bufnum, \time, ~tempo, \out, 0, \amp, 0.5], ~xg);	
	~vox_delay2 = Synth.new(\echo_buf, [\in, ~vox_in_b.index, \buf, ~vox_echo2_buf.bufnum, \time, ~tempo * 4 * 3, \out, 0, \amp, -4.dbamp], ~xg);
	~vox_delay.set(\amp, -6.dbamp);

~vla_delay = Synth.new(\echo_buf, [\in, ~vla_in_b.index, \buf, ~vla_echo_buf.bufnum, \time, ~tempo * 4 * 3, \out, 0, \amp, -6.dbamp], ~xg);
	
	
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
	
	~grains1 = { arg rates, atk=0.25, dur=1.75, rel=0.5, lvlscale =2.0;
		
		Synth.new(\chopgrain_1shot, [
			\buf, ~vla_loop1_buf.bufnum, 
			\minframes, 0, \maxframes, s.sampleRate * 8.0,
			\choprate, rates[1],
			\rate, rates[0],
			\atk, atk,
			\rel, rel,
			\dur, dur,
			\level, 0.5 * lvlscale
		]);
		
		Synth.new(\chopgrain_1shot, [
			\buf, ~vla_loop1_buf.bufnum, 
			\minframes, 0, \maxframes, s.sampleRate * 8.0,
			\choprate, rates[0],
			\rate, rates[1],
			\atk, atk,
			\rel, rel,
			\dur, dur,
			\level, 0.5 * lvlscale
		]);
		
		Synth.new(\chopgrain_1shot, [
			\buf, ~vla_loop1_buf.bufnum, 
			\minframes, 0, \maxframes, s.sampleRate * 8.0,
			\choprate, rates[3],
			\posrate, 0.25,
			\rate, rates[2],
			\atk, atk,
			\rel, rel,
			\dur, dur,
			\level, 0.5 * lvlscale
		]);
		
		Synth.new(\chopgrain_1shot, [
			\buf, ~vla_loop1_buf.bufnum, 
			\minframes, 0, \maxframes, s.sampleRate * 8.0,
			\choprate, rates[2],
			\posrate, 0.5,
			\rate, rates[3],
			\atk, atk,
			\rel, rel,
			\dur, dur,
			\level, 0.5 * lvlscale
		]);
	};
	
	
	~grains2 = { arg rates, atk=0.25, dur=1.75, rel=0.5, lvlscale=2.0;
		
		Synth.new(\chopgrain_1shot, [
			\buf, ~vla_loop2_buf.bufnum, 
			\minframes, 0, \maxframes, s.sampleRate * 8.0,
			\choprate, 2,
			\rate, rates[0],
			\atk, atk,
			\rel, rel,
			\dur, dur,
			\level, 0.2 * lvlscale
		]);
		
		Synth.new(\chopgrain_1shot, [
			\buf, ~vla_loop2_buf.bufnum, 
			\minframes, 0, \maxframes, s.sampleRate * 8.0,
			\choprate, rates[0],
			\rate, rates[1],
			\atk, atk,
			\rel, rel,
			\dur, dur,
			\level, 0.18 * lvlscale
		]);
		
		Synth.new(\chopgrain_1shot, [
			\buf, ~vla_loop2_buf.bufnum, 
			\minframes, 0, \maxframes, s.sampleRate * 8.0,
			\choprate, rates[1],
			\posrate, 0.25,
			\rate, rates[2],
			\atk, atk,
			\rel, rel,
			\dur, dur,
			\level, 0.17 * lvlscale
		]);
		
		Synth.new(\chopgrain_1shot, [
			\buf, ~vla_loop2_buf.bufnum, 
			\minframes, 0, \maxframes, s.sampleRate * 8.0,
			\choprate, rates[2],
			\posrate, 0.5,
			\rate, rates[3],
			\atk, atk,
			\rel, rel,
			\dur, dur,
			\level, 0.16 * lvlscale
		]);
	};
	
	~jl_play_s = Array.fill(4, { arg i;
		Synth.new(\justloop_play, [\buf, [ ~vla_loop1_buf.bufnum, ~vla_loop2_buf.bufnum].choose, \looptime, 12.0 + i, \level, -16.dbamp, \pan , i.linlin(0, 3, -0.8, 0.8), \out, 0]);
	});
	
	~tempo = 1.0;
	
	
	~chordgrains_r = Routine { inf.do({ arg i; ~ratios.do({ arg rats;
		rats.postln;
	
		
		8.do({ arg i;
			~jl_play_s[i].set(\ratelag, 0.1 + 0.1.rand);
			~jl_play_s[i].set(\rate, rats[i % (rats.size)] * ~interval_1);
		});
		
		~grains1.value(rats * ~interval_1, 2.0, 4.0, 2.0);
		
	//	if (i > 31, {~grains2.value(rats * ~interval_2)});
		~grains2.value(rats * ~interval_2, 3.0, 2.0, 3.0);
	
		6.0.wait;
	}); }); }.play;
	
	
	~vox_delay.set(\time, 8*4*3);
	~vox_delay2.set(\time, 8*4*2);
	~vox_delay3 = Synth.new(\echo_buf, [\in, ~vox_in_b.index, \buf, ~vox_echo3_buf.bufnum, \maxtime, 4*4*5, \time, 4*4*8, \out, 0, \amp, -6.dbamp], ~xg);
	~vox_delay2.set(\time, 8*4+4);
	
	~vla_delay.set(\time, 8 * 4 * 3);
	~vla_delay2 = Synth.new(\echo_buf, [\in, ~vla_in_b.index, \buf, ~vla_echo2_buf.bufnum, \time, 4*4*4, \out, 0, \amp, -6.dbamp], ~xg);a
	~vla_delay3 = Synth.new(\echo_buf, [\in, ~vla_in_b.index, \buf, ~vla_echo3_buf.bufnum, \time, 4*8, \out, 0, \amp, -6.dbamp], ~xg);
	~vla_delay3.set(\time, 8 * 8);
	
	~vla_delay.set(\amp, 1.0);
	~vla_delay3.set(\amp, 1.0);
}.play;
