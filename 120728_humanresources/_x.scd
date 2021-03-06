 ~basepath = "/home/emb/sc/cotccm/120728_humanresources/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.default;
 
~grbuflen = 10.0;
~ngrbuf = 4;

 
Routine {
	x.value("arduino.scd");



	c = CfAudioContext.new(s, 2, { 
		Routine {
			// buffers
			~grbuf = c.allocBufs(~ngrbuf, ~grbuflen);
			s.sync;


			SynthDef.new(\krbuspangrain, {
				arg buf=0, out=0, amp=0.25,
					trig_bus = 0,
					pos_bus = 1,
					dur_bus = 2,
					rate_bus = 3,
					pan_bus = 4,
					maxgrains = 64,
					env_buf = -1,
					amplag=4.0;
			
				var trig, pos, dur,
					rate, pan,
					snd;
				
				trig = In.kr(trig_bus);
				pos = In.kr(pos_bus);
				dur = In.kr(dur_bus);
				rate = In.kr(rate_bus); 
				pan = In.kr(pan_bus);
				
				amp = Lag.kr(amp, amplag);
				
				snd = GrainBuf.ar(
					numChannels:2,
					trigger:trig, 
					dur:dur, 
					sndbuf:buf, 
					rate:rate, 
					pos:pos, 
					interp:2, 
					pan:pan, 
					envbufnum:env_buf, 
					maxGrains:maxgrains, 
					mul:amp);
				
				Out.ar(out, snd);
			}).send(s);

			s.sync;

			// grain synths and control busses
			~gr = ~grbuf.collect({ arg bf; 
				BusGrainer.new(s, bf, c.xg, c.out_b);
			});
			~gr.do({ arg gr, i;			
				gr.grpos_s.set(\hz, 1.0 / (i + 2) / ~grbuf[i].duration);
			});
			
			// record synths
			~gr_rec = ~grbuf.collect({ arg bf; 
				Synth.new(\rec, [\in, c.in_b, \buf, bf], c.ig, \addAfter);
			});
			// analysis...
			/*
			~freq_b = Bus.control(s);
			~hasfreq_b = Bus.control(s);
			~amp_b = Bus.control(s);
			~centroid_b = Bus.control(s);
			~flatness_b = Bus.control(s);
			Synth.new(\pitch, [\in, c.in_b, \outFreq, ~freq_b, \ooutHasFreq, ~hasfreq_b], c.ig, \addAfter);
			Synth.new(\amp, [\in, c.in_b, \out, ~amp_b ], c.ig, \addAfter);
			Synth.new(\centroid, [\in, c.in_b, \out, ~centroid_b], c.ig, \addAfter);
			Synth.new(\flatness, [\in, c.in_b, \out, ~flatness_b], c.ig, \addAfter);
			*/
			x.value("voxcl.scd");
			
			~led0_on = 0.1;
			~led1_on = 0.2;
			~led0_off = 1.0;
			~led1_off = 1.0;
			
			
			~led0_r = Routine{inf.do{
				~ard_led_write.value(0, 1);
				~led0_on.wait;
				~ard_led_write.value(0, 0);
				~led0_off.wait;
			}}.play;
			
			
			~led1_r = Routine{inf.do{
				~ard_led_write.value(1, 1);
				~led1_on.wait;
				~ard_led_write.value(1, 0);
				~led1_off.wait;
			}}.play;
			
			/*
			600.wait;
			
					Routine {
						~led0_on = 0.2;
						~led0_off = 0.04;
						~led1_on = 0.24;
						~led1_off = 0.04;	
						30.0.wait;
						
						~voxclr.stop;
						~vladel_r.stop;
						~voxdel_r.stop;
						
						~gr[0].kill;
						~gr[1].kill;
						~gr[2].kill;
						~gr[3].kill;
						
						2.0.wait;
						
						Server.killAll;
						
						1.wait;
						
						x.value("_lions.scd");
					}.play;
			*/
			
		}.play;	
		
	});
}.play;
