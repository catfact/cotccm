Routine {
~vla_del_rez_buf = Buffer.alloc(s, 60.0 * s.sampleRate, 1);
~vla_del_rez_buf2 = Buffer.alloc(s, 60.0 * s.sampleRate, 1);

s.sync;

~vla_del_svf_s = Synth.new(\bufd_svf, [
	\in, ~vla_b.index,
	\buf, ~vla_del_rez_buf.bufnum,
	\res, 0.29,
	\hzbus, ~vla_centroid_b.index,
	\hzdel, 2.0,
	\hzmul, 0.25,
	\out, ~vla_out_b.index,
	\amp, -14.dbamp,
	\fb, 0.3,
	
], ~vla_proc_g, \addToTail);
~vla_del_svf_s.set(\res, 0.58);
~vla_del_svf_s.set(\high, 0.0);
~vla_del_svf_s.set(\fb, -24.dbamp);
~vla_del_svf_s.set(\amp, -12.dbamp);
~vla_del_svf_s.set(\delaytime, 36.014);


~vla_del_svf_s2 = Synth.new(\bufd_svf, [
	\in, ~vla_b.index,
	\buf, ~vla_del_rez_buf2.bufnum,
	\res, 0.39,
	\hzbus, ~vla_centroid_b.index,
	\hzdel, 8.0,
	\hzmul, 0.25,
	\out, ~vla_out_b.index,
	\amp, -14.dbamp,
	\fb, 0.3,
	
], ~vla_proc_g, \addToTail);
~vla_del_svf_s2.set(\res, 0.32);
~vla_del_svf_s2.set(\high, 0.0);
~vla_del_svf_s2.set(\fb, -8.dbamp);
~vla_del_svf_s2.set(\amp, -17.dbamp);
~vla_del_svf_s2.set(\delaytime, 6.014);




~vla_grains_g = Group.after(~in_g);

~vla_grains = Array.fill(8, { 
	arg i;
	var synth;
	synth = Synth.new(\bufgrain, [
		\buf, ~vla_del_rez_buf.bufnum,
		\dur, 1.0 + (i * 0.25),
		\trigrate, 10.0 - i,
		\posrate, 0.7 - (i * 0.05),
		\rate, ((i %2) * 2 - 1) * (2 ** ((i / 4).floor * -1)),
		\amplag, 200.0,
		\amp, 0.0,
		\out, ~vla_out_b.index
		], ~vla_grains_g);
	synth.set(\amp, -16.dbamp);
	synth
});

~vla_grains_g.set(\amp, -8.dbamp);

}.play;