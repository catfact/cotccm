
s = Server.local;
s.boot;
s.waitForBoot { Routine {
	~breath_len = 44.0;
	~breath_buf = Buffer.alloc(s, s.sampleRate * ~breath_len);
	0.05.wait;
	SynthDef.new(\adc_rec_1shot, { arg in=0, buf=0, pre=0.0, off=0;
		RecordBuf.ar(SoundIn.ar(in), buf, preLevel:pre, offset:off, loop:0, doneAction:2);
	}).store;
	0.001.wait;
	~breath_rec_s = Synth.new(\adc_rec_1shot, [
		\in, 0,
		\buf, ~breath_buf.bufnum;
	]);	
	
	postln("breaths rec");
	~breath_rates = [2/4, 3/8, 4/16, 5/16, 6/16, 7/16, 9/32, 11/32, 13/32, 15/32];
	~breath_rates = ~breath_rates ++ (~breath_rates * 0.5);
	SynthDef.new(\play_1shot, { 
		arg out=0, buf=0, amp=1.0,
			dur=1.0, attack=1.0, release=1.0,
			rate=1.0, off=0.0,
			pan=0.0, curve= -4.0;
		var env, envgen, play;
		env = Env.new([0.0, 1.0, 1.0, 0.0], [attack, dur-attack-release, release], [-1, 0, -1]);
		envgen = EnvGen.ar(env, 1, doneAction:2);
		play = PlayBuf.ar(1, buf, rate, 1, off);
		Out.ar(out, Pan2.ar(play * envgen * amp, pan));
	}).store;
	0.001.wait;
	~breath_bus = Bus.audio(s, 2);
	~breath_comp = {
		var input = In.ar([~breath_bus.index, ~breath_bus.index + 1]);
		Out.ar([0, 1], Compander.ar(input, input, thresh:(-24.dbamp), slopeAbove:0.05, slopeBelow:1, clampTime: 0.01, relaxTime: 0.01));
	}.play(s);å
	SystemClock.sched(~breath_len, {
		~breath_s = ~breath_rates.collect({
			arg rate, i;
			var dur;
			dur = ~breath_len / rate;
			dur.postln;
			Synth.new(\play_1shot, [
				\out, ~breath_bus.index,å
				\buf, ~breath_buf.bufnum,
				\rate, rate,
				\dur, dur,
				\attack, 1.0,
				\release, 10.0,
				\pan, i / (~breath_rates.size-1) * 0.5 - 0.25,
				\amp, 1.0 / ~breath_rates.size * 8.0
			], ~breath_comp, \addBefore);
		}); // collect
		postln("breaths play");
		
		Routine {
			///// vla double hell delay
			~vla_del_buflen = 172.0;
			~vla_del_buf = Array.fill(2, {Buffer.alloc(s, ~vla_del_buflen * s.sampleRate, 1); });
			0.1.wait;
		
			~vla_del_in_b = Bus.audio(s, 1);
			~vla_del_out_b = Bus.audio(s, 1);
		
			SynthDef.new(\bufdel, {
				arg in=0, out=0, buf=0, amp=1.0,
				delaytime=1.0,
				fb=0.0;
				var input, hz, del, output;
				//fb = fb.min(0.8);			
				input = In.ar(in) + (LocalIn.ar(1) * fb);
				del = BufDelayL.ar(buf, input, delaytime);
				output = del;
				LocalOut.ar(output);
				Out.ar(out, output * amp);
			}).store;
			SynthDef.new(\adc, {
				arg in, out, amp=1.0, amplag=1.0;
				amp = Lag.kr(amp, amplag);
				Out.ar(out, SoundIn.ar(in) * amp);
			}).store;
			SynthDef.new(\pan, {
				arg in, out, amp=1.0, amplag=1.0, pan=0.0;
				amp = Lag.kr(amp, amplag);
				Out.ar(out, Pan2.ar(In.ar(in) * amp), pan);
			}).store;
			
			0.001.wait;
			
			~vla_del_in_s = Synth.new(\adc, [\in, 1, \out, ~vla_del_in_b.index, \amplag, 30.0]);
			~vla_del_out_s = Synth.new(\pan, [\in, ~vla_del_out_b.index, \out, 0, \amplag, 60.0], ~vla_del_in_s, \addAfter);
			~vla_del_s = Array.fill(2, {arg i;
				Synth.new(\bufdel, [
					\buf, ~vla_del_buf[i].bufnum, 
					\in, ~vla_del_in_b.index,
					\out, ~vla_del_out_b.index
				], ~vla_del_in_s, \addAfter);
			});
			
			~vla_del_num = Array.fill(2, {1});
			~vla_del_denom = Array.fill(2, {1});	
			
			~vla_minfb = 0.0;
				
			~vla_del_r = Routine { inf.do({ arg i;
				var wait, del0, del1, fb;
				if (i.asInteger.even, {
					~vla_del_num[0] = (~vla_del_num[0] + (i*2)).wrap(1, 33);
					~vla_del_denom[1] = (~vla_del_denom[1] - (i*5)).wrap(1, 13);
				}, {
					~vla_del_num[1] = (~vla_del_num[1] - (i*4)).wrap(1, 29);
					~vla_del_denom[0] = (~vla_del_denom[0] + (i*3)).wrap(1, 17);
				});
				del0 = ~vla_del_num[0] / ~vla_del_denom[0] * 4.0;
				del1 = ~vla_del_num[1] / ~vla_del_denom[1] * 4.0;
				while({del0 < 8.0}, { del0 = del0 * 2.0; });
				while({del1 < 8.0}, { del1 = del1 * 2.0; });
				while({del0 > ~vla_del_buflen}, { del0 = del0 / 2.0; });
				while({del1 > ~vla_del_buflen}, { del1 = del1 / 2.0; });
				wait = (del0 + del1) * 2;
				fb = (del0 + del1).wrap(0.01, 0.9).max(~vla_minfb);
				~vla_del_s[0].set(\delaytime, del0);
				~vla_del_s[1].set(\delaytime, del1);
				~vla_del_s[0].set(\fb, fb);
				~vla_del_s[1].set(\fb, fb);
				("vla del " ++ [del0, del1]).postln;
				wait.wait;
			}); }.play; // vla delay switch
			
			/////// schedule viola delay freeze
			SystemClock.sched(~vla_del_buflen * 4, {
				~vla_minfb = 1.0;
				~vla_del_in_s.set(\amp, 0.0);
				postln ("vla del is frozen");
			nil });
			
			///// schedule viola glicks
			Routine {
				~vla_del_buflen.wait;
				~glick_g = Group.new(s);
				SynthDef.new(\glick, {
					arg buf=0, out=0,
						amp=1.0, pan= -0.5,
						pulserate=1.0, posrate=0.25, playrate=1.0,
						thepos=0.0;
					var pulse, pos, play;
					pulse = Impulse.kr(pulserate);
					pos = Phasor.ar(0, posrate, 0, BufFrames.kr(buf));
					play = PlayBuf.ar(1, buf, playrate, pulse, pos, 1);
					Out.ar(out, Pan2.ar(play * amp, pan));
				}).store;
				
				0.002.wait;
				
				~glick1 = Synth.new(\glick, [
					\amp, 0.25,
					\buf, ~vla_del_buf[0].bufnum,
					\pan, -0.5,
					\pulserate, 0.5,
					\posrate, 0.25,
					\playrate, 4.0,
					\out, 0 // ~glick_b.index
				], ~glick_g); 
				
				~glick2 = Synth.new(\glick, [
					\amp, 0.25,
					\buf, ~vla_del_buf[1].bufnum,
					\pan, 0.5,
					\pulserate, 0.6,
					\posrate, 0.5,
					\playrate, 4.0,
					\out, 0 // ~glick_b.index
				], ~glick_g); 
				
				~glick3 = Synth.new(\glick, [
					\amp, 0.25,
					\buf, ~vla_del_buf[0].bufnum,
					\pan, 0.35,
					\pulserate, 0.75,
					\posrate, 0.4,
					\playrate, 2.0,
					\out, 0 // ~glick_b.index
				], ~glick_g); 
				
				~glick4 = Synth.new(\glick, [
					\amp, 0.125,
					\buf, ~vla_del_buf[1].bufnum,
					\pan, -0.35,
					\pulserate, 1.125,
					\posrate, 0.3,
					\playrate, 2.0,
					\out, 0 // ~glick_b.index
				], ~glick_g);  
				
				~glick5 = Synth.new(\glick, [
					\amp, 0.125,
					\buf, ~vla_del_buf[0].bufnum,
					\pan, 0.35,
					\pulserate, 0.25,
					\posrate, 0.2,
					\playrate, 0.25,
					\out, 0 // ~glick_b.index
				], ~glick_g); 
				
				~glick6 = Synth.new(\glick, [
					\amp, 0.125,
					\buf, ~vla_del_buf[1].bufnum,
					\pan, -0.35,
					\pulserate, 0.35,
					\posrate, 0.6,
					\playrate, 0.25,
					\out, 0 // ~glick_b.index
				], ~glick_g);  
				postln("vla glicks");
			}.play; 
			
			///// schedule vox delay			
			Routine {
				(~vla_del_buflen * 4).wait;
				~vox_del_buflen = 30.0;
				~vox_del_buf = Array.fill(2, {Buffer.alloc(s, ~vox_del_buflen * s.sampleRate, 1); });
				0.1.wait;
			
				~vox_del_in_b = Bus.audio(s, 1);
				~vox_del_out_b = Bus.audio(s, 1);
				0.001.wait;
				
				~vox_del_in_s = Synth.new(\adc, [\in, 0, \out, ~vox_del_in_b.index, \amplag, 30.0]);
				~vox_del_out_s = Synth.new(\pan, [\in, ~vox_del_out_b.index, \out, 0, \amplag, 60.0], ~vox_del_in_s, \addAfter);
				~vox_del_s = Array.fill(2, {arg i;
					Synth.new(\bufdel, [
						\buf, ~vox_del_buf[i].bufnum, 
						\in, ~vox_del_in_b.index,
						\out, ~vox_del_out_b.index,
	⁃					\amp, -4.dbamp
					], ~vox_del_out_s, \addBefore);
				});
				
				~vox_del_num = Array.fill(2, {1});
				~vox_del_denom = Array.fill(2, {1});
				
				~vox_minfb = 0.0;
					
				~vox_del_r = Routine { inf.do({ arg i;
					var wait, del0, del1, fb;
					if (i.asInteger.even, {
						~vox_del_num[0] = (~vox_del_num[0] + (i*2)).wrap(1, 33);
						~vox_del_denom[1] = (~vox_del_denom[1] - (i*5)).wrap(1, 13);
					}, {
						~vox_del_num[1] = (~vox_del_num[1] - (i*4)).wrap(1, 29);
						~vox_del_denom[0] = (~vox_del_denom[0] + (i*3)).wrap(1, 17);
					});
					del0 = ~vox_del_num[0] / ~vox_del_denom[0] * 4.0;
					del1 = ~vox_del_num[1] / ~vox_del_denom[1] * 4.0;
					while({del0 < 8.0}, { del0 = del0 * 2.0; });
					while({del1 < 8.0}, { del1 = del1 * 2.0; });
					while({del0 > ~vox_del_buflen}, { del0 = del0 / 2.0; });
					while({del1 > ~vox_del_buflen}, { del1 = del1 / 2.0; });
					wait = (del0 + del1) * 2;
					fb = (del0 + del1).wrap(0.01, 0.9).max(~vox_minfb);
					~vox_del_s[0].set(\delaytime, del0);
					~vox_del_s[1].set(\delaytime, del1);
					~vox_del_s[0].set(\fb, fb);
					~vox_del_s[1].set(\fb, fb);		    
					("vox del " ++ [del0, del1]).postln;
					wait.wait;
				}); }.play;		
			}.play; // vox delay setup
		}.play; // vla delay setup 
	nil }); // breath play sched
}.play; }; // routine // waitforboot