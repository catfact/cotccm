~chordgrainsinit = 1;

Routine { SynthDef.new(\bufgrain_pan, {
	arg out=0, amp=1.0, amplag = 0.1, buf=0, rate=1.0, dur=1.0, trigrate=6.0, posrate=1.0, pan=0.0, pos_offset = 0.0, minpos=0.1, maxpos=0.9;
	var pos, grains, trig;
	
	pos = (LFTri.kr(posrate) + pos_offset).wrap(minpos, maxpos);	
	trig = Impulse.kr(trigrate);
	amp = Lag.kr(amp, amplag);
	grains = GrainBuf.ar(1, trig, dur, buf, rate, pos, 2);
	Out.ar(out, Pan2.ar(grains * amp, pan));
}).load(s);

s.sync;

~grint = 1.0;

~grg = Group.new(s);
/*
~grg.free;
*/
~grl = List.new;

~posr = [1.0, 1.25, 1.5, 2.0, 0.5];
~trigr = [2, 2.25, 1.5, 2.0, 1.25, 0.75].reverse;
~grdur = 8.0;
~grr = [1.0, 1.0, -1.0, 0.5, 0.5, 2.0];

8.do({ arg i;
	~grl.add(Synth.new(\bufgrain_pan, [
		\buf, ~jl_bufs[0].bufnum, \pan, i.linlin(0, 7, -0.5, 0.5);
	], ~grg););
});


s.sync;

~setgr = {
	~grl.do({ |gr, i|
		var posr, trigr, grdur, grr, posoff;
		posr = ~posr.wrapAt(i);
		trigr = ~trigr.wrapAt(i);
		posoff = i * 0.0625;
		grr =  ~grr.wrapAt(i) * ~grint;
		grdur = ~grdur / ~trigr.wrapAt(i);
		[ "grain: ", i, posr, trigr, grdur, grr, posoff ].postln;
		gr.set(\posrate, posr);
		gr.set(\trigrate, trigr);
		gr.set(\dur, grdur);
		gr.set(\pos_offset, posoff);
		gr.set(\rate, grr);
		gr.set(	\buf, ~jl_bufs[0].bufnum);
		gr.set(\amp, -14.dbamp);
	});
};


~setgr.value();

/* grain sources:

0 c
1 am
2 em 
3 d
4 am
5 c
6 c

*/

/// c major
~grch1 = {
	~grl[0].set(\buf, ~jl_bufs[0].bufnum, \rate, 1.0);
	~grl[1].set(\buf, ~jl_bufs[0].bufnum, \rate, -1.0);
	~grl[2].set(\buf, ~jl_bufs[0].bufnum, \rate, 0.5);
	~grl[3].set(\buf, ~jl_bufs[0].bufnum, \rate, 2.0);
	~grl[4].set(\buf, ~jl_bufs[2].bufnum, \rate, 1.0);
	~grl[5].set(\buf, ~jl_bufs[6].bufnum, \rate, 1.0);
	~grl[6].set(\buf, ~jl_bufs[6].bufnum, \rate, 1.0);
	~grl[7].set(\buf, ~jl_bufs[6].bufnum, \rate, -1.0);
};


/// c major alternate
~grch1b = {
	~grl[0].set(\buf, ~jl_bufs[6].bufnum, \rate, 1.0);
	~grl[1].set(\buf, ~jl_bufs[6].bufnum, \rate, -1.0);
	~grl[2].set(\buf, ~jl_bufs[6].bufnum, \rate, 0.5);
	~grl[3].set(\buf, ~jl_bufs[6].bufnum, \rate, 2.0);
	~grl[4].set(\buf, ~jl_bufs[2].bufnum, \rate, -2.0);
	~grl[5].set(\buf, ~jl_bufs[0].bufnum, \rate, 1.0);
	~grl[6].set(\buf, ~jl_bufs[0].bufnum, \rate, 1.0);
	~grl[7].set(\buf, ~jl_bufs[0].bufnum, \rate, -1.0);
};

/// a min
~grch2 = {
	~grl[0].set(\buf, ~jl_bufs[1].bufnum, \rate, 1.0);
	~grl[1].set(\buf, ~jl_bufs[1].bufnum, \rate, -1.0);
	~grl[2].set(\buf, ~jl_bufs[1].bufnum, \rate, 0.5);
	~grl[3].set(\buf, ~jl_bufs[1].bufnum, \rate, 2.0);
	~grl[4].set(\buf, ~jl_bufs[4].bufnum, \rate, 1.0);
	~grl[5].set(\buf, ~jl_bufs[6].bufnum, \rate, 5/4);
	~grl[6].set(\buf, ~jl_bufs[6].bufnum, \rate, 2.0);
	~grl[7].set(\buf, ~jl_bufs[6].bufnum, \rate, 10/4);
};

// a min alternate
~grch2b = {
	~grl[0].set(\buf, ~jl_bufs[1].bufnum, \rate, 1.0);
	~grl[1].set(\buf, ~jl_bufs[1].bufnum, \rate, -1.0);
	~grl[2].set(\buf, ~jl_bufs[1].bufnum, \rate, 0.5);
	~grl[3].set(\buf, ~jl_bufs[1].bufnum, \rate, 4.0);
	~grl[4].set(\buf, ~jl_bufs[0].bufnum, \rate, 1.0);
	~grl[5].set(\buf, ~jl_bufs[6].bufnum, \rate, 5/4);
	~grl[6].set(\buf, ~jl_bufs[6].bufnum, \rate, 5/4.0);
	~grl[7].set(\buf, ~jl_bufs[6].bufnum, \rate, 10/4);
};

/// e min
~grch3 = {
	~grl[0].set(\buf, ~jl_bufs[2].bufnum, \rate, 1.0);
	~grl[1].set(\buf, ~jl_bufs[2].bufnum, \rate, -1.0);
	~grl[2].set(\buf, ~jl_bufs[2].bufnum, \rate, 0.5);
	~grl[3].set(\buf, ~jl_bufs[2].bufnum, \rate, 2.0);
	~grl[4].set(\buf, ~jl_bufs[1].bufnum, \rate, 3);
	~grl[5].set(\buf, ~jl_bufs[6].bufnum, \rate, 5/4);
	~grl[6].set(\buf, ~jl_bufs[1].bufnum, \rate, 1.5);
	~grl[7].set(\buf, ~jl_bufs[6].bufnum, \rate, 10/6);
};

/// d min
~grch4 = {
	~grl[0].set(\buf, ~jl_bufs[3].bufnum, \rate, 1.0);
	~grl[1].set(\buf, ~jl_bufs[3].bufnum, \rate, -1.0);
	~grl[2].set(\buf, ~jl_bufs[3].bufnum, \rate, 0.5);
	~grl[3].set(\buf, ~jl_bufs[3].bufnum, \rate, 2.0);
	~grl[4].set(\buf, ~jl_bufs[2].bufnum, \rate, 8/9);
	~grl[5].set(\buf, ~jl_bufs[1].bufnum, \rate, 4/3);
	~grl[6].set(\buf, ~jl_bufs[1].bufnum, \rate, 2/3);
	~grl[7].set(\buf, ~jl_bufs[1].bufnum, \rate, -4/3);
};


/// f maj
~grch5 = {
	~grl[0].set(\buf, ~jl_bufs[0].bufnum, \rate, 4/3);
	~grl[1].set(\buf, ~jl_bufs[0].bufnum, \rate, 2/3);
	~grl[2].set(\buf, ~jl_bufs[0].bufnum, \rate, -4/3);
	~grl[3].set(\buf, ~jl_bufs[0].bufnum, \rate, -2/3);
	~grl[4].set(\buf, ~jl_bufs[5].bufnum, \rate, 8/3);
	~grl[5].set(\buf, ~jl_bufs[4].bufnum, \rate, 0.5);
	~grl[6].set(\buf, ~jl_bufs[4].bufnum, \rate, 1);
	~grl[7].set(\buf, ~jl_bufs[4].bufnum, \rate, 2);
};


/*
~grch1.value; // CM
~grch2.value; // am
~grch3.value; // em
~grch4.value; // dm
~grch5.value; // FM

~setgr.value; // 
*/

~chgrfn = [

	~grch1, // c
	~grch2, // am
	~grch3, // em
	~grch4, // dm
	~grch5, // f
	~grch2b, // am alt
	~grch1b, // c alt
];

~chgridx = 0;

~changegrains = { arg dir;
	~chgrfn[~chgridx].value;	
	~chgridx = (~chgridx + dir).wrap(0, ~chgrfn.size - 1);
};



~ch_key = OSCdef.newMatching('ch_key', { arg msg, time, addr, rec;
	var x, y, val;
	var t;

	x=msg[1];
	y=msg[2];
	val=msg[3];
	
	if(y == 5, {
		~chgrfn[x].value;
		~row.value(5, 1 << x)

	});
}, ~prefix++'/grid/key');




}.play;