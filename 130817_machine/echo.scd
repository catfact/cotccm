Routine {
	SynthDef.new(\echo_buf_svf, {
		arg buf, in, out, time, amp=0.125, fb=0.0,
		amp_lag=0.01, time_lag=0.01,

		svf_mix=0.0,
		svf_hz=100, svf_res=0.0, svf_lo=1.0, svf_hi=0.0, svf_band=0.0,
		svf_hz_lag=1.0, svf_res_lag = 1.0;
		
		var echo, svf, local;

		amp = Lag.kr(amp, amp_lag);
		time = Lag.kr(time, time_lag);
		svf_hz = Lag.kr(svf_hz, svf_hz_lag);
		svf_res = Lag.kr(svf_res, svf_res_lag);

		local = LocalIn.ar(1);
		
		echo = BufDelayL.ar( buf, In.ar(in) + (fb*local), time);
		
		svf = SVF.ar (echo, svf_hz, svf_res, svf_lo, svf_band, svf_hi);
		echo = (echo * (1.0 - svf_mix)) + (svf * svf_mix);

		LocalOut.ar(echo);

		Out.ar(out, echo * amp);
	}).send(s);

	~echo_dur = 300.0;
	~echo_n = 8;

	~echo_buf = Array.fill(~echo_n, { Buffer.alloc(s, ~echo_dur * s.sampleRate, 1); });

	s.sync;

	~ig = Group.new(s);
	~xg = Group.new(~ig, \addAfter);
	~og = Group.new(~xg, \addAfter);

	~echo_in_b = Array.fill(~echo_n, { Bus.audio(s, 1); });
	~echo_out_b = Array.fill(~echo_n, { Bus.audio(s, 1); });
	~echo_adc = Array.fill(~echo_n, { |i|
		Synth.new(\adc_mix2, [\in, 0, \out, ~echo_in_b[i] ], ~ig); 
	}); 
	~echo_dac = Array.fill(~echo_n, { |i| 
		Synth.new(\patch_pan, [\in, ~echo_out_b[i], \out, 0 ], ~og);
	});

	~echo_patch =
	Array.fill(~echo_n, { |i|
		Array.fill(~echo_n, { |j|
			Synth.new(\patch_fb, [\in, ~echo_out_b[i], \out, ~echo_in_b[j], \amp, 0.0 ], ~ig );
		})
	});

	~echo_s = Array.fill(~echo_n, { |i|
		 Synth.new(\echo_buf_svf, [
			 \in, ~echo_in_b[i],
			 \out, ~echo_out_b[i],
			 \time, i,
			 \buf, ~echo_buf[i],
			 \fb, 0.5,
			 \time_lag, 5.0
		 ], ~xg, \addAfter);
	});

}.play;