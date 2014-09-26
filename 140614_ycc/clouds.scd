~cl = { arg n;
	var lastpitch;
	n.do({ arg i;
		var ev, rate;
		ev = ~analist.choose;
		ev.postln;
		if(lastpitch.isNil, {
			lastpitch = ev.pitch;
		});
		rate = ev.pitch  / lastpitch;
		rate.postln;
		Synth.new(\grain_1shot_rez_env, [
			\buf, ~frBuf.wrapAt(i).bufnum,
			\pos, 0.06,
			\dur, 10 + 1.rand;
			\rate, rate,
			\trigrate, 1.0 + 5.0.rand;
			\hz, ev.pitch * 4;
			\rq, ev.clar;
			\insideout, 0.5,
			\atk, 1.0.rand, 
			\rel,  5 + 1.rand,
			\out, 0,
			\level, 0.5,
			\pan, 0.5,
			\rezmix, 0.5
		], s);
	});
};

/*

~clr=	Routine { inf.do { 
	~cl.value(5);
	5.0.wait;
	};
	}.play;

*/