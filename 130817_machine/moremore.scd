Routine {
	~gr2 = Array.newClear(4);
	~grg = Group.new(s);
	0.01.wait;
	Routine { 4.do({ arg i;
		~gr2[i] = BusGrainer.new(s, ~savebuf_7, s, 0);
		6.125.wait;
		~gr2[i].grtrig_s.set(\hz, 6 + (i * 2));
		~gr2[i].grdur_b.set(4.0 / (6 + (i * 2)));
		~gr2[i].grpos_s.set(\hz, 1 / (i + 4) * 1.0 / ~savebuf_7.duration);
		~gr2[i].gr_s.set(\amp, -36.dbamp);
		(8.0 + i).wait;
	}); }.play;

64.wait;


~gr2[0].grrate_b.set(\rate, 4/3);
~gr2[1].grrate_b.set(\rate, 5/4);


~gr2.do({ arg gr, i; var rate;
	//	rate = ~analist[i].cent / ~analist[i].pitch; 
	//	while( {rate > 2.0}, {rate = rate / 2; }); 
	rate = (i+1) / (i + 2);
	rate.postln; 
	gr.grrate_b.set(rate );
});

/*
~gr2.do({ arg gr, i; var rate; rate = ~analist[i].cent / ~analist[i].pitch;  while( {rate > 2.0}, {rate = rate / 2; }); rate.postln; gr.grrate_b.set(rate ); });

64.wait;

~gr.do({ arg gr, i; var rate = i + 1; while( {rate > 2.0}, {rate = rate / 2; }); gr.grrate_b.set(rate); });
*/

}.play;



	Routine { 4.do({ arg i;
		//		~gr2[i] = BusGrainer.new(s, ~savebuf_7, s, 0);
				6.125.wait;
		//		~gr2[i].grtrig_s.set(\hz, 6 + (i * 2));
		//		~gr2[i].grdur_b.set(4.0 / (6 + (i * 2)));
		//		~gr2[i].grpos_s.set(\hz, 1 / (i + 4) * 1.0 / ~savebuf_7.duration);
		~gr2[i].gr_s.set(\amp, -25.dbamp);
		(8.0 + i).wait;
	}); }.play;


~gr2[0].gr_s.set(\amp, -24.dbamp);
~gr2[1].gr_s.set(\amp, -25.dbamp);
~gr2[2].gr_s.set(\amp, -26.dbamp);
~gr2[3].gr_s.set(\amp, -20.dbamp);




~gr2[0].gr_s.set(\buf, ~echo_buf[0].bufnum);
~gr2[1].gr_s.set(\buf, ~echo_buf[1].bufnum);
~gr2[2].gr_s.set(\buf, ~echo_buf[2].bufnum);
~gr2[3].gr_s.set(\buf, ~echo_buf[3].bufnum);

~gr2[1].gr_s.set(\amp, -.dbamp);
~gr2[2].gr_s.set(\amp, -12.dbamp);
~gr2[3].gr_s.set(\amp, -12.dbamp);