Routine {

	~numvbufs = 6;
	// freq, amp
	~vbufdata = [
		[	[1.0],
			[1.0],
			[0.0]
		],
		[	[1.0, 2.0],
			[1.0, 0.5],
			[0.0, 0.1]
		],
		[	[1.0, 2.0, 3.0],
			[1.0, 0.5, 0.4],
			[0.0, 0.1, 0.6]
		],
		[	[1.0, 2.0, 3.0, 4.0],
			[1.0, 0.5, 0.5, 0.4],
			[0.0, 0.1, 0.3, 0.5]
		],
		[	[1.0,  4/3,  3/2,  8/9,  2,   4/3,  3,   4],
			[0,    -6,   -4,   -8,   -3,  -6,   -8, -9].dbamp,
			[0,    0,    0,    0,    0,   0,    0,  0]
		],
		[	[1.0,  5/4,  3/2,  13/8,  2,   13/8,  4,   7],
			[0,    -6,   -4,   -8,   -3,  -6,   -8, -9].dbamp,
			[0,    0,    0,    0,    0.3,   0,    0,  0]
		]
	];
		
	
	~vbufs = Buffer.allocConsecutive(~numvbufs, s, 4096, 1, {
		arg buf, i;
		buf.sine3Msg(~vbufdata[i][0], ~vbufdata[i][1], ~vbufdata[i][2], normalize:false, asWavetable:true);
	});
	
	0.5.wait;
	
	
	~voscs_score = Array.with(
		// attack, sustain, release, wait, hzdelay, detunehz
		[16, 16, 26, 36, 8.0, 0.125],
		[16, 16, 26, 36, 6.0, 0.125],
		[16, 16, 26, 36, 4.0, 0.125],
		[16, 16, 26, 36, 10.0, 0.125],
		[16, 16, 26, 36, 8.0, 0.125],
		[16, 16, 26, 36, 6.0, 0.125],
		[16, 16, 26, 36, 4.0, 0.125],
		[16, 16, 26, 36, 2.0, 0.125],
		[16, 16, 26, 36, 10.0, 0.125],
		[16, 16, 26, 36, 10.0, 0.125],
		[16, 16, 26, 36, 8.0, 0.125],
		//[16, 16, 26, 36, 6.0, 0.125],
		//[16, 16, 26, 36, 4.0, 0.125],
		//[16, 16, 26, 36, 10.0, 0.125],
		//[16, 16, 26, 36, 8.0, 0.125],
		[16, 16, 26, 36, 6.0, 0.125],
		[16, 16, 26, 36, 4.0, 0.125],
		[16, 16, 26, 36, 2.0, 0.125],
		[16, 16, 26, 36, 10.0, 0.125],
		[16, 16, 26, 36, 10.0, 0.125],
		[16, 16, 26, 36, 6.0, 0.125],
		[16, 16, 26, 40, 4.0, 0.125],
		[16, 16, 26, 42, 2.0, 0.125],
		[16, 16, 26, 48, 10.0, 0.125],
		[16.111111111111111, 16, 26, 52, 10.0, 0.125]
	);
	
	Task({ ~voscs_score.size.do({ arg i;
		var score;
		score = ~voscs_score[i];
		score.postln;
		~vla_amp_b.get({arg amp;
			postln("amp " + amp);
			~vla_pitch_b.get({ arg hz;
				var synth;
				postln("hz " + hz);
			
				synth = Synth.new(\vosc_rez_del_detune_env, [
					\voschz, hz * 0.5,
					\buf, ~vbufs[0].bufnum,
					\numbufs, ~numvbufs,
					\out, ~master_out_b.index,
					\bufphaselag, 30,
					\amp, 8.dbamp,
					\res, 0.7,
					\attack, score[0],
					\sustain, score[1],
					\release, score[2],
					\hzdelay, score[4],
					\detunehz, amp,
					\bufphase, (amp * 4.0).wrap(0.1, 0.7)
				], ~in_g, \addAfter);
				synth.map(\hz, ~vla_centroid_b);
				synth.set(\hz_mul, 0.5);
			});
		});
		AppClock.sched(score[3] - 10.0, {~fadeup.value; });
		score[3].wait;
	}) }).play;

	
}.play;