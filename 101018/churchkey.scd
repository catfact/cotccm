//s = Server.internal; 
// for remote control...
~bunny_server_addr = NetAddr.new("192.168.1.80", 57110);
s = Server.new("bunny", ~bunny_server_addr);

s.waitForBoot {
	 
	~period_a = 60.0 / 80.0;  // 80 bpm
	~beats_a = (3 + 2 + 3 + 3 + 5 + 4 + 2 + 3 + 6) * 4; // duration in beats
	~period_b = 0.5; 			// 120 bpm  
	
	~buffer_a = Buffer.alloc(s, ~beats_a * ~period_a * s.sampleRate);
	  
	 SynthDef.new(\grain1shot, {  
		arg out=0, buf, level=1.0, start=0.0, dur=2.0, attack=0.001, release=0.001; 
		var amp, play;
		amp = EnvGen.ar(Env.linen(attack, (dur-attack)-release, release), gate:1, doneAction:2) * level; 
		play = PlayBuf.ar(1, buf, BufRateScale.kr(buf)); // , loop:0, startPos:start);
		//Out.ar(out, play*amp);  
		Out.ar(out, play);
	}).send(s);
	  
	  	
	// functions
	~churchkey_func_a = { 
	
		// conductor tremolo
		~trem_s = SynthDef.new(\conductor_chorus, { arg out=0, in=0, period=0.125, lfoWidth=0.5, lfoAttack=0.001, lfoDecay=0.001, delWidth=0.1, delBase=0.01; 
		var del, deltime;
		deltime = LFPulse.ar(1.0/period, 0, lfoWidth)*delWidth + delBase;
		deltime = Lag2.ar(deltime, lfoAttack);
		del = DelayC.ar(SoundIn.ar(in), 1.0, A2K.kr(deltime));
		Out.ar(out, del);
	}).play(s, [
		\period, ~period_a * 4.0,
		\delWidth, 0.0005,
		\delBase, 0.02,
		\lfoAttack, 0.001
	]);	 
		Routine ({
			(~period_a * 16).wait;
		
			// schedule record
			~rec_s = SynthDef.new(\recAdc1shot, { arg in, buf;
				RecordBuf.ar(SoundIn.ar(in), buf, loop:0, doneAction:2);
			}).play(s, [\buf, ~buffer_a.bufnum, \in, 0]); 
			
			~beats_a * ~period_a.wait;
			
			~churchkey_func_b.value;
		});
	};
	 
	~chopgrain = 2; // chop granularity in beats 
	~churchkey_func_b = {
		   
		~chop_loop_advance_r = Routine({   
			// chop and loop	for N chop-grains
			32.do({
				arg i;
				~chop_loop_s = Synth.new(\grain1shot,  
				[	\buf, ~buffer_a.bufnum,  
					\start, 0.0, // i*(~period_a*~chopgrain),
					\dur, (~period_a*~chopgrain)
				], s); 	 
				(~chopgrain*~period_b).wait;	 
			});	  
			// chop and advance for the rest
			inf.do({
				arg i;
				~chop_loop_s = Synth.new(\grain1shot,  
				[	\buf, ~buffer_a.bufnum,  
					\start,i*(~period_a*~chopgrain),
					\dur, (~period_a*~chopgrain)
				], s); 	 
				(~chopgrain*~period_b).wait;		
			}) 
		}).play(SystemClock);	
	}; 
	 
}; // waitForBoot