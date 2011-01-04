//s = Server.local.boot; 
// for remote control...
// ~bunny_server_addr = NetAddr.new("192.168.1.80", 57110);
// s = Server.new("bunny", ~bunny_server_addr);

s.waitForBoot {
	 
	 x.value("midi_sines.scd");
	 
	~period_a = 60.0 / 80.0;  // 80 bpm
	//~beats_a = (3 + 2 + 3 + 3 + 5 + 4 + 2 + 3 + 6) * 8; // duration in beats
	~beats_a = (3 + 2 + 3 + 5 + 4 + 2 + 3 + 6) * 8; // duration in beats
	// test, shorter:
	// ~beats_a = (3 + 2 + 3 + 5 + 4 + 2 + 3 + 6) * 2; // duration in beats
	~period_b = 0.5; 			// 120 bpm  
	
	~buffer_a = Buffer.alloc(s, ~beats_a * ~period_a * s.sampleRate);
	
	~buffer_vla = Buffer.alloc(s, ~beats_a * ~period_b * 0.25 * s.sampleRate); 
	 
	 ~grain_g = Group.new(s);
	 ~grain_b = Bus.audio(s, 1);		   
	 
	 SynthDef.new(\grain1shot, {  
		arg out=0, buf, level=1.0, start=0.0, dur=2.0, attack=0.001, release=0.001; 
		var amp, play, ratescale, sr; 
		ratescale = BufRateScale.kr(buf);
		sr = BufSampleRate.kr(buf);
		amp = EnvGen.ar(Env.linen(attack, (dur-attack)-release, release), gate:1, doneAction:2) * level; 
		play = BufRd.ar(1, buf, Line.ar(start * sr, (start + dur)*sr, dur / ratescale));
		Out.ar(out, play);
	}).send(s);
	 
	SynthDef.new(\churchdist, { arg in, out, level=0.5, shapebuf;
		var sig;
		sig = In.ar(in); 
		sig = LPF.ar(sig, 8000);
		sig = sig + PitchShift.ar(sig, 0.25, 0.5) + PitchShift.ar(sig, 2.0, 0.25);
		// sig = sig.distort.distort.distort + DelayN.ar(sig.abs.distort, 0.25, 0.25); 
		sig = Shaper.ar(shapebuf, sig).distort;
		sig = MoogFF.ar(sig,  
			LFSaw.ar([0.5, 0.25, 1.0], 0, 0.5, 0.5) * 64.midicps * 2 + 64.midicps,
			LFSaw.ar([0.2, 0.1], 0, 1.0, 2.0) 
		) + sig;
		sig = Mix.new(sig);
		Out.ar(out, sig*level);
	}).send(s);
 	 
	// functions
	~churchkey_func_a = { 
		Routine ({
			// conductor tremolo
			~trem_s = SynthDef.new(\conductor_chorus, {
				arg out=0, in=0,
					period=0.125, level=1.0,
					lfoWidth=0.5, lfoAttack=0.001, lfoPhase=0.0, lfoDecay=0.001,
					delWidth=0.1, delBase=0.01; 
				var del, deltime;
				deltime = LFPulse.ar(1.0/period, lfoPhase, lfoWidth)*delWidth + delBase;
				deltime = Lag2.ar(deltime, lfoAttack);
				del = DelayC.ar(In.ar(in), 1.0, A2K.kr(deltime));
				Out.ar(out, del * level);
			}).play(~sinegroup, [
				\in, ~sinebus.index,
				\period, ~period_a * 4.0,
				\delWidth, 0.05,
				\delBase, 0.07,
				\lfoAttack, 0.001,
				\level, 0.125
			], \addAfter); 
		  	
		  	~period_a.wait;
		  		
			~trem_2_s = Synth.new(\conductor_chorus, [
				\in, ~sinebus.index,
				\period, ~period_a * 2.0, 
				\lfoPhase, 0.5,
				\delWidth, 0.05,
				\delBase, 0.07,
				\lfoAttack, 0.001,
				\level, 0.125  
			]).play(~sinegroup, \addAfter); 
			
			
			(~period_a * 7).wait;
		
			// schedule record
			/*
			~rec_s = SynthDef.new(\recAdc1shot, { arg in, buf;
				RecordBuf.ar(SoundIn.ar(in), buf, loop:0, doneAction:2);
			}).play(s, [\buf, ~buffer_a.bufnum, \in, 0]);
			*/
			~rec_s = SynthDef.new(\rec1shot, { arg in, buf;
				RecordBuf.ar(In.ar(in), buf, loop:0, doneAction:2);
			}).play(~sinegroup, [\buf, ~buffer_a.bufnum, \in, ~sinebus.index], \addAfter);
			
			"recording A".postln;
			
			// ~beats_a * ~period_a.wait;			
			// ~churchkey_func_b.value; 
			~funcA_r.remove;
			~funcB_r = CCResponder({
					arg src, chan, num, val;
					if (val > 0, {
						~churchkey_func_b.value;
					});
				},
				nil, // any source
				nil, // any channel
				16, // last pad, first banmk
				nil // any value
			)

			//~switch_func = { arg val; if (val>0, {~churchkey_func_b.value; }, {}); };
			
		}).play;
	};
	 
	~chopgrain = 2; // chop granularity in beats 
	~churchkey_func_b = {
		"churchkey_b".postln;
		x.value("vox_echo_churchkey.scd");
		
		~funcB_r.remove;
			   
		~chop_loop_advance_r = Routine({   
			// chop and loop	for N chop-grains
			32.do({
				arg i;
				~chop_loop_s = Synth.new(\grain1shot,  
				[	\buf, ~buffer_a.bufnum,  
					\start, 0.0, // i*(~period_a*~chopgrain),
					\dur, (~period_a*~chopgrain),
					\out, ~grain_b.index
				], ~grain_g); 	 
				(~chopgrain*~period_b).wait;	 
			});	 
			
			// viola looper
			~vla_loop = {
				var recrun, looprun, play;
				recrun = Line.kr(0.0, 1.0, ~beats_a * ~period_b * 0.5) < 1.0;
				// looprun = Line.kr(0.0, 1.0, ~beats_a * ~period_b, doneAction:2);
				RecordBuf.ar(SoundIn.ar(1), ~buffer_vla.bufnum, preLevel:1.0, run:recrun, loop:1);
				play = PlayBuf.ar(1, ~buffer_vla.bufnum, loop:1);
				Out.ar(0, Pan2.ar(play));
			}.play(s);
			
			// chop and advance for the rest
			(~beats_a + 16).do({
				arg i;
				~chop_loop_s = Synth.new(\grain1shot,  
				[	\buf, ~buffer_a.bufnum,  
					\start,i*(~period_a*~chopgrain),
					\dur, (~period_a*~chopgrain),
					\out, ~grain_b.index
				], ~grain_g); 	 
				(~chopgrain*~period_b).wait;		 
				postln(i*(~period_a*~chopgrain));
			}) 
		}).play(SystemClock);	
		
		~grain_out_s = { Out.ar(0, In.ar(~grain_b.index)) }.play(~grain_g, \addAfter);
		~grain_out_dist_s = Synth.new(\churchdist, [\in, ~grain_b.index, \out, 0, \shapebuf, ~shapebuf.bufnum], ~grain_g, \addAfter);
	}; 
	 
//	 ~switch_func = { arg val; if (val>0, {~churchkey_func_a.value; }, {}); };
	~funcA_r = CCResponder({
			arg src, chan, num, val;
			if (val > 0, {
				"churchkey A".postln;
				~churchkey_func_a.value;
			});
		},
		nil, // any source
		nil, // any channel
		16, // last pad, first banmk
		nil // any value
	)

	 
}; // waitForBoot