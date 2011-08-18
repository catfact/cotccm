s = Server.local.waitForBoot { Routine {
	
	SynthDef.new(
	
	~vla_buf_n = 8;
	~vla_buf_l = 30.0;
	
	~vla_buf = Array.fill(~vla_buf_n, { Buffer.alloc(s, ~vla_buf_l * s.sampleRate, 1) });
	
	s.sync;
	
	