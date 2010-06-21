

s = Server.default;
//s.options.memSize = 8192 * 4;
s.waitForBoot { Routine {
	SynthDef.new(\looper, {
		arg buf, in=0, out=0,
			reclevel=0.0, prelevel=1.0, looptime=10.0,
			trig=0,
			amp=0.0, amplag = 1.0,
			rate=1.0;
		
		var sig, rec, play, rtrig, ptrig;
		
		amp = Lag.kr(amp, amplag);
		
		reclevel = Lag.kr(reclevel, 0.02);
		prelevel = Lag.kr(prelevel, 0.02);
		
		sig = SoundIn.ar(in);
	
		ptrig = LFPulse.kr(1.0 / looptime, 0.0, 0.5) + trig;
		rtrig = DelayN.kr(ptrig, 0.01, 0.001);
		
		rec = RecordBuf.ar(sig, buf, 0, reclevel, prelevel, 1, 1, rtrig);
		
		play = PlayBuf.ar(1, buf, rate * BufRateScale.kr(buf), ptrig, 0.0, 1);
		play = play * amp;
		
		Out.ar(out, play);
		
	}).store;
	
	s.sync;
	
	~loop_buf = Array.fill(8, { Buffer.alloc(s, 180.0 * s.sampleRate, 1); });
	
	0.5.wait;
	
	timeratios = [1, 2, 3/2, 4, 5/2, 5/4, 7/2, 7/4].sort;
	
	~loop_s = Array.fill (8, { arg i;
		Synth.new(\looper, [
			\buf, ~loop_buf[i].bufnum,
			\looptime, 10.0
		]);
	});
	
	s.sync;
		
	~loop_tog_switch = Array.fill(8, {0});
	~loop_tog_tap = Array.fill(8, {CfTapper.new; });
	
	~monome.pressFunctions.add('uppermid'->{ arg col, row;
		if (row==2, {
			~loop_tog_tap[col].tap;
					
			if (col == 0, {
				if (~loop_tog_switch[0] == 0, {
					~loop_s[0].set(\reclevel, 1.0);
					~loop_s.do({ arg syn, i;
						syn.set(\prelevel, 0);
					});
			});
		});
		if (row==3, {
			~loop_s[col].set(\reclevel, 1.0);
			~monome.led(col, 3, 1);
		});
	});
	
	~monome.liftFunctions.add('uppermid'->{ arg col, row;
		
		if(row==2, {
			if (~loop_tog_switch[col] > 0, {
				~loop_tog_tap[col].tap;
				~loop_s[col].set(\amplag, ~loop_tog_tap[col].time);
				~loop_s[col].set(\amp, 0.0);
				~loop_tog_switch[col] = 0;
				~monome.led(col, 2, 0);
				
				
				
			}, {
				~loop_tog_switch[col].tap;
				~loop_s[col].set(\amplag, ~loop_tog_tap[col].time);
				~loop_s[col].set(\amp, 1.0);
				~loop_tog_switch[col] = 1;
				~monome.led(col, 2, 1);
				
				if (col == 0, {
					~loop_s.do({ arg syn, i;
						syn.set(\looptime, ~timeratios[i] * ~loop_tog_tap[col].time);
						syn.set(\prelevel, 1.0);
					});
				});

				
			}); // switch test
		}); // row 2
		
		if(row==3, {
			~loop_s[col].set(\reclevel, 0.0);
			~monome.let(col, 3, 0);
		});


		
	});
}.play; };	
