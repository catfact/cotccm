x = { |p| this.executeFile(~basepath++p); };

c = CfAudioContext.new(s, 2, { Routine {

	x.value("def.scd");
	
	~vlch_g = Group.after(c.ig);

	~vlchb = Bus.audio(s);

	~vlch1_buf = Buffer.alloc(s, s.sampleRate * 8.0);
	s.sync;

	~beat = 1.2;
	
	~vlch1 = Synth.new(\echo_rlpf_shift_dist, [
		\in, c.in_b.index + 1,
		\out, ~vlchb.index,
		\buf, ~vlch1_buf.bufnum,
		\amp, 1.0,
		\shift, 1.0,
		\feedback, -4.dbamp,
		\distmix, 0.0,
		\delaytime, ~beat * 0.5,
		\hzlag, 5.0,
		\rqlag, 5.0
	], ~vlch_g );

	~vlch2_buf = Buffer.alloc(s, s.sampleRate * 300.0);
	s.sync;
	
	~vlch2 = Synth.new(\echo_rlpf_shift_dist, [
		\in, ~vlchb.index,
		\out, ~vlchb.index,
		\buf, ~vlch2_buf.bufnum,
		\amp, 1.0,
		\shift, 1.0,
		\feedback, 0.dbamp,
		\distmix, 0.0,
		\delaytime, ~beat * 4 * 17,
		\hzlag, 5.0,
		\rqlag, 5.0
	], ~vlch1, \addAfter );

	~vlch_out = Synth.new(\patch, [\in, ~vlchb.index, \out, 0], ~vlch_g, \addAfter);
	
}.play;
	
});