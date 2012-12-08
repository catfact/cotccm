
~pmg.set(\hz1lag, 0.25);
~pmg.set(\hz2lag, 0.125);
~pmg.set(\hz3lag, 0.0625);

~pmg.set(\out, c.out_b.index );

~pmg.set(\pm12lag, 1/32);
~pmg.set(\pm23lag, 1/64);
~pmg.set(\pm31lag, 1/24);

~pmg.set(\amp, 1.0);

~pmr = Routine { inf.do({ 
	arg i;

	~pm.do({ arg syn, j;
		syn.set(\pm12, ((((i*2+1)*(j+1)*12)%5)*0.4).wrap(0.0, 2.0));
		syn.set(\pm23, ((((i*3+1)*(j+2)*13)%6)*0.5).wrap(0.0, 2.0));
		syn.set(\pm31, ((((i*4+1)*(j+3)*14)%7)*0.6).wrap(0.0, 2.0));
	});
	(0.125 * (( i * 14) % 3)).wait;
}); }.play;

c.og.set(\amp, -12.dbamp);


/*
~pmr.stop;

*/

~voch_down.set(\amp, 0.25);
~voch_down_buf.plot;
~voch_down.free;

~inpatch = Synth.new(\pan, [\in, c.in_b.index, \out, ~vb.index], c.ig, \addAfter);
~inpatch.free;

~pm[0].set(\amp, 0.0);
~pm[0].get(\amp, { arg v; postln("amp: " ++ v); });

~voch1.set(\shift, 1.0);
~voch2.set(\shift, 1.0);



~rhzrw = 0.125;
~rhzr = Routine { inf.do {
	~pm.do({ arg syn, i;
		if(0.25.coin, { 
			syn.set(\hz1, ~hzlist.choose);
		});
		if(0.25.coin, { 
			syn.set(\hz2, ~hzlist.choose);
		});
		if(0.25.coin, { 
			syn.set(\hz3, ~hzlist.choose);
		});
	});
	~rhzrw.wait;
}}.play;

~rhzr.stop;