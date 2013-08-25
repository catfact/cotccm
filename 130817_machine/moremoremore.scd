Routine {
	~gr3 = Array.newClear(4);
	~grg = Group.new(s);
	0.01.wait;
	Routine { 4.do({ arg i;
		~gr3[i] = BusGrainer.new(s, ~echo_buf[i], s, 0);
		6.125.wait;
		~gr3[i].grtrig_s.set(\hz, 6 + (i * 2));
		~gr3[i].grdur_b.set(4.0 / (6 + (i * 2)));
		~gr3[i].grpos_s.set(\hz, 1 / (i + 4) * 1.0 / ~echo_buf[i].duration);
		~gr3[i].gr_s.set(\amp, -24.dbamp);
		~gr3[i].gr_s.set(\rate, (i+2) / (i+1) );
		(8.0 + i).wait;
	}); }.play;

}.play;

~gr3[0].gr_s.set(\amp, -18.dbamp);
~gr3[1].gr_s.set(\amp, -18.dbamp);
~gr3[2].gr_s.set(\amp, -18.dbamp);
~gr3[3].gr_s.set(\amp, -16.dbamp);
