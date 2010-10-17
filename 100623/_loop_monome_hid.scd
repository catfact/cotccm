

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
	
	~master_loop_rec = {
		~loop_s[0].set(\reclevel, 1.0);
		
		~loop_s.do({ arg syn, i;
			syn.set(\prelevel, 0);
			~loop_buf[i].zero;
			~loop_trig_s[i].free;
		});
		
		~loop_trig_b[0].set(0);
		~loop_trig_b[0].set(1);
	};
	
	~master_loop_fadein = { arg dur;
		~loop_s.do({ arg syn, i;
			~loop_trig_s[i] = Synth.new(\krpulse, [
				\freq, 1.0 / (~timeratios[i] * dur),
				\out, ~loop_trig_b[i].index
			], ~loop_trig_g, \addToTail);

			syn.set(\prelevel, 1.0);
			syn.set(\reclevel, 0.0);
				
			~loop_s[i].set(\amplag, dur);
			~loop_s[i].set(\amp, -10.dbamp);
			~monome.led(i, 4, 1);
			~loop_tog_switch[i] = 1;
		});


	};
	
	~slave_loop_fadein = { arg which, dur;	
		~loop_s[which].set(\amplag, dur);
		~loop_s[which].set(\amp, -10.dbamp);
		~loop_tog_switch[which] = 1;
		~monome.led(which, 4, 1);
	};
	
	~loop_fadeout = { arg which, dur;
		~loop_s[which].set(\amplag, dur);
		~loop_s[which].set(\amp, 0.0);
		~loop_tog_switch[which] = 0;
		~monome.led(which, 4, 0);

	};
	
	~overdub = { arg which, val; 
		~loop_s[which].set(\recLevel, val);
		~monome.led(which, 5, val);
	};
	
	
	~monome.pressFunctions.add('uppermid'->{ arg col, row;
		if (row==4, {
			if (col == 0, {
				if (~loop_tog_switch[0] == 0, {
					~loop_s[0].set(\in, 0);
					~master_loop_rec.value;			
					~loop_tog_tap[0].tap;		
				});
			}, {
				~loop_tog_tap[col].tap;
			});
		});
		if (row==5, {
			~loop_s[col].set(\in, 0);
			~overdub.value(col, 1.0);

		});
	}); // press function
	
	~monome.liftFunctions.add('uppermid'->{ arg col, row;
		if(row==4, {
			if (~loop_tog_switch[col] > 0, {
				~loop_tog_tap[col].tap;
				~loop_fadeout.value(col, ~loop_tog_tap[col].time);				
			}, {
				if (col == 0, {
					~loop_tog_tap[0].tap;
					~master_loop_fadein.value(~loop_tog_tap[0].time);
				}, {
					~loop_tog_tap[col].tap;
					~slave_loop_fadein.value(~loop_tog_tap[col].time);
				});
			}); // switch test
		}); // row 4
		
		if(row==5, {
			~overdub.value(col, 0.0);
		});
	}); // lift function

	~hid_loop_num = 0;
	// HID footswitch!
	~switch_func = {
		arg val;
		
		"fuck!".postln;
		if (val > 0, {
		
			if(~loop_tog_switch[0] == 0, {~hid_loop_num = 0;});
		
			if (~hid_loop_num == 0, {
				if (~loop_tog_switch[0] == 0, {
					~loop_tog_tap[0].tap;
					~loop_s[0].set(\in, 1);
					~master_loop_rec.value;
				}, {
					~loop_s[0].set(\in, 1);
					~overdub.value(0, 1);
				});
			}, {
				~loop_s[~hid_loop_num].set(\in, 1);
				~overdub.value(~hid_loop_num, 1);
			})
		}, {
			if (~loop_tog_switch[0] == 0, {
				~loop_tog_tap[0].tap;
				~master_loop_fadein.value(~loop_tog_tap[0].time);
			}, {
				~overdub.value(~hid_loop_num, 0);
				~hid_loop_num = (~hid_loop_num + 1) % 8;
			});
		});		
	};
}.play; };	
