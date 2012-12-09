~lrec_stat = 0;
~vrec = Synth.new(\rec, [\in, c.in_b.index, \buf, ~vl_buf.bufnum], c.ig, \addAfter);
~srec = Synth.new(\rec, [\in, c.in_b.index + 1, \buf, ~sl_buf.bufnum], c.ig, \addAfter);

~vrec.run(false);
~srec.run(false);

~lrec_start = {
	~post.value("lrec start");
	//	~vr = c.recOnce(0, ~vl_buf.bufnum);
	//	~sr = c.recOnce(1, ~sl_buf.bufnum);
	~vrec.run(true);
	~srec.run(true);
	~lrec_stat = 1;
};

/*
	~lrec.value;	
	~vl_buf.plot;
	~sl_buf.plot;
*/

~lrec_stop = {
	~post.value("lrec stop");
	//	~vr.free;
	//	~sr.free;
	~vrec.run(false);
	~srec.run(false);
	~lrec_stat = 0;
};

~lrec_tog = { if(~lrec_stat > 0, {~lrec_stop.value; }, {~lrec_start.value;}); };


~play1 = { arg g, buf, r, start, atk, sus, rel;
	Synth.new(\play_1_env_1shot, [
		\amp, -6.dbamp,
		\buf, buf, 
		\rate, r, \atk, atk, \sus, sus, \rel, rel
	],	~plurg);
};

~plurg = Group.new(c.og, \addBefore);
~plurg.set(\amp, -12.dbamp);

~plur = { arg num, which, pos0=0, r0=1.0, a0=2.0, posadd=1.0, rmul = -6/5, aadd = 0.125, w=1.0, dur=60.0, rel0=30, rsub=0.125;
	var pg = Group.new(~plurg);
	var pos = pos0;
	var r = r0;
	var atk = a0;
	var rel = rel0;
	var sus;
	var buf = which.switch(0, {~vl_buf.bufnum}, 1, {~sl_buf.bufnum});

	sus = dur - a0 - r0;
	if(sus < 1.0, { sus = 1.0; });

	Routine {
		[r, pos].postln;
		num.do {
			~play1.value(pg, buf, r, pos, atk, sus, rel);
			atk = atk + aadd;
			rel = rel - rsub;
			sus = dur - a0 - r0;
			if(sus < 1.0, { sus = 1.0; });
			if(rel < 0.0, { rel = 1.0; });
			pos = pos + posadd;
			r = r * rmul;
			w.wait;
		}; 
	}.play;
};
	
/*

~plur.value(6, ~vl_buf);
~plur.value(4, ~vl_buf, w:14.0, rmul:-5/4);

~plur.value(6, 0, w:6.0, r0:8/9, rmul:9/8);
~plur.value(6, 0, w:6.0, r0:5/6, rmul:5/4);

~plur.value(8, ~vl_buf, w:4.0, rmul:-5/6);

~plur.value(8, ~vl_buf, w:2.0, pos0:10, r0:0.25, rmul:-9/8);

~plur.value(8, ~sl_buf, w:2.0, pos0:10, r0:0.125, rmul:-5/4);

~plur.value(4, ~sl_buf, w:2.0, pos0:10, r0:1.0, rmul:16/17);

~play1.value(~sl_buf, 4/3, 0, 10, 60, 0);
~play1.value(~sl_buf, -6/5, 0, 10, 60, 0);

~play1.value(~vl_buf, -4/3, 0,  30, 60, 0);
~play1.value(~vl_buf, -5/4, 10, 30, 60, 0);


p = Synth.new(\play_1, [\buf, ~vl_buf, ]);
p = Synth.new(\play_1, [\buf, ~sl_buf, \rate, 6/5 ]);




p.free;


p.set(\rate, 6/5);

p = { Out.ar(0, PlayBuf.ar(1, ~vl_buf.bufnum)); }.play;

p.free;

p.free;


~vl_buf.plot;

*/