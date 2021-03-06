~basepath = Document.current.dir ++"/";
//~basepath = "/home/emb/sc/cotccm/130105_human_ark/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.default;
s.options.memSize = 8192 * 4;
s.waitForBoot {

	//s.freeAll;

	Routine {
		// god dammit
		x.value("lion_defs.scd");
		s.sync;
		x.value("defs.scd");
		s.sync;
		x.value("_defs.scd");
		s.sync;
		x.value("def.scd");

		s.sync;

		~norm_buf = Buffer.alloc(s, 16 * 1.2 * s.sampleRate, 1);
		s.sync;

		(1.2 * 8).wait;


		//---------- - -   ----             ----- vox

		~gvb = Bus.audio(s, 2);
		~god_vox = Synth.new(\god_vox, [\in, 0, \gate_thresh, -42.dbamp, \amp, 8.dbamp]);
		~god_vox.set(\amp, 4.dbamp);
		~god_vox.set(\delaydc, 0.1);
		~god_vox.set(\delaytime, 0.2);
		~god_vox.set(\out, ~gvb.index);
		~god_vod_out_s = Synth.new(\patch_s, [\in, ~gvb.index, \out, 0], ~god_vox, \addAfter);

		//~rec_norm_s = { RecordBuf.ar(Normalizer.ar(SoundIn.ar(1), 1.0), ~norm_buf.bufnum) }.play;
		~rec_norm_s = Synth.new(\norm_rec, [\input, 0, \buf, ~norm_buf.bufnum; ]);
		SystemClock.sched(~norm_buf.duration + 0.01, { ~rec_norm_s.free; nil });

		/*
			~norm_buf.plot;
		*/

		~rhythm_g = Group.new(s);
		~rhythm_out_b = Bus.audio(s, 2);
		~rhythm_out_p = Synth.new(\patch_s, [\in, ~rhythm_out_b.index, \out, 0, \amp,  -12.dbamp], ~rhythm_g, \addAfter);

		~bufbass = Synth.new(\buf_ringz_lpf_env, [
			\buf, ~norm_buf.bufnum,
			\pulsehz, (0.5 / 1.2),
			\lpfhz, 57.midicps,
			\ringhz, 45.midicps,
			\rate, 0.5,
			\ringdecay, 0.007,
			\out, ~rhythm_out_b.index,
			\amp, -18.dbamp,
			\envattack, 0.6 * 0.126,
			\envdecay, 1.2,
		], ~rhythm_g);
		~bufbass.set(\amp, -16.dbamp);
		/*
		~bufbass.set(\amp, -15.dbamp);
		*/
		~bufsh= Synth.new(\buf_ringz_dist_hpf_env, [
			\buf, ~norm_buf.bufnum,
			\pulsehz, 1.2 / 44.0, 
			\hpfhz, 57.midicps,
			\ringhz, 69.midicps,
			\rate, 1.0,
			\startpos, 4.0,
			\ringdecay, 0.01,
			\envattack, 2.0 * 1.2,
			\envdecay, 2.0 * 1.2,
			\out, ~rhythm_out_b.index,
			\amp, -30.dbamp
		], ~rhythm_g);
		~bufsh.set(\amp, -44.dbamp);

		/*
			~bufsh.free;

		*/

		//---------------      - -  -           -- -    metro
		//		SystemClock.sched(24.0 * 1.2, {
		(16.0 * 1.2).wait;
		
		x.value("gouge_beets.scd");

		/*
		~metro = Synth.new(\metro, [
			\impulsehz, 1.0 / 1.2, //1.15,
			\ringhz, (55.midicps / 4.0),
			\ringtime, 6.0,
			\out, ~rhythm_out_b.index,
			\lpfhz, 300,
			\amp, -8.dbamp
		], ~rhythm_g);
		~metro.set(\amp, -4.dbamp);
		*/

		// - ----------- - --------------- vla
		~loop_buf = Buffer.alloc(s, 100 * s.sampleRate, 1); 
		s.sync;
				
		~vla_del_in_b = Bus.audio(s, 1);	
		~vla_del_in_s = Synth.new(\in_hw, [\in, 1, \out, ~vla_del_in_b.index], ~god_vox, \addAfter);
		//	~vla_del_in_s = Synth.new(\in_hw, [\in, 0, \out, ~vla_del_in_b.index], s);
		~vox_del_in_s = Synth.new(\patch, [\in, ~gvb.index, \out, ~vla_del_in_b.index, \amp, 0.0], ~vla_del_in_s, \addAfter);

		~vla_del_out_b = Bus.audio(s, 1);

		//	~bass_del_in_s = Synth.new(\in_hw, [\in, 1, \out, ~vla_del_in_b.index], ~vla_del_in_s, \addAfter);
		
		~vla_del = Synth.new(\bufdelay_fb, [
			\buf, ~loop_buf.bufnum,
			\in, ~vla_del_in_b.index,
			\delaytime, 1.2 * 4.0,
			\out, ~vla_del_out_b.index;
		], ~vox_del_in_s, \addAfter);
		
		
		~vla_del_out_s = Synth.new(\patch_pan, [\in, ~vla_del_out_b, \out, 0, \amp, -6.dbamp], ~vla_del, \addAfter);
		~vla_playthrough = Synth.new(\adc_patch, [\in, 1, \out, ~vla_del_out_b.index], ~vla_del_out_s, \addBefore);


		~vla_del.set(\delaytime, 1.2 * 11.0 * 4.0);
		
		~vla_del.set(\feedback, 1.0);
		~vla_del.set(\inputamp, 1.0);
		~vla_del_out_s.set(\amp, 0.dbamp);
		/*
			~vla_del.free;
		*/
		
		
	}.play; // routine

x.value("lions_ctl.scd");
}; // /waitForBoot

