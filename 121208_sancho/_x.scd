~basepath = "/home/emb/sc/cotccm/121209_caligari/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.local;

~npm = 4;

c = CfAudioContext.new(s, 2, { Routine {

	x.value("def.scd");
	x.value("analysis.scd");
	x.value("hzseq.scd");

	s.sync;

	~pmg = Group.new(c.og, \addBefore);
	~pmb = Bus.audio(s, 1);

	~pm = Array.fill(~npm, { arg i;
		Synth.new(\pm3, [
			\hz1, 110,
			\amp, 0.0,
			\amplag, 1.0,
			\pm12, 0,
			\pm23, 0,
			\pm31, 0,
			\pm12lag, 0.125,
			\pm23lag, 0.125,
			\pm31lag, 0.125,
			\out, ~pmb.index
		], ~pmg);
	});
	~pmout = Synth.new(\pan, [\in, ~pmb.index, \out, c.out_b.index], c.og, \addBefore);

	//==== reverb/echo:
	~vinb = Bus.audio(s, 1); // input bus
	~vb = Bus.audio(s, 1); // output bus
	~vinp = Synth.new(\patch, [\in, c.in_b.index, \out, ~vinb.index], c.ig, \addAfter);
	// reverb/echo group
	~vg = Group.new(c.xg);
	~vout = Synth.new(\pan, [\in, ~vb.index, \out, c.out_b.index], c.og, \addBefore);
	
	~vochr1 = (4/5)**(0.5);
	~vochr2 = (6/5)**(0.5);
	~vochdelr = 2.0**0.25;

	~lbuflen = 32.0;

	~voch1_buf = Buffer.alloc(s, s.sampleRate * ~lbuflen);
	s.sync;
	~voch1 = Synth.new(\echo_rlpf_shift_dist, [
		\in, ~vinb.index,
		\out, ~vb.index,
		\buf, ~voch1_buf.bufnum,
		\amp, 1.0,
		\shift, 1.0,
		\feedback, -3.dbamp,
		\distmix, 0.0,
		\delaytime, 2.0,
		\hzlag, 5.0,
		\rqlag, 5.0
	], ~vg );

	~voch2_buf = Buffer.alloc(s, s.sampleRate * ~lbuflen);
	s.sync;
	~voch2 = Synth.new(\echo_rlpf_shift_dist, [
		\in, ~vinb.index,
		\out, ~vb.index,
		\buf, ~voch2_buf.bufnum,
		\amp, 1.0,
		\shift, 1.0,
		\feedback, -3.dbamp,
		\distmix, 0.5,
		\delaytime, 4/3,
		\hzlag, 5.0,
		\rqlag, 5.0
	], ~vg );


	~voc_lbuf = Buffer.alloc(s, ~lbuflen  * s.sampleRate);
	~syn_lbuf = Buffer.alloc(s, ~lbuflen  * s.sampleRate);




	/*
		~voch1.set(\shift, 11/13);
		~voch1.set(\shiftmix, 0.8);
		~voch1.set(\feedback, -3.dbamp);
		~voch1.set(\delaytime, 2.0);
		~voch1.set(\amp, 1.0);
		~voch2.set(\amp, 1.0);
		~voch1.free;
	*/

	~voch1.set(\shift, ~vochr1);
	~voch2.set(\shift, ~vochr2);


	
	

		/*
	~voch_down = Synth.new(\bufdelay_fb, [
		\in, c.in_b.index,
		\out, ~vb.index,
		\buf, ~voch_down_buf.bufnum,
	], c.xg );
		*/

	//// mono
	//	~mono.free;
	/*	~mono = Synth.new(\patch, [
		\in, c.out_b.index,
		\out, c.out_b.index + 1
		], target:c.og, addAction:\addAfter);
	*/

}.play; });

