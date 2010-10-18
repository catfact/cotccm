s = Server.local.boot;  
s.waitForBoot {
Routine {
	// ADC INDICES
	~vla_in=0;
	~guit_in=0;
	~vox_in = 1;
		
	// tempo and duration
	~beat = 60.0/100.0; 
 
 
 	SynthDef.new(\grain1shot, {  
		arg out=0, buf, level=1.0, start=0.0, dur=2.0, attack=0.001, release=0.001; 
		var amp, play, ratescale, sr; 
		ratescale = BufRateScale.kr(buf);
		sr = BufSampleRate.kr(buf);
		amp = EnvGen.ar(Env.linen(attack, (dur-attack)-release, release), gate:1, doneAction:2) * level; 
		play = BufRd.ar(1, buf, Line.ar(start * sr, (start + dur)*sr, dur / ratescale));
		Out.ar(out, play);
	}).send(s);
	  
 
 	
	//// crazy shaped echo
	~guit_echo_s = SynthDef.new(\caEcho, { arg in=~guit_in, out=0, level=1.25;
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
			[0.18, 0.07, 0.06, 0.08],
			[10, 50, 200, 1000],
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
		
	/*	
	~dur = ~beat * 2 * 4 * 5; // one chord
	~dur = ~dur * 2 * 2; // the first two verse-cycles : Eb Cm Eb Cm 
	// bridge : Eb, Ab, Eb
	~dur = ~dur + ((~beat * 2 * 4)  * 3) + ((~beat * 2 * 4) * 4) + ((~beat * 2 * 4) * 3) ; 
	~dur = ~dur + ((~beat * 2 * 4) * 8); // a long time for the final Cm 

	~dur.postln;
	*/
	 
	 ~dur = 182.4;	
	
	/// loop is a single very long echo
	~guit_loop_buf = Buffer.alloc(s, s.sampleRate * (~dur+1), 1);
	 
	 
	~del_stop_func = { 
		~guit_loop_s.free;
		~switch_func = { arg val; if(val>0, { ~del_start_func.value; }, { }); }; 
	}; 
	
	SynthDef.new(\bufDelay, {
		arg in=0, buf, out=0, level=1.0, delaytime=182.4;
		Out.ar(out, BufDelayN.ar(buf, SoundIn.ar(in), delaytime) * level);
	}).send(s);
	
	~del_start_func = {  
		~rec_s = SynthDef.new(\recAdc1shot, { arg in, buf;
			RecordBuf.ar(SoundIn.ar(in), buf, loop:0, doneAction:2);
		}).play(s, [\buf, ~guit_loop_buf.bufnum, \in, 0]); 
		SystemClock.sched(~dur, {
			~guit_loop_s = Synth.new(\grain1shot,  
			[	\buf, ~guit_loop_buf.bufnum,  
				\start, 0.0,
				\dur, ~dur
			], s); 	 
		nil });
		 postln("echo engaged");
		 ~switch_func = { arg val; if(val>0, { ~del_stop_func.value; }, { }); }; 

	}; 
	
	
	~switch_func = ~del_start_func;
	
}.play; 
};