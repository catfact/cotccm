~vhz_b = Bus.control(s, 2);
~v_b = Bus.audio(s, 1);
~v_p = Synth.new(\adc_patch, [\in, 0, \out, ~v_b.index]);

/*
~vgrains_buf = Buffer.alloc(s, s.sampleRate * 16.0 * 1.2, 1);
*/
~vgrains_buf = Buffer.alloc(s, s.sampleRate * 16.0 * 1.2, 1, {
SystemClock.sched(0.1, {

~vhz_s = Synth.new(\pitch, [\in, ~v_b.index, \out, ~vhz_b.index], ~v_p, \addAfter);

//~god_vox.set(\amp, 8.dbamp);
~god_vox.set(\amp, -7.dbamp);
~god_vox.set(\delaytime, 1.2 * 0.5);

~vgrain_rec = Synth.new(\rec, [
	\in, ~v_b.index, 
	\buf, ~vgrains_buf.bufnum, 
	\prelevel, 1.0,
	\loop, 1
], ~vp, \addAfter);

/*
~vgrains_buf.plot;
*/

~vhz = nil;
~vhz_ratio = 1.0;

~vgrainpan = 0.0;


~setvhz = { ~vhz_b.getn(2, {
	arg arr;
	var hz, hashz, posrate;
	hz = arr[0]; 
	hashz = arr[1];
	("hashsz " ++ hashz).postln;
	("hz " ++ hz).postln;
	if (~vhz.notNil,{	
		if (hashz > 0, {
			~vhz_ratio = hz / ~vhz;
			~vhz = hz;
		}, {
			~vhz_ratio = 1.0;
		});
		~vgrainpan = (~vgrainpan + 0.2 + 0.2.rand).wrap(-1.0, 1.0);
		
		posrate = ((#[1.0, 2.0, 3.04, 4.0, 5.0].choose / #[1.0, 2.0, 1.5, 0.2].choose) / 1.2 * 2.0 * ~vhz_ratio).wrap(1.0, 10.0);
		
		Synth.new(\bufgrain_pan_1shot, [\buf, ~vgrains_buf.bufnum,
			\attack, 8.0 * 1.2,
			\sustain, 16.0 * 1.2,
			\release, 16.0 * 1.2,
			\trigrate, 16.0 / 1.2,
			\posrate, 0.25,
		     \pos_offset, 1.0.rand,
			\dur, 4.0 / posrate,
			\rate, ~vhz_ratio,
			\out, 0,
			\amp, -12.dbamp,
			\pan, ~vgrainpan;
		]); 
	}, {
		~vhz = hz;
	});
}) };

/*
~setvhz.value;
~vgrains_buf.zero
~vgrain_rec.set(\run, false);
~vgrain_rec.set(\run, true);
*/

// .......... . ................... --------     schedule ending

	SystemClock.sched(96 * 1.2, {
		~vla_del.set(\amplag, 32.0 * 1.2);
		~vla_del.set(\amp, 0.0);
		
		~rhythm_out_s.set(\amplag, 64.0 * 1.2);
		~rhythm_out_s.set(\amp, 0.0);
		
		~vla_del_out_s.set(\amplag, 32.0 * 1.2);
		~vla_del_out_s.set(\amp, 0.0);
		
		nil 
	});
	
	//// kill everything but the god vox	
	SystemClock.sched((96 + 64) * 1.2, {
		~vla_del_g.free;
		~rhythm_g.free;
//		~god_vox.free;
		nil 
	});
	
	
nil }); // /sched
}); // /alloc

/*
~vgrain_rec.free;
~vgrains_buf.free;
*/