
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
	}.play(s);
	SystemClock.sched(~breath_len, {
		~breath_s = ~breath_rates.collect({
			arg rate, i;
			var dur;
			dur = ~breath_len / rate;
			dur.postln;
			Synth.new(\play_1shot, [
				\out, ~breath_bus.index,
				\buf, ~breath_buf.bufnum,
				\rate, rate,
				\dur, dur,
				\attack, 1.0,
				\release, 10.0,
				\pan, i / (~breath_rates.size-1) * 0.5 - 0.25,
				\amp, 1.0 / ~breath_rates.size * 4.0
			], ~breath_comp, \addBefore);
		}); // collect
		postln("breaths play");
		
		Routine {
			///// vla double hell delay
		
			~vla_del_buflen = 60.0;
			~vla_del_buf = Array.fill(2, {Buffer.alloc(s, ~vla_del_buflen * s.sampleRate, 1); });
			0.1.wait;
		
			SynthDef.new(\bufdel, {
				arg in=0, out=0, buf=0, amp=1.0,
				delaytime=1.0,
				fb=0.0;
				var input, hz, del, output;
				fb = fb.min(0.8);			
				input = SoundIn.ar(in) + (LocalIn.ar(1) * fb);
				del = BufDelayL.ar(buf, input, delaytime);
	
				output = del;
				LocalOut.ar(output);
				Out.ar(out, output * amp);
			}).store;
			
			0.001.wait;
			
			~vla_del_s = Array.fill(2, {arg i;
				Synth.new(\bufdel, [
					\buf, ~vla_del_buf[i].bufnum, 
					\in, 1
				]);
			});
			
			~numerator = Array.fill(2, {1});
			~denominator = Array.fill(2, {1});		
			~vla_del_r = Routine { inf.do({ arg i;
				var wait, del0, del1, fb;
				if (i.asInteger.even, {
					~numerator[0] = (~numerator[0] + (i*2)).wrap(1, 33);
					~denominator[1] = (~denominator[1] - (i*5)).wrap(1, 13);
				}, {
					~numerator[1] = (~numerator[1] - (i*4)).wrap(1, 29);
					~denominator[0] = (~denominator[0] + (i*3)).wrap(1, 17);
				});
				del0 = ~numerator[0] / ~denominator[0] * 4.0;
				del1 = ~numerator[0] / ~denominator[0] * 4.0;
				while({del0 < 8.0}, { del0 = del0 * 2.0; });
				while({del1 < 8.0}, { del1 = del1 * 2.0; });
				while({del0 > ~vla_del_buflen}, { del0 = del0 / 2.0; });
				while({del1 > ~vla_del_buflen}, { del1 = del1 / 2.0; });
				wait = (del0 + del1) * 2;
				fb = (del0 + del1).wrap(0.01, 0.9);
				~vla_del_s[0].set(\delaytime, del0);
				~vla_del_s[1].set(\delaytime, del1);
				~vla_del_s[0].set(\fb, fb);
				~vla_del_s[1].set(\fb, fb);
				wait.wait;
			}); }.play;
		}.play;
	nil }); // breath play sched
}.play; }; // routine // waitforboot