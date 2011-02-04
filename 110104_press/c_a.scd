s = Server.local.boot;  
s.waitForBoot {
Routine {
	// ADC INDICES
	~vla_in=0;
	~guit_in=0;
	~vox_in = 1;
		
	// tempo and duration
	~beat = 60.0/100.0; 
 
 
 	SynthDef.new(\drifter, {  
		arg out=0, buf, level=1.0, start=0.0, gate=1, attack=1.0, release=8.0, grainrate=(10/3), graindur=1.2, posrate = 3/5, posround=0.6; 
		var amp, play, dur, ratescale, sr; 
//		ratescale = BufRateScale.kr(buf); 
//		sr = BufSampleRate.kr(buf); 
		dur = BufDur.kr(buf);
		amp = EnvGen.ar(Env.asr(attack, 1.0, release), gate:gate, doneAction:2) * level; 
//		play = BufRd.ar(1, buf, Line.ar(start * sr, (start + dur)*sr, dur / ratescale));   
		play = PlayBuf.ar(1, buf, [1.0, 0.5, 2.0],  
			trigger: (Impulse.kr(grainrate)),
			startPos: [
				(LFNoise2.kr(posrate) * dur).round(posround),
				(LFNoise2.kr(posrate) * dur).round(posround),
				(LFNoise2.kr(posrate) * dur).round(posround) 
			],
			loop:1
		);
		/*
		play = Mix.new( 
			TGrains.ar( 
				2,  
				LFPulse.kr(grainrate),  
				buf,  
				1.0, 		// rate
				LFTri.kr(1.0 / dur) * dur,   // centerPos
				0.00,		// pan 
				1.0			// amp
			);		 
		); 
		*/
		Out.ar(out, Mix.new(play) * amp);
//		Out.ar(out, play);
	}).send(s);
	  
 
 	
	//// crazy shaped echo
	~guit_echo_s = SynthDef.new(\caEcho, { arg in=~guit_in, out=0, level=0.5;
		var input, del;
		input = SoundIn.ar(in); 
		// multichannel delay
		del = [
			DelayN.ar(input, ~beat, ~beat),
			DelayN.ar(input, ~beat*2, ~beat*2),
			DelayN.ar(input, ~beat*1.5, ~beat*1.5) * (LFPulse.kr(1/~beat) + 0.5),
			DelayN.ar(input, ~beat*8, ~beat*8)
		] * 0.5;
		// gate each channel differently
		
		del = Compander.ar(del, del,
			// each of these is length of delay structure
			[0.05, 0.03, 0.02, 0.004],
			[1, 2, 3, 4],
			[0.01, 0.05, 0.1, 0.2],
			( [0.01, 0.05, 0.1, 0.2] * 5).reverse
		);
		
		// filter each channel differently
		del = del + MoogFF.ar(del,
			// each of these is length of delay structure
			41.midicps * [2, 6, 4, 1] * 1,
			[2, 3, 3, 3.5]
		);	 
 	
 		del = del + del.distort.distort;	 
		Out.ar(out, Mix.new(del) * level);
	}).play(s);
 
 
 	~guit_chord_buf = Array.fill(3, { 
 		Buffer.alloc(s, s.sampleRate * ~beat*2*4*5, 1);
 	});
 		
	~guit_rec_func = {arg which;
		if(~guit_rec_s.notNil, {~guit_rec_s.free; });
		~rec_s = SynthDef.new(\recAdc1shot, { arg in, buf;
			RecordBuf.ar(SoundIn.ar(in), buf, loop:0, doneAction:2);
		}).play(s, [\buf, ~guit_chord_buf[which].bufnum, \in, ~guit_in]); 
	};  
	
	~guit_play_func = { arg which; 
		~guit_play_s = Synth.new(\drifter, [\buf, ~guit_chord_buf[which].bufnum]);
	};
	
	~guit_stop_playing_func = {
		~guit_play_s.set(\gate, 0);		
	};
	 
	 // hhacckky little variable
	~status = 0;
	~switch_func = { arg val; 
		if (val>0, {
			postln("press " ++ ~status);
			~status.switch( 
				0, { // recording 1st chord
					~guit_rec_func.value(0);
				},
				1, { // recording 2nd chord 
					~guit_rec_func.value(1);
				},
				2, { // recording 3rd chord
					~guit_rec_func.value(2);
				},  
				3, { // play 1st chord
					~guit_play_func.value(0);
				},  
				4, { // play 2nd chord
					~guit_play_func.value(1);
				},  
				5, { // play 1st chord
					~guit_play_func.value(0);
				},  
				6, { // play 2nd chord
					~guit_play_func.value(1);
				},  
				7, { // play 1st chord
					~guit_play_func.value(0);
				},  
				8, { // play 3rd chord
					~guit_play_func.value(2);
				},  
				9, { // play 1st chord
					~guit_play_func.value(0);
				},  
				10, { // play 2nd chord
					~guit_play_func.value(1); 
					// also, start putting the viola signal into the grain
					~vla_rec = {	RecordBuf.ar(~guit_chord_buf[2].bufnum, SoundIn.ar(~vla_in),
							loop:1,
							preLevel:0.5;
						);
					}.play(s);
				}
			);
		}, { 
			postln("lift " ++ ~status);
			~status.switch( 
				0, { // recording 1st chord
				},
				1, { // recording 2nd chord 
				},
				2, { // recording 3rd chord
				},  
				3, { // stop playing
					~guit_stop_playing_func.value;
				},  
				4, { 
					~guit_stop_playing_func.value;
				},  
				5, { 
					~guit_stop_playing_func.value;
				},  
				6, { 
					~guit_stop_playing_func.value;
				},  
				7, { 
					~guit_stop_playing_func.value;
				},  
				8, { 
					~guit_stop_playing_func.value;
				},  
				9, { 
					~guit_stop_playing_func.value;
				},  
				10, {  
					~guit_play_s.set(\release, 24.0);
					~guit_stop_playing_func.value; 
					~vla_rec.free;
				}
			); 
			// advance status on pedal lift
			~status = ~status + 1; 
			if (~status > 10, {~status = 3; });
		}); // button state test
	}; // swirch function
}.play; 
};