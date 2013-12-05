/*
l~rhythm_crumblr.free;
~rhythm_crumblr.free;
~rhythm_grain1.free;
~rhythm_grain2.free;
~rhythm_grain3.free;
~rhythm_grain4.free;
*/

~rhythm_crumblr = Synth.new(\crumblr_over_s, [
	\in, ~rhythm_out_b.index,
	\out, ~rhythm_out_b.index,
	\thresh, 300,
	\shift, 1.0,
	\stretch, 2.0,
	\delaytime, 0.6
], ~rhythm_g, \addAfter);


~rhythm_crumblr2 = Synth.new(\crumblr_under_s, [
	\in, ~rhythm_out_b.index,
	\out, ~rhythm_out_b.index,
	\thresh, 100,
	\shift, 1.0,
	\stretch, 2.0,
	\delaytime, 1.8
], ~rhythm_g, \addAfter);


/*
~vla_del_out_s.set(\amp, 0.0);
~vla_del_out_s.set(\amp, -6.dbamp);
*/

~rhythm_crumblr.set(\amp, -24.dbamp);
~rhythm_crumblr.set(\shift, 1.0);


~rhythm_crumblr2.set(\amp, -16.dbamp);
~rhythm_crumblr2.set(\delaytime, 1.8);





~rhythm_crumblr.set(\thresh, 300);

~rhythm_out_p.set(\amplag, 60.0);
~rhythm_out_p.set(\amp, -24.0.dbamp);


~rhythm_grain1 = Synth.new(\bufgrain_pan, [\buf, ~norm_buf.bufnum, \amp, 0.0,
	\trigrate, 8.0 / 1.2,
	\posrate, 0.25 / 1.2,
	\dur, 0.25 / 1.2,
	\out, ~rhythm_out_b.index,
	\amp, 0
], ~rhythm_g);
~rhythm_grain1.set(\amplag, 60.0);
~rhythm_grain1.set(\amp, -24.dbamp);


~rhythm_grain2 = Synth.new(\bufgrain_pan, [\buf, ~norm_buf.bufnum, \amp, 0.0,
	\trigrate, 6.0 / 1.2,
	\posrate, 0.125 / 1.2,
	\dur, 0.25 / 1.2,
	\out, ~rhythm_out_b.index,
	\amp, 0
], ~rhythm_g);
~rhythm_grain2.set(\amplag, 60.0);
~rhythm_grain2.set(\amp, -24.dbamp);


~rhythm_grain3 = Synth.new(\bufgrain_pan, [\buf, ~norm_buf.bufnum, \amp, 0.0,
	\trigrate, 3.0 / 1.2,
	\posrate, (1/8) / 1.2,
	\dur, 0.25 / 1.2,
	\rate, 0.5,
	\out, ~rhythm_out_b.index,
	\amp, 0
], ~rhythm_g);
~rhythm_grain3.set(\amplag, 90.0);
~rhythm_grain3.set(\amp, -20.dbamp);


~rhythm_grain4 = Synth.new(\bufgrain_pan, [\buf, ~norm_buf.bufnum, \amp, 0.0,
	\trigrate, 4.0 / 1.2,
	\posrate, (1/12) / 1.2,
	\dur, 0.25 / 1.2,
	\rate, 0.5,
	\out, ~rhythm_out_b.index,
	\amp, 0
], ~rhythm_g);
~rhythm_grain4.set(\amplag, 90.0);
~rhythm_grain4.set(\amp, -20.dbamp);