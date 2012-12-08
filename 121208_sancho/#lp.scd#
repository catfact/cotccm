~lrec_start = {
	~vr = c.recOnce(0, ~voc_lbuf.bufnum);
	~sr = c.recOnce(1, ~syn_lbuf.bufnum);
};

/*
	~lrec.value;	
	~voc_lbuf.plot;
	~syn_lbuf.plot;
*/

~lrec_end = {
	~vr.free;
	~sr.free;
};


~play1 = { arg g, buf, r, start, atk, sus, rel;
	Synth.new(\play_1_env_1shot, [\buf, buf.bufnum, \rate, r, \atk, atk, \sus, sus, \rel, rel]);
};

~plurg = Group.new(c.og, \addBefore);

~plur = { arg num, buf, pos0=0, r0=1.0, a0=2.0, posadd=1.0, rmul = -6/5, aadd = 0.125, w=1.0, dur=60.0, rel0=30, rsub=0.125;
	var pg = Group.new(~plurg);
	var pos = pos0;
	var r = r0;
	var atk = a0;
	var rel = rel0;
	var sus;

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

~plur.value(6, ~voc_lbuf);
~plur.value(8, ~voc_lbuf, w:4.0, rmul:-5/4);

~plur.value(8, ~voc_lbuf, w:4.0, rmul:-5/6);

~plur.value(8, ~voc_lbuf, w:2.0, pos0:10, r0:0.25, rmul:-9/8);

~plur.value(8, ~syn_lbuf, w:2.0, pos0:10, r0:0.125, rmul:-5/4);

~plur.value(4, ~syn_lbuf, w:2.0, pos0:10, r0:1.0, rmul:16/17);

~play1.value(~syn_lbuf, 4/3, 0, 10, 60, 0);
~play1.value(~syn_lbuf, -6/5, 0, 10, 60, 0);

~play1.value(~voc_lbuf, -4/3, 0,  30, 60, 0);
~play1.value(~voc_lbuf, -5/4, 10, 30, 60, 0);


p = Synth.new(\play_1, [\buf, ~voc_lbuf, ]);
p = Synth.new(\play_1, [\buf, ~syn_lbuf, \rate, 6/5 ]);




p.free;


p.set(\rate, 6/5);

p = { Out.ar(0, PlayBuf.ar(1, ~voc_lbuf.bufnum)); }.play;

p.free;

p.free;


~voc_lbuf.plot;

*/