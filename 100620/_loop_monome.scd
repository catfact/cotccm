

s = Server.default;
//s.options.memSize = 8192 * 4;
s.waitForBoot { Routine {
	SynthDef.new(\looper, {
		arg buf, in=0, out=0,
			reclevel=0.0, prelevel=1.0, looptime=10.0,
//			trig=0,
			trigbus=0,
			amp=0.0, amplag = 1.0,
			rate=1.0;
		
		var sig, rec, play, rtrig, ptrig;
		
		amp = Lag.kr(amp, amplag);
		
		reclevel = Lag.kr(reclevel, 0.02);
		prelevel = Lag.kr(prelevel, 0.02);
		
		sig = SoundIn.ar(in);
	
//		ptrig = LFPulse.kr(1.0 / looptime, 0.0, 0.5) + trig;
		ptrig = In.kr(trigbus, 1);
		rtrig = DelayN.kr(ptrig, 0.1, 0.01);
		
		rec = RecordBuf.ar(sig, buf, recLevel:reclevel, preLevel:prelevel, run:1, loop:0, trigger:rtrig);
		
		play = PlayBuf.ar(1, buf, rate:(rate * BufRateScale.kr(buf)), trigger:ptrig, startPos:0.0, loop:0);
		play = play * amp;
		
		Out.ar(out, play);
		
	}).store;
	
	
	SynthDef.new(\krpulse, {arg out=0, freq=1.0, amp=2.0, iphase=0.0, duty=0.5;
		Out.kr(out, LFPulse.kr(freq, iphase, duty, amp));
	}).store;
	s.sync;
	
	~loop_buf = Array.fill(8, { Buffer.alloc(s, 180.0 * s.sampleRate, 1); });
	
	0.5.wait;
	
	~timeratios = [1, 2, 3/2, 4, 5/2, 5/4, 7/2, 7/4].sort;

	~loop_trig_b = Array.fill(8, { Bus.control(s, 1); });	~loop_trig_g = Group.new(s);
	~loop_trig_s = Array.newClear(8);
	
	~loop_s = Array.fill (8, { arg i;
		Synth.new(\looper, [
			\buf, ~loop_buf[i].bufnum,
			\looptime, 10.0,
			\trigbus, ~loop_trig_b[i].index
		], ~loop_trig_g, \addAfter);
	});

	
	
	s.sync;
		
	~loop_tog_switch = Array.fill(8, {0});
	~loop_tog_tap = Array.fill(8, {CfTapper.new; });
	
	~monome.pressFunctions.add('lowermid'->{ arg col, row;
		if (row==4, {
			~loop_tog_tap[col].tap;
					
			if (col == 0, {
				if (~loop_tog_switch[0] == 0, {
					~loop_s[0].set(\reclevel, 1.0);
					
					~loop_trig_b[0].set(0);
					~loop_trig_b[0].set(1);
					
					~loop_s.do({ arg syn, i;
						syn.set(\prelevel, 0);
						~loop_buf[i].zero;
						~loop_trig_s[i].free;
						

					});
				});
			});
		});
		if (row==5, {
			~loop_s[col].set(\reclevel, 1.0);
			~monome.led(col, 5, 1);
		});
	}); // press function
	
	~monome.liftFunctions.add('lowermid'->{ arg col, row;
		
		if(row==4, {
			if (~loop_tog_switch[col] > 0, {
				~loop_tog_tap[col].tap;
				~loop_s[col].set(\amplag, ~loop_tog_tap[col].time);
				~loop_s[col].set(\amp, 0.0);
				~loop_tog_switch[col] = 0;
				~monome.led(col, 4, 0);
				
			}, {
				~loop_tog_tap[col].tap;
				~loop_s[col].set(\amplag, ~loop_tog_tap[col].time);
				~loop_s[col].set(\amp, -14.dbamp);
				~loop_tog_switch[col] = 1;
				~monome.led(col, 4, 1);
				
				~loop_tog_tap[col].time.postln;
				
				if (col == 0, {
					~loop_s.do({ arg syn, i;
						//SystemClock.sched(0.001, {
							~loop_trig_s[i] = Synth.new(\krpulse, [
								\freq, 1.0 / (~timeratios[i] * ~loop_tog_tap[col].time),
								\out, ~loop_trig_b[i].index
							], ~loop_trig_g, \addToTail);
						//nil });
						syn.set(\prelevel, 1.0);
						syn.set(\reclevel, 0.0);
					});
				});

				
			}); // switch test
		}); // row 4
		
		if(row==5, {
			~loop_s[col].set(\reclevel, 0.0);
			~monome.led(col, 5, 0);
		});
	}); // lift function
	
}.play; };	
