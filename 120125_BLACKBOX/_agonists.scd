
	Routine {
		
		~vla_del_buf = Array.fill(4, { |i| Buffer.alloc(s, s.sampleRate * (30 * (i+1) + i + 10), 1); });
		
		s.sync;
		
		~vla_in_b = Bus.audio(s, 1);
				
		~vla_in_s = { Out.ar(~vla_in_b.index, SoundIn.ar(1)); }.play(s);
		
		~vla_hz_b = Bus.control(s, 1);
		~vla_hz_s = { Out.kr(~vla_hz_b.index, Pitch.kr(In.ar(~vla_in_b.index))) }.play(~vla_in_s, addAction: \addAfter);
			
		s.sync;
		
		~vla_del_s = Array.fill(4, { arg i; 
			Synth.new(\bufdelay_bpf_fb_pan, [
				\buf, ~vla_del_buf[i].bufnum, 
				\in, ~vla_in_b.index,
				\out, 0,
				\time, (i+1) * 30.0 + i,
				\fb, 0.3,
				\amp, 0.0,
				\amp_lag, (i+1) * 30.0 + i,
				\pan, i.linlin(0, 3, -0.5, 0.5);
			], ~vla_in_s, \addAfter);
		});	
		
		~agonists_hz = List.new;
		
		Routine { 10.do({ arg i;
			30.0.wait;
			~vla_hz_b.get({ arg hz;
				if (hz < 800 && hz > 100, {
					~agonists_hz.add(hz);
				});
			});
		}); }.play;
		
	}.play;
	
	~agonists_1 = { arg time;
		~vla_del_s.do({ arg del, i;
			del.set(\amp_lag, time * (i + 1));
			del.set(\amp, 0.5);
		});	
	};
	
	
	~agonists_2 = { arg time;
		~vla_del_s.do({ arg del;
			del.set(\fb_lag, 16);
			del.set(\fb, 0.99);
		});
	};
	
	
	~agonists_3 = { arg time;
		~vla_del_s.do({ arg del, i;
			del.set(\bpf_mix_lag, 32.0);
			del.set(\bpf_mix, 0.5);
		});
		~vla_del_bpf_r = Routine {inf.do({ arg i;
			~vla_del_s.wrapAt(i).set(\bpf_hz_lag, (16 + 16.rand));
			~vla_del_s.wrapAt(i).set(\bpf_rq_lag, (16 + 16.rand));
			~vla_del_s.wrapAt(i).set(\bpf_hz, ~agonists_hz.wrapAt(i));
			~vla_del_s.wrapAt(i).set(\bpf_rq, 0.1 + 0.9.rand);
			(16 + 16.rand).wait;
		}); }.play;
	};