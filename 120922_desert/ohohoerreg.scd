c  = CfAudioContext.new(s, 2, {});

s.boot;

~pos = 20.0;
~atk = 0.25;
~sus = 1.0;
~rel = 1.0;
~hz = 400;
~rate = 0.75;
~rq = 0.25;
~tw = 0.5;
~amp = 0.25;

~crchop.value;
 
~bbuf.plot

~choplist.last.r.isPlaying
~choplist.last.r.stop;

~choplist.do({ arg ev; ev.r.stop; });
~choplist.do({ arg ev; ev.r.play; });

~choplist.last.tw

~choplist[0].r.play;
~choplist[0].r

~tw = 

~bbuf.plot

~choplist[0].stop;


~analist

~tr.stop;

~qr = Routine{ inf.do {
	//	ev.postln;
	Synth.new(\rlpfbuf, [
		\buf, ~bbuf.bufnum,
		\pos, 44100 * ~pos, //ev.pos,
		\amp, ~amp, //ev.amp,
		\atk, ~atk, //ev.atk,
		\sus, ~sus, //ev.sus,
		\rel, ~rel, //ev.rel,
		\rate, ~rate ,//ev.rate, 
		\hz, ~hz, //ev.hz, 
		\rq, ~rq, //ev.rq, 
		//					\out, c.out_b.index
		\out, 0
	], target:c.xg );
	//ev.tw.wait;
	~tw.wait;
} }.play;


~qr = Routine{ inf.do {
		Synth.new(\rlpfbuf, [
		\buf, ~bbuf.bufnum,
		\pos, 44100 * ~pos,
		\amp, 0.25,
		\atk, ~atk,
		\sus, ~sus,
		\rel, ~rel,
		\rate, ~rate, 
		\hz, ~hz, 
		\rq, ~rq, 
		//		\out, c.out_b.index
		\out, 0
	], target:c.xg);
	~tw.wait;
} }.play;


~qr.stop;