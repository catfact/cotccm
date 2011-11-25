Routine {	
	SynthDef.new(\bufd_bpf, {
		arg in=0, out=0, buf=0, amp=1.0, amplag=0.1,
		delaytime=1.0,
		hz = 8000.0,
		rq=2.0,
		filtermix=1.0, filterlag=1.0,
		fb=0.0;
		
		var input, del, output, filter;
		
		amp = Lag.kr(amp, amplag);
		hz = Lag.kr(hz, filterlag);
		rq = Lag.kr(rq, filterlag);
				
		input = In.ar(in) + (LocalIn.ar(1) * fb);
		del = BufDelayL.ar(buf, input, delaytime);
		filter = BPF.ar(del, hz, rq);
		output= del + (filter * filtermix);
		
		LocalOut.ar(output);
		Out.ar(out, output * amp);
	}).send(s);
	
	SynthDef.new(\shiftgrain, {
		arg in=0, out=0, buf=0,
		rate = 0.25,
		atk=0.1, sus=2.0, rel=4.0,
		amp=0.5, lpf=1200; 
		
		var wphase, rphase,
		ampenv, output;
		
		ampenv = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
		wphase = Phasor.ar(
			trig:0,
			rate:BufRateScale.kr(buf),
			start:0,
			end:BufFrames.kr(buf)
		);
		BufWr.ar(In.ar(in), buf, wphase);
		// rphase = (wphase - 10).wrap(0, BufFrames.kr(buf));
		rphase = Phasor.ar(
			trig:0,
			rate:BufRateScale.kr(buf) * rate,
			start:0,
			end:BufFrames.kr(buf)
		);
		output = BufRd.ar(1, buf, rphase) * ampenv;
		output = LPF.ar(output, lpf) * amp;
		Out.ar(out, output.dup);
	}).send(s);

	s.sync;

	~vla_grain_numbufs = 8;
	~vla_grain_buf = Array.fill(~vla_grain_numbufs, {
		Buffer.alloc(s, s.sampleRate * 30.0);
	});

	~vla_del_buf = Buffer.alloc(s, s.sampleRate * 10);
	~mic_del_buf = Buffer.alloc(s, s.sampleRate * 10);
	
	s.sync;
	
	~vla_del_s = Synth.new(\bufd_bpf, [
		\buf, ~vla_del_buf.bufnum,
		\in, ~vla_in_b.index,
		\out, 0,
		\hz, 880 * 8/9,
		\delaytime, 15.0/ 51.0,
		\amp, 0.5,
		\fb, 0.2,
	], ~in_g, \addAfter);
	
	~mic_del_s = Synth.new(\bufd_bpf, [
		\buf, ~mic_del_buf.bufnum,
		\in, ~mic_in_b.index,
		\out, 0,
		\hz, 880 * 8/9,
		\delaytime, 10.0 / 51.0,
		\amp, 0.5,
		\fb, 0.2,
	], ~in_g, \addAfter);
	
		
	~doGrain = {
		arg idx, rate=0.25, lpf=440, amp=1.0;
		Synth.new(\shiftgrain, [
			\in, ~vla_in_b.index, 
			\buf, ~vla_grain_buf[idx].bufnum,
			\out, 0,
			\rate, rate,
			\lpf, lpf,
			\amp, amp
		], ~vla_in_s, \addAfter)
	};
	}.play;