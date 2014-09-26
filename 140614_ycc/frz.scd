Routine {

	SynthDef.new(\rec, {
		arg in=0, buf=0,
		reclevel=1.0, prelevel=0.0, offset=0.0, trig=1.0, loop=1, run=1,
		atk=0.01, rel=0.01, gate=1;
		
		RecordBuf.ar(In.ar(in, 1),
			bufnum: buf, 
			offset:0,
			recLevel:reclevel,
			preLevel:prelevel,
			run:run,
			loop:loop,
			trigger:trig
		);
	}).send(s);

	/// length
	~frLen = 8.0;
	/// count
	~frN = 8;
	// bufs
	~frBuf = Array.fill(~frN, { Buffer.alloc(s, s.sampleRate * ~frLen); });  
	/// synths
	~frRec = Array.newClear(~frN);
	/*
	~frRec = Array.fill(~frN, { |i|
		Synth.new(\rec, [
			\in, c.in_b.index,
			\buf, ~frBuf[i].bufnum,
		], c.ig, \addAfter).run(false);
	});
	*/
	
	// array of press times
	~frt = Array.newClear(~frN);
	// temp buffer
	~frbuftmp = Buffer.alloc(s, s.sampleRate * ~frLen);
	/// recording function, args are index and T/F
	~frz_rec = { arg n, val;
		postln( ["fr_rec", n, val]);
		Routine {  // apply value and reset
			if(val, {
				~frt[n] = SystemClock.seconds;
				~frRec[n] = Synth.new(\rec, [
					\in, c.in_b.index,
					\buf, ~frBuf[n].bufnum,
				], c.ig, \addAfter);
				
			}, {
				Routine {
					var t;
					~frRec[n].free;
					t = SystemClock.seconds - ~frt[n];
					t = t * s.sampleRate;
					// zero tmp
					~frbuftmp.zero; 					
					//					{ ~frbuftmp.plot; }.defer;
					s.sync;
					// copy to tmp
					~frBuf[n].copyData(~frbuftmp, 0, 0, t);					
					//					{ ~frbuftmp.plot; }.defer;
					s.sync;
					// normalize tmp
					~frbuftmp.normalize(0.25);				
					//					{ ~frbuftmp.plot; }.defer;
					s.sync;
					// copy back
					~frbuftmp.copyData(~frBuf[n], 0, 0, t);	

				}.play;
});
}.play;
};

s.sync;


}.play;

/*
	~frBuf.do({ arg buf; buf.plot; });
	~frBuf[0].plot;
	~frBuf[0].normalize;
	~frBuf[0].numFrames
	~frBuf.do({ arg buf; buf.normalize(0.6); });

*/