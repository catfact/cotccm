
s = Server.local;

s.options.outputStreamsEnabled = "11";
s.options.inputStreamsEnabled = "11";

s.options.memSize = 131072;
 
//test
~vla_in = 1;
~ezv_in = 0;

~amp_out = 0;


s.waitForBoot { Routine {


///// i/o groups

	~in_g = Group.new(s);
	~out_g = Group.after(~in_g);
	
	~master_out_b = Bus.audio(s, 2);

////////// vla

	~vla_spec_buf = Buffer.alloc(s, 2048, 1);

	
	s.sync;

	~vla_proc_g = Group.after(~in_g);

	~vla_b = Bus.audio(s, 1);
	~vla_out_b = Bus.audio(s, 2);
	
	~vla_amp_b = Bus.control(s, 1);
	~vla_pitch_b = Bus.control(s, 2);   // pitch, haspitch
	~vla_centroid_b = Bus.control(s, 1);	
	~vla_flatness_b = Bus.control(s, 1);
	
	~vla_in_s = Synth.new(\adc_patch, [\in, ~vla_in, \out, ~vla_b.index], ~in_g, \addToTail);
	// both inputs now go to both input busse
//	~vla_in_2_s = Synth.new(\adc_patch, [\in, ~ezv_in, \out, ~vla_b.index], ~in_g, \addToTail);
	
	~vla_out_s = Synth.new(\patch_s, [\in, ~vla_out_b.index, \out, ~master_out_b.index], ~out_g, \addToTail);

	~vla_amp_s = Synth.new(\amp, [\in, ~vla_b.index, \out, ~vla_amp_b.index], ~in_g, \addAfter);
	~vla_pitch_s = Synth.new(\pitch, [\in, ~vla_b.index, \out, ~vla_pitch_b.index], ~in_g, \addAfter);
	~vla_centroid_s = Synth.new(\centroid, [\in, ~vla_b.index, \out, ~vla_centroid_b.index, \buf, ~vla_spec_buf.bufnum], ~in_g, \addAfter);
	~vla_flatness_s = Synth.new(\flatness, [\in, ~vla_b.index, \out, ~vla_flatness_b.index], ~in_g, \addAfter);

	
	////// mic
	
	~ezv_spec_buf = Buffer.alloc(s, 2048, 1);
	
	s.sync;
	
	~ezv_proc_g = Group.after(~in_g);

	~ezv_b = Bus.audio(s, 1);
	~ezv_out_b = Bus.audio(s, 2);
	
	~ezv_amp_b = Bus.control(s, 1);
	~ezv_pitch_b = Bus.control(s, 2);   // pitch, haspitch
	~ezv_centroid_b = Bus.control(s, 1);	
	~ezv_flatness_b = Bus.control(s, 1);
	
	~ezv_in_s = Synth.new(\adc_patch, [\in, ~ezv_in, \out, ~ezv_b.index], ~in_g, \addToTail);
	// both nputs now go to both input busses
//	~ezv_in_2_s = Synth.new(\adc_patch, [\in, ~vla_in, \out, ~ezv_b.index], ~in_g, \addToTail);
	
	~ezv_out_s = Synth.new(\patch_s, [\in, ~ezv_out_b.index, \out, ~master_out_b.index], ~out_g, \addToTail);
	
	~ezv_amp_s = Synth.new(\amp, [\in, ~ezv_b.index, \out, ~ezv_amp_b.index], ~in_g, \addAfter);
	~ezv_pitch_s = Synth.new(\pitch, [\in, ~ezv_b.index, \out, ~ezv_pitch_b.index], ~in_g, \addAfter);
	~ezv_centroid_s = Synth.new(\centroid, [\in, ~ezv_b.index, \out, ~ezv_centroid_b.index, \buf, ~ezv_spec_buf.bufnum], ~in_g, \addAfter);
	~ezv_flatness_s = Synth.new(\flatness, [\in, ~ezv_b.index, \out, ~ezv_flatness_b.index], ~in_g, \addAfter);
	
	
	////// vosc bufs	
	~numvbufs = 4;
	// each array has [freq ratio, amp, phase]
	~vbufdata = [
		[	[1.0],
			[1.0],
			[0.0]
		],
		[	[1.0, 2.0],
			[1.0, 0.5],
			[0.0, 0.1]
		],
		[	[1.0,  4/3,  3/2,  8/9,  2,   4/3,  3,   4],
			[0,    -6,   -4,   -8,   -3,  -6,   -8, -9].dbamp, // amp
			[0,    0,    0,    0,    0,   0,    0,  0]
		],
		[	[1.0,  5/4,  3/2,  13/8,  2,   13/8,  4,   7],
			[0,    -6,   -4,   -8,   -3,  -6,   -8, -9].dbamp, // amp
			[0,    0,    0,    0,    0.3,   0,    0,  0]
		]
	];
		
	
	~vbufs = Buffer.allocConsecutive(~numvbufs, s, 4096, 1, {
		arg buf, i;
		buf.sine3Msg(~vbufdata[i][0], ~vbufdata[i][1], ~vbufdata[i][2], normalize:false, asWavetable:true);
	});
	s.sync;
	
	////// output
	
	~vla_output_p = Synth.new(\patch, [\in, ~vla_b.index, \out, ~vla_out_b.index], ~out_g, \addToHead);
	~vla_output_p.set(\amp, -16.dbamp);
	
//	~master_out_p = Synth.new(\patch_pan, [\in, ~master_out_b.index, \out, ~amp_out], s, \addToTail);
	~master_out_p = Synth.new(\patch_s, [\in, ~master_out_b.index, \out, ~amp_out], s, \addToTail);
	~master_limit = Synth.new(\limit_insert_s, [\bus, ~master_out_b.index, \preamp, -24.dbamp, \limthresh, -6.dbamp], ~master_out_p, \addBefore);
	~master_limit.set(\preamp, 2.dbamp);
	~master_limit.set(\limthresh, -4.dbamp);
//	~master_limit.run(false);
	
}.play; }; 
