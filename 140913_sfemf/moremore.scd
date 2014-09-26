Routine {
	~gr2 = Array.newClear(4);
	~grg = Group.new(s);
	0.01.wait;
	Routine { 4.do({ arg i;
		~gr2[i] = BusGrainer.new(s, ~bbuf, ~grg, 0);
		0.125.wait;
//		~gr2[i].grtrig_s.set(\hz, 6 + (i * 2));
		~gr2[i].grdur_b.set(4.0 / (6 + (i * 2)));
		~gr2[i].grpos_s.set(\hz, 1 / (i + 4) * 1.0 / ~bbuf.duration);
		~gr2[i].gr_s.set(\amp, -36.dbamp);
		(8.0 + i).wait;
	}); }.play;

64.wait;



~gr2.do({ arg gr, i; var rate;
	rate = ~analist[i].cent / ~analist[i].pitch;
	while( {rate > 2.0}, {rate = rate / 2; });
	rate.postln;
	gr.grrate_b.set(rate );
});

/*
~gr2.do({ arg gr, i; var rate; rate = ~analist[i].cent / ~analist[i].pitch;  while( {rate > 2.0}, {rate = rate / 2; }); rate.postln; gr.grrate_b.set(rate ); });

64.wait;
	~gr2

~gr.do({ arg gr, i; var rate = i + 1; while( {rate > 2.0}, {rate = rate / 2; }); gr.grrate_b.set(rate); });
*/

}.play;