Routine {
	
	~chopr_p = 70/60 * 0.25;
	~chopbuflen = ~chopr_p * 16.0;

	~chopbuf = Buffer.alloc(s, ~chopbuflen * s.sampleRate); 
	
	s.sync;
	
	SynthDef.new(\threshRecord, {
		arg in=0, buf,
			thresh=0.0625, ampAtk=0.2, ampRel=1.0,
			offset=0, recLevel = 1.0, preLevel=0.0,
			run=1, loop=1, trig=0,
			ampTrigFlag=0,
			runMedianLen = 10;
		var input, ampInRange;
		
		input = SoundIn.ar(in);
		ampInRange = 1 - DetectSilence.ar(input, thresh);
		run = run * ampInRange;
		trig = trig + (ampInRange * ampTrigFlag);
		RecordBuf.ar(input, buf, offset, recLevel, preLevel, run, loop, trig);
	}).send(s);

	~trec_s = Synth.new(\threshRecord, [
		\buf, ~chopbuf.bufnum,
		\thresh, -48.dbamp,
		\in, 1,
		\ampTrigFlag, 1
	]);

	~chopr = Routine { inf.do { arg i;
		Synth.new(\chopgrain_1shot_rez_dist, [
			\buf, ~chopbuf.bufnum,
			\dur, if(i%8 == 0, {6.0 * ~chopr_p}, {3.0 * ~chopr_p}),
			\rate, if(i%5 == 0, {2.0}, {1.0}),
			\choprate, 1.0 / ~chopr_p,
			\hz, 220 * 8/9 * (((i*3)%7) + 1 * 2),
			\rq, (i%4) * 0.2 + 0.07,
			\insideout, if((i%30 == 0) || (i % 24 ==0), {0.06}, {0.0}),
			\atk, 0.01, \rel, ~chopr_p * 2,
			\level, i.min(32) / 32
		], s);
		~chopr_p.wait;
	} }.play;
	
	~chopr2 = Routine { inf.do { arg i;
		Synth.new(\chopgrain_1shot_rez_dist, [
			\buf, ~chopbuf.bufnum,
			\dur, if(i%10 == 0, {6.0 * ~chopr_p}, {3.0 * ~chopr_p}),
			\rate, if(i%5 == 0, {0.5}, {1.0}),
			\choprate, 1.0 / ~chopr_p * 0.5,
			\hz, 110 * 8/9 * (((i*5)%2 + 1) * 4),
			\rq, (i%4) * 0.2 + 0.07,
			\insideout, if((i%20 == 0) || (i % 32 == 0), {0.06}, {0.0}),
			\atk, 0.01, \rel, ~chopr_p * 2,
			\level, i.min(32) / 32
		], s);
		(~chopr_p * 2).wait;
	} }.play;
	
}.play;