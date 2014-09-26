~basepath = Document.current.dir ++"/";
//~basepath = "/home/emb/sc/cotccm/130105_human_ark/";
x = { |p| this.executeFile(~basepath++p); };

x.value("defs.scd");
x.value("_defs.scd");
x.value("def.scd");

Routine {

	~vla_predel_buf = Buffer.alloc(s, 10 * s.sampleRate, 1);
	~vla_predel2_buf = Buffer.alloc(s, 10 * s.sampleRate, 1);
	s.sync;
	~vla_predel_in_b = Bus.audio(s, 1);
	~vla_predel_out_b = Bus.audio(s, 1);
	s.sync;
	~vla_predel_in_s = Synth.new(\in_hw, [\in, 1, \out, ~vla_predel_in_b.index]);
	/// longish
	~vla_predel_s = Synth.new(\bufdelay_fb, [
		\buf, ~vla_predel_buf.bufnum,
		\in, ~vla_predel_in_b.index,
		\delaytime, 1/3,
		\feedback, 0.2,
		\out, ~vla_predel_out_b.index;
	], ~vla_predel_in_s, \addAfter);

s.sync;

	// shortish
	~vla_predel2_s = Synth.new(\bufdelay_fb, [
		\buf, ~vla_predel2_buf.bufnum,
		\in, ~vla_predel_in_b.index,
		\delaytime, 10.6666666666,
		\feedback, 0.1,
		\amp, 0.5,
		\out, ~vla_predel_out_b.index;
	], ~vla_predel_in_s, \addAfter);

	// predelay to DAC
	~vla_predel_out_s = Synth.new(\patch_pan, [\in, ~vla_predel_out_b, \out, 0, \amp, -6.dbamp], 
		~vla_predel_s, \addAfter);
	~vla_predel2_s.set(\amp, 1.0);



}.play;