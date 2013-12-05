~vla_del_g = Group.new(~vla_del_out_s, \addBefore);

~vla_del_grain1 = Synth.new(\bufgrain_pan, [\buf, ~loop_buf.bufnum,
	\trigrate, 8.0 / 1.2,
	\posrate, 0.25 / 1.2,
	\dur, 0.25 / 1.2,
	\out, ~vla_del_out_b.index,
	\pan, 0,
	\amplag, 8.0,
	\amp, -15.dbamp
], ~vla_del_g);
~vla_del_grain1.set(\trigrate, 1.2);
//~vla_del_grain1.set(\amplag, 60.0);
//SystemClock.sched(1.2, {~vla_del_grain1.set(\amp, -12.dbamp); nil});

~vla_del_grain2 = Synth.new(\bufgrain_pan, [\buf, ~loop_buf.bufnum,		
	\trigrate, 6.0 / 1.2,
	\posrate, 0.125 / 1.2,
	\dur, 0.25 / 1.2,
	\out, ~vla_del_out_b.index,
	\pan, 0,
	\amplag, 16.0,
	\amp, -15.dbamp
], ~vla_del_g);
~vla_del_grain2.set(\trigrate, 2.0 / 1.2);
//SystemClock.sched(1.2, {~vla_del_grain2.set(\amp, -12.dbamp); nil});


~vla_del_grain3 = Synth.new(\bufgrain_pan, [\buf, ~loop_buf.bufnum,
	\trigrate, 3.0 / 1.2,
	\posrate, (1/8) / 1.2,
	\dur, 0.25 / 1.2,
	\rate, 1.0,
	\out, ~vla_del_out_b.index,
	\pan, -0.25,
	\amplag, 16.0,
	\amp, -12.dbamp
], ~vla_del_g);
~vla_del_grain3.set(\trigrate, 0.25 / 1.2);
//~vla_del_grain3.set(\amplag, 90.0);
//SystemClock.sched(1.2, {~vla_del_grain3.set(\amp, -24.dbamp); nil});


~vla_del_grain4 = Synth.new(\bufgrain_pan, [\buf, ~loop_buf.bufnum,
	\trigrate, 4.0 / 1.2,
	\posrate, (1/12) / 1.2,
	\dur, 0.25 / 1.2,
	\rate, 1.0,
	\out, ~vla_del_out_b.index,
	\pan, 0.25,
	\amplag, 17.0,
	\amp, -12.dbamp
], ~vla_del_g);
~vla_del_grain4.set(\trigrate, 2.0 / 1.2);
//~vla_del_grain4.set(\amplag, 120.0);
//SystemClock.sched(1.2, {~vla_del_grain4.set(\amp, -20.dbamp); nil});


~vla_del_grain5 = Synth.new(\bufgrain_pan, [\buf, ~loop_buf.bufnum,
	\trigrate, 2.0 / 1.2,
	\posrate, (1/6) / 1.2,
	\dur, 0.4 / 1.2,
	\rate, 2.0,
	\out, ~vla_del_out_b.index,
	\pan, -0.5,
	\amplag, 22.0,
	\amp, -12.dbamp
], ~vla_del_g);
//~vla_del_grain5.set(\amplag, 90.0);
//SystemClock.sched(1.2, {~vla_del_grain5.set(\amp, -12.dbamp); nil});


~vla_del_grain6 = Synth.new(\bufgrain_pan, [\buf, ~loop_buf.bufnum,	\trigrate, 4.0 / 1.2,
	\posrate, (1/4) / 1.2,
	\dur, 0.4 / 1.2,
	\rate, 2.0,
	\out, ~vla_del_out_b.index,
	\pan, 0.5,
	\amplag, 20.0,
	\amp, -12.dbamp
], ~vla_del_g);
