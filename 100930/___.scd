

~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.local.waitForBoot { Routine {
	
	/* tune and test
	 x = {SinOsc.ar(440)}.play;
	 x.run(false)
	 */
	 
	// groups
	~del_g = Group.new(s);
	~samp_g = Group.after(~del_g);
	~out_g = Group.after(~samp_g);
	
	// viola delay output bus
	~vla_del_b = Bus.audio(s, 1);
	
	// viola delay synths
	~vla_del4 = CfDelay4.new(s, ~del_g);
	// viola is adc channel 0
	~vla_del4.del_in_s.set(\in, 0);
	
	// sum them all to the same bus
	~vla_del4.del_s.do({arg syn;
		syn.set(\out, ~vla_del_b.index);
	});
	
	
	// output that bus to dac channel 0
	~vla_del_out_s = Synth.new(\patch, [\in, ~vla_del_b.index, \out, 0], ~out_g);
	
	// allocate sampling buffer, approximate length of "war"
	~vla_samp_len = 100.0;
	~vla_samp_buf = Buffer.alloc(s, s.sampleRate * ~vla_samp_len, 1);
	
	0.1.wait;
	
	// initial delay state (mild echo)
	~vla_del4.del_s[0].set(\delaytime, 0.48);
	~vla_del4.del_s[1].set(\delaytime, 0.24);
	~vla_del4.del_s[2].set(\delaytime, 0.16);
	~vla_del4.del_s[3].set(\delaytime, 0.32);
	~vla_del4.del_s[0].set(\fb, 0.3);
	~vla_del4.del_s[1].set(\fb, 0.2);
	~vla_del4.del_s[2].set(\fb, 0.1);
	~vla_del4.del_s[3].set(\fb, 0.1);
	~vla_del4.del_s[0].set(\amp, 0.5);
	~vla_del4.del_s[1].set(\amp, 0.3);
	~vla_del4.del_s[2].set(\amp, 0.1);
	~vla_del4.del_s[3].set(\amp, 0.05);
	
	
	/////// similar echo stuff for vox
	
	// vox delay output bus
	~vox_del_b = Bus.audio(s, 1);
	
	// vox delay synths
	~vox_del4 = CfDelay4.new(s, ~del_g);
	// vox is adc channel 1
	~vox_del4.del_in_s.set(\in, 1);
	
	// sum them all to the same bus
	~vox_del4.del_s.do({arg syn;
		syn.set(\out, ~vox_del_b.index);
	});
	
	// output that bus to dac channel 0
	~vox_del_out_s = Synth.new(\patch, [\in, ~vox_del_b.index, \out, 0], ~out_g);
	
	// initial delay state (mild echo)
	~vox_del4.del_s[0].set(\delaytime, 0.48);
	~vox_del4.del_s[1].set(\delaytime, 0.24);
	~vox_del4.del_s[2].set(\delaytime, 0.16);
	~vox_del4.del_s[3].set(\delaytime, 0.32);
	~vox_del4.del_s[0].set(\fb, 0.3);
	~vox_del4.del_s[1].set(\fb, 0.2);
	~vox_del4.del_s[2].set(\fb, 0.1);
	~vox_del4.del_s[3].set(\fb, 0.1);
	~vox_del4.del_s[0].set(\amp, 0.5);
	~vox_del4.del_s[1].set(\amp, 0.3);
	~vox_del4.del_s[2].set(\amp, 0.1);
	~vox_del4.del_s[3].set(\amp, 0.05);
	
	
	
	SynthDef.new(\rec, {arg in=0, buf=0; RecordBuf.ar(In.ar(in), buf, loop:0, doneAction:2);  }).load(s);
	
	// beginning of "war"
	~war1_func = {
		~vla_del4.del_s[0].set(\delaytime, 2.0);
		~vla_del4.del_s[1].set(\delaytime, 2.7);
		~vla_del4.del_s[2].set(\delaytime, 0.9);
		~vla_del4.del_s[3].set(\delaytime, 1.4);
		~vla_del4.del_s[0].set(\fb, 0.5);
		~vla_del4.del_s[1].set(\fb, 0.5);
		~vla_del4.del_s[2].set(\fb, 0.5);
		~vla_del4.del_s[3].set(\fb, 0.5);
		~vla_del4.del_s[0].set(\amp, 0.5);
		~vla_del4.del_s[1].set(\amp, 0.5);
		~vla_del4.del_s[2].set(\amp, 0.5);
		~vla_del4.del_s[3].set(\amp, 0.5);
		// start sampling the vla delay output bus
//		~vla_samp_s = Synth.new(\rec, [\in, ~vla_del_b.index, \buf, ~vla_samp_buf.bufnum], ~samp_g);
		// somethings fucked... ? try sampling the hardware output perhaps.. bizarre
		~vla_samp_s = Synth.new(\rec, [\in, 0, \buf, ~vla_samp_buf.bufnum], s, \addToTail);
		
		// wait to start next section
		postln("WAR1");
		~switch_func = { arg val; if (val > 0, {~war2_func.value; }, {} ); };
	};
	
	SynthDef.new(\filtergrain, {
		arg buf, out, amp=2.0, hz, rez, grainrate = 8.0, graindur = 0.5, jumprate = (1/30.0);
		var pos, bufdur, output;
		bufdur = BufDur.kr(buf);
		pos = LFTri.kr(0.5 / bufdur) * bufdur;
		pos = (pos + Latch.kr(LFTri.kr(0.5 / bufdur) * bufdur, Impulse.kr(jumprate))).wrap(0, bufdur);
		output = TGrains.ar(2, Impulse.kr(grainrate), buf, 1.0, pos, graindur);
		output = RLPF.ar(output, hz, rez);
		Out.ar(out, Mix.new(output) * amp);
	}).load(s);
	
	// ending of "war"
	~war2_func = {
		Routine {
			~vla_del4.del_s[0].set(\amplag, 18.0);
			~vla_del4.del_s[1].set(\amplag, 18.0);
			~vla_del4.del_s[2].set(\amplag, 18.0);
			~vla_del4.del_s[3].set(\amplag, 18.0);
			~vla_del4.del_s[0].set(\amp, 0.0);
			~vla_del4.del_s[1].set(\amp, 0.0);
			~vla_del4.del_s[2].set(\amp, 0.0);
			~vla_del4.del_s[3].set(\amp, 0.0);
			
			18.0.wait;
			
			~vla_del4.del_s[0].set(\amp, 1.0);
			~vla_del4.del_s[1].set(\amp, 1.0);
			~vla_del4.del_s[2].set(\amp, 0.5);
			
		// very long delays, no feedback
			~vla_del4.del_s[0].set(\delaytime, 120.0);
			~vla_del4.del_s[1].set(\delaytime, 60.0);
			~vla_del4.del_s[2].set(\delaytime, 30.0);
			~vla_del4.del_s[2].set(\amp, 0.6);
			~vla_del4.del_s[0].set(\fb, 0.0);
			~vla_del4.del_s[1].set(\fb, 0.0);
		}.play;	
		// stop vla delay sampling
		// frees self
//		~vla_samp_s.free;
		// start playback
		~vla_grain_s = Synth.new(\filtergrain, [\out, 0, \buf, ~vla_samp_buf.bufnum, \hz, 72.midicps, \rez, 0.2], ~samp_g);
		// start playback
		~vla_grain2_s = Synth.new(\filtergrain, [\out, 0, \buf, ~vla_samp_buf.bufnum, \hz, 72.midicps, \rez, 0.2, \jumprate, 1/15.0], ~samp_g);

		
		postln("WAR2");
		// wait to start next section
		~switch_func = { arg val; if (val > 0, {~last_func.value; }, {} ); };
	};
	
	// last section
	~last_func = {
		
		postln("LAST");
		~startflag = false;
		
		~pitch_b = Bus.control(s, 2);
		~pitch_s = SynthDef.new(\pitch, {arg in=0, out;
			Out.kr(out, Pitch.kr(SoundIn.ar(in)));
		}).play(s, [\out, ~pitch_b.index]);
		
		~switch_func = { arg val;
			if (val > 0, {
				postln("hid tappin");
				~hidtapper.tap;
				~timelist	[~time_i] = ~hidtapper.time.min(32.0);
				~time_i = ~time_i + 1;
				if(~time_i >= ~numtimes, {
					~time_i = 0;
					if (~startflag.not, {
						~startflag = true;
						~freeze_r.play;
						~sine_r.play;
					});
				});
				~pitch_b.getn(2, { arg val;
					postln("pitch " ++ val[0]);
					~pitchlist[~pitch_i] = val[0];
					~pitch_i = ~pitch_i + 1;
					if(~pitch_i >= ~numpitches, {
						~pitch_i = 0;
					});
				});
			}, {} );
		};
	};
	
		
	//============== setup freeze
	//Routine {
	0.2.wait;
	
	SynthDef.new(\specfreeze_shift_8, {
		arg in=0, out=0, buf=0,
			proc_buf 		= #[1, 2, 3, 4, 5, 6, 7, 8],
			freeze 		= #[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
			amp 			= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
			amplag 		= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
			stretch		= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
			shift		= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
			stretchlag 	= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
			shiftlag 		= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
			pan 			= #[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
			panlag 		= #[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
			
		var input, output, inputchain, outputchain;
		
		stretch = Lag.kr(stretch, stretchlag);
		shift = Lag.kr(shift, shiftlag);
//		input = Normalizer.ar(SoundIn.ar(in));
		input = Normalizer.ar(Mix.new(SoundIn.ar([0, 1])));
		inputchain = FFT(buf, input);
		outputchain = PV_Copy(inputchain, proc_buf);
		outputchain = PV_Freeze(outputchain, freeze);
		outputchain = PV_BinShift(outputchain, stretch, shift);
		output = IFFT(outputchain);
		amp = Lag.kr(amp, amplag);
		output = output*amp;
		Out.ar(out, output);
	}).store;
	
	0.1.wait;
	
	~fft_in_buf = Buffer.alloc(s, 2048, 1);
	~fft_proc_buf = Array.fill(8, {Buffer.alloc(s, 2048, 1)});
	
	1.2.wait;
	
	~fft_proc_bufnum = ~fft_proc_buf.collect({arg buf; buf.bufnum });
	~fft_proc_bufnum.postln;
	
	~freeze 		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~amp 		= [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
	~amplag 		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~stretch		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~shift		= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~stretchlag 	= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	~shiftlag 	= [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
	
	~freezer_s = Synth.new(\specfreeze_shift_8, [
		\in, 0,
		\buf, ~fft_in_buf.bufnum,
		\proc_buf, ~fft_proc_bufnum,
		\freeze, ~freeze,
		\amp, ~amp,
		\amplag, ~amplag,
		\strech, ~stretch,
		\shift, ~shift,
		\stretchlag, ~stretchlag,
		\shiftlag, ~shiftlag,
	], s, \addToTail);
	
	~snapshot = { arg which; Routine {
		~freeze[which] = 0; ~freezer_s.set(\freeze, ~freeze);
		0.1.wait;
		~freeze[which] = 1; ~freezer_s.set(\freeze, ~freeze);
	}.play; };
	
	
	//======================= setup HID functions
	{ x.value("_hid.scd"); }.defer;
	
	//====================== sequencing logic for last section
	
	// pitch list
	~numpitches = 6;
	~pitchlist = Array.newClear(~numpitches);
	~pitch_i = 0;
	// time interval list
	~numtimes = 8;
	~timelist = Array.newClear(~numtimes);
	~time_i = 0;
	~hidtapper = CfTapper.new;
	
	// def for sines
	SynthDef.new(\sine_1shot, {arg out=0, hz=440.0, amp=0.1, attacktime=1, sustaintime=1, releasetime=1;
		var env, envgen;
		env = Env.linen(attacktime, sustaintime, releasetime);
		// free when done
		envgen = EnvGen.kr(env, 1.0, doneAction:2);
		Out.ar(out, SinOsc.ar(hz) * envgen * amp);
	}).load(s);
	
	
	~sine_r = Routine({ inf.do({ arg i;
		Synth.new(\sine_1shot, [
			\hz, ~pitchlist[i % ~numpitches],
			\attacktime, ~timelist[i % ~numtimes] * 0.5,
			\sustaintime, ~timelist[(i+1) % ~numtimes] * 0.5,
			\releasetime, ~timelist[(i+2) % ~numtimes] * 0.5,
			\amp, (-36.dbamp);
		]);
		postln("sined " ++ ~timelist[(i+3)%~numtimes]);
		~timelist[(i+3) % ~numtimes].wait;
	}); });
	
	~freeze_r = Routine({ inf.do({ arg i;
		// freeze the spectrum, probably
		if ((i%4)>0, { ~snapshot.value(i % 8); });
		// sometimes a long attack
		if ((i % 5)%2 == 0, {
			~amplag[i % 8] = 0.01;
			~amp[i % 8] = 0.0;
			~freezer_s.set(\amplag, ~amplag);
			~freezer_s.set(\amp, ~amp);
			~amplag[i % 8] = ~timelist[i % ~numtimes] * 0.5;
			~amp[i % 8] = -4.dbamp;
			~freezer_s.set(\amplag, ~amplag);
			~freezer_s.set(\amp, ~amp);
		});
		// sometimes a long decay
		if ((i % 5)%2 == 1, {
			~amplag[i % 8] = 0.01;
			~amp[i % 8] = -4.dbamp;
			~freezer_s.set(\amplag, ~amplag);
			~freezer_s.set(\amp, ~amp);
			~amplag[i % 8] = ~timelist[i % ~numtimes] * 0.5;
			~amp[i % 8] = 0.0;
			~freezer_s.set(\amplag, ~amplag);
			~freezer_s.set(\amp, ~amp);
		});
		postln("froze " ++ ~timelist[(i+1)%~numtimes]);
		~timelist[(i+1)%~numtimes].wait;
	}); });
	
	// wait to start war1 section
	0.2.wait;
	~switch_func = { arg val; if (val > 0, {~war1_func.value; }); };
}.play; } // start routine // waitforboot