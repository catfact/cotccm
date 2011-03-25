s = Server.default;
s.boot;
s.waitForBoot { Routine {
		
	
	SynthDef.new(\mapOsc_dualRate_cubic, {
		arg buf, out=0, level=0.25,
			atk=2.0, rel=3.0, gate=0,
			hz_iterate=440, hz_latch=110,
			a=3.4,
			lpf_hz_mul=1.0, lpf_hz_add=0,
			doneAction=0,
			slewslope_mul= 0.5,
			sh_switch=1;
		var x, y, env, output, slewslope;
		var fast, latchpulse;	
		
		x = Dbufrd(buf);
		x = (a*x*x*x) + ((1.0-a)*x);
		y = Dbufwr(x, buf);
	
		fast = Duty.ar(1.0 / hz_iterate, 0, y);	
		
		latchpulse = LFPulse.ar(hz_latch);
		output = Latch.ar(fast, latchpulse);
	
		slewslope = hz_latch * slewslope_mul;
		output = Slew.ar(output, slewslope, slewslope);
		output = LPF.ar(output, hz_latch * lpf_hz_mul + lpf_hz_add);
	
		env = EnvGen.ar(Env.asr(atk, 1.0, rel), gate:gate, doneAction:doneAction);
		Out.ar(out, (env * output * level).dup);	
	}).send(s);
	
	s.sync;
	
	~nvoices = 4;
	~ival = 0.77;
	
	////////// buffers
	~maposc_buf = Array.fill(~nvoices, {
		Buffer.alloc(s, 1, 1);
	});
	
	0.02.wait;
	
	~maposc_buf.do({ arg buf; buf.set(0, ~ival); });

	////////// groups
	~maposc_g = Group.new(s);
	
	////////// busses
	~maposc_b = Bus.audio(s, 1);
	~maposc_out_s = SynthDef.new(\patch_split, {arg in,out,amp; Out.ar(out, (In.ar(in) * amp).dup); })
		.play(~maposc_g, [\in, ~maposc_b.index, \out, 0], \addAfter);
	~maposc_a_b = Array.fill(~nvoices, { Bus.control(s, 1) });
	//~maposc_oct_b = Array.fill(~nvoices, { Bus.control(s, 1) });
	~maposc_a_b.do({arg bus; bus.set(3.5) });
	//~maposc_oct_b.do({arg bus; bus.set(1.0) });
	
	////////// synths
	~maposc_s = Array.fill(~nvoices, {arg i;
		Synth.new(\mapOsc_dualRate_cubic, [
			\buf, ~maposc_buf[i].bufnum
			, \doneAction, 0
			, \a, ~maposc_a_b[i].asMap
			// , \oct, ~maposc_oct_b[i].asMap
		])
	});
	
	~maposc_tuning = [
		1.0,
		16/15,
		9/8,
		4/3 * 4/3 * 4/3 / 2,
		5/4,
		4/3,
		7/5,
		3/2,
		4/3 * 4/3 * 4/3 / 3 * 2,
		5/3,
		4/3 * 4/3,
		15/8
	];
	
	~maposc_base_octave = -2;
	~maposc_fundamental = 165.0;
	~maposc_offset = 0;	
	
	///// which pitch param are we editing
	~maposc_pitch_target =\hz_latch;
	//// which voice are we editing
	~maposc_select = 0;
	
	~maposc_on_r = NoteOnResponder({ |src,chan,note,vel|
		var hz, n, ratio;
		n = note + ~maposc_offset;
		ratio = ~maposc_tuning[n % 12];
		hz = ratio * ~maposc_fundamental * (2**((n / 12).floor + ~maposc_base_octave));
		postln("setting pitch : " ++ ~maposc_select ++ " , " ++ ~maposc_pitch_target ++ " , " ++ hz).postln;
		if (~maposc_pitch_target == \hz_iterate, {
			~maposc_s[~maposc_select].set(~maposc_pitch_target, hz * 4);
		}, {
			~maposc_s[~maposc_select].set(~maposc_pitch_target, hz);
		});

	}, nil, nil, nil, nil);
	
	~maposc_off_r = NoteOffResponder({ |src,chan,note,vel|
		// ("note off: " ++ [src,chan,note,vel]).postln;
		// nothin here for now...
	}, nil, nil, nil, nil);
	
	~maposc_gate_cc = CCResponder(
		{	arg src, chan, num, val;
			~maposc_s[num - 9].set(\gate, if(val>0, {1}, {0}));
		}, 
		nil, // any source
		nil, // any channel
		{ |cc| (cc > 8) && (cc < 13) } // cc number 9 through 13
	);
	
	
	
	//// need to keep client-side copy of the nonlinearity params - a drag, but oh well
	/// array for coarse tuning (MIDI)
	~maposc_a_coarse = Array.fill(~nvoices, {0});
	//// array for fine tuning (MIDI)
	~maposc_a_fine = Array.fill(~nvoices, {0});
	~maposc_calc_a = { arg i;
		var param;
		param =  ~maposc_a_coarse[i] / 128.0 + 3.0;
		param = param + ((~maposc_a_fine[i] - 64) / (127.0 * 127.0));
		param.postln;
		~maposc_a_b[i].set(param);
	};
	
	~maposc_select_cc = CCResponder(
		{	arg src, chan, num, val;
			var v = val / 127.0 * 0.9;
			("bottom row pads" ++ [num, v]).postln;
			if (val > 0, {
				
				~maposc_select = num-13;
				~maposc_buf[num-13].set(0, v);
				~maposc_pitch_target = \hz_iterate;
			}, {
				~maposc_pitch_target = \hz_latch;
			});
		}, 
		nil, // any source
		nil, // any channel
		{ |cc| (cc > 12) && (cc < 17) } // bottom pads, bank 1
	);

	
	~maposc_a_cc = CCResponder(
		{	arg src, chan, num, val;
			~maposc_a_coarse[num-1] = val;
			~maposc_calc_a.value(num-1);
		}, 
		nil, // any source
		nil, // any channel
		{ |cc| (cc > 0) && (cc < 5) } // cc number 1 through 4
	);
	
	
	~maposc_oct_cc = CCResponder(
		{	arg src, chan, num, val;
			~maposc_a_fine[num-5] = val;
			~maposc_calc_a.value(num-5);
		}, 
		nil, // any source
		nil, // any channel
		{ |cc| (cc > 4) && (cc < 9) } // cc number 5 through 8
	);
	
	


		
}.play; };

