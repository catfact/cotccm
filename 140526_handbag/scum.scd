// ambient scum sweeps
Routine { 
	SynthDef.new(\buf_env_dist, { 
		// bus
		arg out = 0,
		// playback
		buf = 0,
		level = 0.1,
		pos = 0.0,
		// envelope
		atk = 1.0,
		sus = 1.0,
		rel = 1.0,
		atkcurve = 0.1,
		relcurve = 0.1;

		
		var env = Env.new(
			levels:[0.0, 1.0, 1.0, 0.0],
			times:[atk, sus, rel],
			curve:[atkcurve, 0, relcurve]
		);
		
		var amp = EnvGen.ar(env, doneAction:2);
		var play = PlayBuf.ar(numChannels:1, bufnum:buf, startPos:pos);
		Out.ar(out, play * amp);

	}).send(s);

	s.sync;

	// sitting in a room 

	~bufl = 144.0;
	~buf = Buffer.alloc(s, ~bufl * s.sampleRate);

	s.sync;

	//--- record with some filtering (block DC, ...? )
	~inb = Bus.audio(s, 1);
	~ins = Synth.new(\adc, [\in, 0, \out, ~inb.index]);
	~rec = Synth.new(\rec, [\in, ~inb.index, \buf, ~buf.bufnum, \loop, 1],
		target:~ins, addAction:\addAfter);

	//--- play clusters
	~clp = 6.0; 	// period of trigger
	~cln = 16; 	// how many
	~cld = 6.0; 	// duration
	// routine
	~clr = Routine { inf.do {
		// equal distribution of starting position
		var pos = Array.series(~cln, 0.0, (~bufl - ~cld) / (~cln - 1) );
		pos.do({ arg thePos;
			thePos.postln;
			Synth.new(\buf_env_dist, [
				\pos, thePos * s.sampleRate,
				\buf, ~buf.bufnum, 
				\atk, ~cld * 0.7, 
				\sus, ~cld * 0.3,
				\rel, 0.001,
				\atkcurve, 0.77
			]);
		});
		~clp.wait;
	} }.play;


	77.wait;

	

	// get slower
	~slowr = Routine { inf.do { 
		//	if(~clp > 0.077, {
		~clp = ~clp / 0.977;
		~cld = ~cld / 0.979;
		//	});
		~clp.wait;
	} }.play;
	
	// more overlap
	

	//-- glitch around
	// giitch period
	~glp = 
	~glr = { Routine
		
	};

}.play;

/*

	~rec.set(\run, 0);
	~rec.set(\run, 1);


~slowr.stop;
~slowr.play;

*/