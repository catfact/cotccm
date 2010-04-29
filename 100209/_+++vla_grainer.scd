/*
~vla_del_grain1.free;
~vla_del_grain2.free;
~vla_del_grain3.free;
~vla_del_grain4.free;
~vla_del_grain5.free;
~vla_del_grain6.free;
~vla_del_g.free;
*/

~vla_del_g = Group.new(~vla_del_out_s, \addBefore);

~vla_del_grain1 = Synth.new(\bufgrain_pan, [
	\buf, ~loop_buf.bufnum,
	\trigrate, 8.0 / 1.2,
	\posrate, 0.25 / 1.2,
	\dur, 0.25 / 1.2,
	\out, ~vla_del_out_b.index,
	\pan, -0.8,
	\amplag, 60.0,
	\amp, -6.dbamp
], ~vla_del_g);
//~vla_del_grain1.set(\amplag, 60.0);
//SystemClock.sched(1.2, {~vla_del_grain1.set(\amp, -6.dbamp); nil});

~vla_del_grain2 = Synth.new(\bufgrain_pan, [
	\buf, ~loop_buf.bufnum,
	\trigrate, 6.0 / 1.2,
	\posrate, 0.125 / 1.2,
	\dur, 0.25 / 1.2,
	\out, ~vla_del_out_b.index,
	\pan, -0.8,
	\amplag, 60.0,
	\amp, -6.dbamp
], ~vla_del_g);
//~vla_del_grain2.set(\amplag, 60.0);
//SystemClock.sched(1.2, {~vla_del_grain2.set(\amp, -6.dbamp); nil});


~vla_del_grain3 = Synth.new(\bufgrain_pan, [
	\buf, ~loop_buf.bufnum,
	\trigrate, 3.0 / 1.2,
	\posrate, (1/8) / 1.2,
	\dur, 0.25 / 1.2,
	\rate, 1.0,
	\out, ~vla_del_out_b.index,
	\pan, -0.25,
	\amplag, 60.0,
	\amp, -6.dbamp
], ~vla_del_g);
//~vla_del_grain3.set(\amplag, 90.0);
//SystemClock.sched(1.2, {~vla_del_grain3.set(\amp, -24.dbamp); nil});


~vla_del_grain4 = Synth.new(\bufgrain_pan, [
	\buf, ~loop_buf.bufnum,
	\trigrate, 4.0 / 1.2,
	\posrate, (1/12) / 1.2,
	\dur, 0.25 / 1.2,
	\rate, 1.0,
	\out, ~vla_del_out_b.index,
	\pan, 0.25,
	\amplag, 60.0,
	\amp, -6.dbamp
], ~vla_del_g);
//~vla_del_grain4.set(\amplag, 120.0);
//SystemClock.sched(1.2, {~vla_del_grain4.set(\amp, -20.dbamp); nil});


~vla_del_grain5 = Synth.new(\bufgrain_pan, [
	\buf, ~loop_buf.bufnum,
	\trigrate, 8.0 / 1.2,
	\posrate, (1/6) / 1.2,
	\dur, 0.4 / 1.2,
	\rate, 2.0,
	\out, ~vla_del_out_b.index,
	\pan, -0.5,
	\amplag, 60.0,
	\amp, -6.dbamp
], ~vla_del_g);
//~vla_del_grain5.set(\amplag, 90.0);
//SystemClock.sched(1.2, {~vla_del_grain5.set(\amp, -6.dbamp); nil});


~vla_del_grain6 = Synth.new(\bufgrain_pan, [\buf, ~loop_buf.bufnum, \amp, 0.0,
	\trigrate, 4.0 / 1.2,
	\posrate, (1/4) / 1.2,
	\dur, 0.4 / 1.2,
	\rate, 2.0,
	\out, ~vla_del_out_b.index,
	\pan, 0.5,
	\amplag, 60.0,
	\amp, -6.dbamp
], ~vla_del_g);

//~vla_del_grain6.set(\amplag, 90.0);
//SystemClock.sched(1.2, {~vla_del_grain6.set(\amp, -6.dbamp); nil});