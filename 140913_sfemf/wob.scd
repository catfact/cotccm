

Routine {
	~wob_blen = 64.0;

	~wob_buf = Buffer.alloc(s, ~wob_blen * s.sampleRate, 1);

	~cueAction.value("RECWOB",
		dur:~wob_blen,
		start:{ Synth.new(\recOnce, [
			\in, ~ib.index + 0,
			\buf, ~wob_buf.bufnum
			], ~ig, \addAfter);
		},
		end: {
			Routine {
				~wob_buf.normalize;

				SynthDef.new(\wob, {
					arg out=0, buf=0,
					trig=0, pos=0.0, loop=1,
					rate=1.0, wob_rate = 0.0625,
					wob_amp=4.0,
					atk=0.01, rel=0.01, gate=1, doneaction=2,
					pan=0.0, level=1.0,
					lpf_hz=1000, wob_lpf_hz=60,
					wob_rate_mul=1.0, wob_lpf_mix=0.0, wob_amp_mix=1.0;

					var son, amp, env, wob;

					env = Env.asr(atk, 1.0, rel);
					amp = EnvGen.ar(env, gate, doneAction:doneaction);
					son = PlayBuf.ar(1, buf, rate, trig, pos, loop:loop);
					wob = PlayBuf.ar(1, buf, wob_rate * wob_rate_mul, trig, pos, loop:loop);
					//wob = Normalizer.ar(wob);
					wob = Clip.ar(wob * wob_amp, -1.0, 1.0);
					wob = LPF.ar(wob, wob_lpf_hz);
					son = LPF.ar(son, lpf_hz);
					son = (son*wob)*wob_amp_mix + (LPF.ar(son, lpf_hz*(1.0 + wob*0.25)) * wob_lpf_mix);
					Out.ar(out, Pan2.ar(son*amp, pan, level));
				}).send(s);


				s.sync;

				~wobs = List.new;
				~wobg = Group.new(~xg);

				~wobs.add(Synth.new(\wob, [
					\out, ~ob.index, \buf, ~wob_buf.bufnum,
					\rate, 1/4, \wob_rate, 1/64, \loop, 1,
					\pan, -1.0, \level, 0.5
					], target:~wobg)
				);

				~wobs.add(Synth.new(\wob, [
					\out, ~ob.index, \buf, ~wob_buf.bufnum,
					\rate, 63/256, \wob_rate, 15/1024, \loop, 1,
					\pan, 1.0, \level, 0.5
					], target:~wobg)
				);

				~wobs.add(Synth.new(\wob, [
					\out, ~ob.index, \buf, ~wob_buf.bufnum,
					\rate, 9/32, \wob_rate, 1.25/64, \loop, 1,
					\pan, -0.5, \level, 0.5
					], target:~wobg)
				);

				~wobs.add(Synth.new(\wob, [
					\out, ~ob.index, \buf, ~wob_buf.bufnum,
					\rate, 65/256, \wob_rate, 17/1024, \loop, 1,
					\pan, 0.5, \level, 0.5
					], target:~wobg)
				);


				~wobs[0].set(\rate, 0.5);
				~wobs[1].set(\rate, 15/32);

				~wobs[2].set(\rate, 129/256);
				~wobs[3].set(\rate, 17/32);

				~wobs.do({|wob| wob.set(\level, -2.dbamp);});
				~wobs.do({|wob| wob.set(\lpf_hz, 5000);});

				~wob_rate_mul_bus = Bus.control(s, 1);
				~wob_amp_mix_bus = Bus.control(s, 1);
				~wob_lpf_mix_bus = Bus.control(s, 1);

				~wobs.do({|wob| wob.map(\wob_rate_mul, ~wob__ratemul_bus); });
				~wobs.do({|wob| wob.map(\wob_amp_mix, ~wob_amp_mix_bus); });
				~wobs.do({|wob| wob.map(\wob_lpf_mix, ~wob_lpf_mix_bus); });


				~wobs.do({ arg wob, i; ~wob.set(\lpf_hz, ~hz_base[i] * 2.0); });

				s.sync;

				~wob_amp_mix_bus.set(1.0);
				~wob_rate_mul_bus.set(0.5);


				~wob_mul_s = { arg x=1.0, t=8.0; Out.kr(~wob_rate_mul_bus, Ramp.kr(x, t)); }.play(~ig);
				~wob_amp_s = { arg x=1.0, t=8.0; Out.kr(~wob_amp_mix_bus, Ramp.kr(x, t)); }.play(~ig);
				~wob_lpf_s = { arg x=0.0, t=8.0; Out.kr(~wob_lpf_mix_bus, Ramp.kr(x, t)); }.play(~ig);

				s.sync;

				~wob_lpf_s.set(\x, 0.5);
				~wob_amp_s.set(\x, 1.0);



			}.play;
	});

}.play;
/*

~wobs[0].set(\rate, 0.5);
~wobs[1].set(\rate, 15/32);


~wobg.free;

~wobg.set(\gate, 0);

~wobg.set(\rel, 32);
~wobg.set(\gate, 0);


~wobs.clear;

*/