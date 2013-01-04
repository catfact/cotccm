~basepath = "/home/emb/sc/cotccm/130105_human_ark/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.local;


c = CfAudioContext.new(s, 2, { Routine {

	x.value("def.scd");

	s.sync;


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

	~voch1_buf = Buffer.alloc(s, s.sampleRate * 8.0);
	s.sync;
	~voch1 = Synth.new(\echo_rlpf_shift_dist, [
		\in, ~vinb.index,
		\out, ~vb.index,
		\buf, ~voch1_buf.bufnum,
		\amp, 0.5,
		\shift, 1.0,
		\feedback, -3.dbamp,
		\distmix, 0.0,
		\delaytime, 2.0,
		\hzlag, 5.0,
		\rqlag, 5.0
	], ~vg );

	~voch2_buf = Buffer.alloc(s, s.sampleRate * 8.0);
	s.sync;
	~voch2 = Synth.new(\echo_rlpf_shift_dist, [
		\in, ~vinb.index,
		\out, ~vb.index,
		\buf, ~voch2_buf.bufnum,
		\amp, 0.5,
		\shift, 1.0,
		\feedback, -3.dbamp,
		\distmix, 0.5,
		\delaytime, 4/3,
		\hzlag, 5.0,
		\rqlag, 5.0
	], ~vg );

	~voch1.set(\amp, 0.0);
	~voch2.set(\amp, 0.0);

	/*
		~voch1.set(\shift, 11/13);
		~voch1.set(\shiftmix, 0.8);
		~voch1.set(\feedback, -3.dbamp);
		~voch1.set(\delaytime, 2.0);
		~voch1.set(\amp, 1.0);
		~voch1.free;
	*/
	

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


	//// arduino
	x.value("arduino.scd");

	//// led test
	~led0_r = Routine{81.do{
		~ard_led_write.value(0, 1);
		0.01.wait;				~vla_del_in_s.set(\amp, -6.dbamp);				
		~ard_led_write.value(0, 0);
		0.05.wait;
	}}.play;
	
	~led1_r = Routine{81.do{
		~ard_led_write.value(1, 1);
		0.01.wait;
		~ard_led_write.value(1, 0);
		0.06.wait;
	}}.play;
			
	////

}.play; });

