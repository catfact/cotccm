~basepath = Document.current.dir ++"/";
//~basepath = "/home/emb/sc/cotccm/130105_human_ark/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.default;
//s.options.memSize = 8192 * 4;
s.waitForBoot {

	//s.freeAll;

	Routine {
		// god dammit<
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

		{ x.value("metrovis.scd"); }.defer;

		/// pre-delay, short loop
		~vla_predel_buf = Buffer.alloc(s, 10 * s.sampleRate, 1);
		~vla_predel2_buf = Buffer.alloc(s, 10 * s.sampleRate, 1);
		s.sync;
		~vla_predel_in_b = Bus.audio(s, 1);
		~vla_predel_out_b = Bus.audio(s, 1);
		~vla_predel_in_s = Synth.new(\in_hw, [\in, 1, \out, ~vla_predel_in_b.index], ~god_vox, \addAfter);
		/// longish
		~vla_predel_s = Synth.new(\bufdelay_fb, [
			\buf, ~vla_predel_buf.bufnum,
			\in, ~vla_predel_in_b.index,
			\delaytime, 1.2 * 4.0,
			\feedback, 1.0,
			\out, ~vla_predel_out_b.index;
		], ~vla_predel_in_s, \addAfter);
		// shortish
		~vla_predel2_s = Synth.new(\bufdelay_fb, [
			\buf, ~vla_predel2_buf.bufnum,
			\in, ~vla_predel_in_b.index,
			\delaytime, 1.2 * 0.5,
			\feedback, 0.1,
			\amp, 0.5,
			\out, ~vla_predel_out_b.index;
		], ~vla_predel_in_s, \addAfter);
		// dry signal to predelay output bus
		~vla_dry = Synth.new(\adc_patch, [\in, 1, \out, ~vla_predel_out_b.index], ~vla_predel_out_s, \addBefore);
		// predelay to DAC
		~vla_predel_out_s = Synth.new(\patch_pan, [\in, ~vla_predel_out_b, \out, 0, \amp, -6.dbamp], 
			~vla_predel_s, \addAfter);
		~vla_predel2_s.set(\amp, 1.0);


		(1.2 * 64).wait;
		(1.2 * 32).wait;

		//---------- - -   ----             ----- vox

		~gvb = Bus.audio(s, 2);
		~god_vox = Synth.new(\god_vox, [\in, 0, \gate_thresh, -42.dbamp, \amp, -4.dbamp]);
		~god_vox.set(\amp, 2.dbamp);                                  
		~god_vox.set(\delaydc, 0.02);
		~god_vox.set(\delaytime, 1.2 * 0.25);
		~god_vox.set(\delaytime, \verb_mix, 0.7);
		~god_vox.set(\delaytime, \verb_damp, 0.2);
		~god_vox.set(\out, ~gvb.index);
		~god_vod_out_s = Synth.new(\patch_s, [\in, ~gvb.index, \out, 0], ~god_vox, \addAfter);

		//		~rec_norm_s = Synth.new(\norm_rec, [\input, 1, \buf, ~norm_buf.bufnum; ]);

		// input from predelay bus
		~rec_norm_s = Synth.new(\norm_rec_bus, [\input, ~vla_predel_out_b.index, \buf, ~norm_buf.bufnum; ],
			~vla_predel_out_s, \addAfter);

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
		~bufbass.set(\envdecay, 1.2 * 4);
		~bufbass.set(\amp, -14.dbamp);
		~bufbass.set(\pulsehz, (0.25 / 1.2));
		
		1.2.wait;
		~bufsh= Synth.new(\buf_ringz_dist_hpf_env, [
			\buf, ~norm_buf.bufnum,
			\pulsehz, 1.2 / 4, 
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
		~bufsh.set(\amp, -16.dbamp);
		~bufsh.set(\pulsehz, 1.2 / 4); 
		~bufsh.set(\envattack, 0.5 * 1.2);
		~bufsh.set(\envdecay, 2.0 * 1.2);
		~bufsh.set( \hpfhz, 100);
		~bufsh.set( \ringhz, 57.midicps * 2);
		~bufsh.set( \ringdecay, 0.01);

		/*
			~bufsh.free;
		*/

		//---------------      - -  -           -- -    metro
		(16.0 * 1.2).wait;
		
		x.value("gouge_beets.scd");

		// shorten predelay and lower feedback
		~vla_predel_s.set(\feedback, 0.4);
		(1.2 * 8).wait;
		~vla_predel_s.set(\delaytime, 1.2);

		// - ----------- - --------------- vla, long delay
		~loop_buf = Buffer.alloc(s, 100 * s.sampleRate, 1); 
		s.sync;
				

		/// long delay input bus
		~vla_del_in_b = Bus.audio(s, 1);	
		// ADC -> long delay
		~vla_del_in_hw_s = Synth.new(\in_hw, [\in, 1, \out, ~vla_del_in_b.index], ~god_vox, \addAfter);
		// predelay -> long delay
		~vla_del_in_predel_s = Synth.new(\patch, [
			\in, ~vla_predel_out_b.index, 
			\out, ~vla_del_in_b.index
		], ~vla_predel_s, \addAfter);

		// vox to delay... don't think we want this
		/* 
			~vox_del_in_s = Synth.new(\patch, [\in, ~gvb.index, \out, ~vla_del_in_b.index, \amp, 0.0], 
			~vla_del_in_s, \addAfter);
			~vox_del_in_s.set(\amp, 1.0);
		*/

		~vla_del_out_b = Bus.audio(s, 1);
		
		~vla_del_s = Synth.new(\bufdelay_fb, [
			\buf, ~loop_buf.bufnum,
			\in, ~vla_del_in_b.index,
			\delaytime, 1.2 * 4.0,
			\out, ~vla_del_out_b.index;
		], ~vla_del_in_predel_s, \addAfter);
		
		
		~vla_del_out_s = Synth.new(\patch_pan, [\in, ~vla_del_out_b, \out, 0, \amp, -6.dbamp], ~vla_del_s, \addAfter);
		~vla_del_s.set(\delaytime, 1.2 * 11.0 * 4.0);
		
		~vla_del_s.set(\feedback, 1.0);
		~vla_del_s.set(\inputamp, 1.0);

		//		~vla_del_out_s.set(\amp, 0.dbamp);
		/*
			~vla_del_s.free;
		*/
		
		
	}.play; // routine

x.value("lions_ctl.scd");
}; // /waitForBoot

