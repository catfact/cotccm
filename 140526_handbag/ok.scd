// =====================================================================
// SuperCollider Workspace
// =====================================================================

a.set(\level, 0);
b.set(\level, 0);
c.set(\level, 0);
d.set(\level, 0);
d.set(\level, 0);
e.set(\level, 0);



~buf0.plot;

~bzg = Group.new(s);

~bzg.free;

~bz = Array.fill(6, {
	arg i;
	Synth.new(\buf_ringz_lpf_env, [
		\buf, ~buf0.bufnum,
		\pulsehz, 0.0625 * 0.25 * ((i*13) % 6 + 1),
		\ringhz, 110 * (i + 4) / (i+2),
		\rate, (i + 2) / (i+6),
		\lpfhz, 110 * (i + 7) / (i+5) * 4.0,
		\ringmix, 0.2,
		\ringdecay, 0.15,
		\startpos, 2.0 * i,
		\envattack, if((i%2) > 0, { i }, {1/i});
		\envdecay, if((i%2) == 0, { i }, {1/i});
	], ~bzg);
});


~bz.do({ arg syn, i;
	syn.set(\lpf, 220 * (i + 2));
	syn.set(\ringmix, 0.5.rand + 0.2);
});

~bzr = Routine { var off, hz;
	inf.do({ arg i;
		var w = 4.0;

		~bz.set(\pulsehz, (1 / ((i * 13) % 3)) + 0.25);
		
		w.wait;
	});
};
~bzr.play;
~bzr.stop;
~bz.free;

~buf0.zero;