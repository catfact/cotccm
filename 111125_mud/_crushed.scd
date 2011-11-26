Routine {
	
	SynthDef.new(\gr_env_rlpf, {
		arg out=0, buf=0, level=1.0,
		atk=0.01, sus=0.2, rel=0.5,
		pos=0.0,
		//rate=1.0,
		rate=0.5,
		rq_atk=0.01, rq_sus=0.1, rq_rel=0.1, rq_mul=0.4, rq_add=0.2,
		hz_atk=0.01, hz_sus=0.01, hz_rel=0.2, hz_mul=880, hz_add=220;
		
		var gr, sr, phase, dur, amp, hz, rq;
		dur = (atk+sus+rel) / rate;
		sr = BufSampleRate.kr(buf);
		phase = Line.ar(0, dur * sr * rate, dur) + (pos * sr);
		gr = BufRd.ar(1, buf,  phase);
//		gr = PlayBuf.ar(1, buf, rate, startPos:pos);
		amp = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2) * level;
		hz = EnvGen.ar(Env.linen(hz_atk, hz_sus, hz_rel), levelScale:hz_mul, levelBias:hz_add);
		rq = EnvGen.ar(Env.linen(rq_atk, rq_sus, rq_rel), levelScale:rq_mul, levelBias:rq_add);
		Out.ar(out, RLPF.ar(gr, hz, rq) * amp);
	}).send(s);
	
	~voc_buf = Buffer.alloc(s, s.sampleRate * 16.0, 1);
	
	s.sync;
	
	~voc_rec_s = Synth.new(\rec, [\in, a.in_b.index, \buf, ~voc_buf.bufnum], a.ig, \addAfter);
	
			
	{	
		c = CfHueMorphCanvas.new;
		c.color_(Color.new(0.6, 0.0, 1.0));
		c.layers.add(CfGridTrace2d.new(c.window.view.bounds, 8, 16));
		c.layers[0].alpha_(1.0);
		c.layers[0].mode_(1);
		c.dt = 0.2;
		
		x.value("_ca_weights.scd");
		
		c.layers[0].model = CfContinuousAut.new(c.layers[0].n);
	
		c.layers[0].model.weights_l = ~weights_l.choose;
		c.layers[0].model.weights_r = ~weights_r.choose;
	
		x.value("weights_ok_1.scd");
	
		~vrs = [1, 2, 3/2, 5/4, 6/5, 7/8];
	
		c.layers[0].model.function = {
			arg val;
		//	val.postln;
			val.do({arg v, i;
				
				Synth.new(\gr_env_rlpf, [
					\pos, i * (~voc_buf.duration / c.layers[0].n),
					\buf, ~voc_buf.bufnum,
					\rel, 2.0,
					\atk, 0.1 - (v.abs * 0.099),
					\hz_mul, 220 * (2 ** (v + 2)),
					\rq_mul, -0.3,
					\rq_add, 1.0,
					\level, ((1.0 - v.abs) * -30).dbamp,
					\rq_sus, 0.01,
					\rate,~vrs[v.linlin(-1.0, 1.0, 0, ~vrs.size - 1).floor]
				]);
			});
		};
		
		c.play;
	}.defer;
}.play;
