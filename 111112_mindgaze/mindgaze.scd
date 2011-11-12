s = Server.local;
c = CfAudioContext.new(s, 2, {
	
	~vla_l_pan = Synth.new(\pan, [\in, c.in_b.index, \out, c.out_b.index], c.xg);
	~vla_r_b = Bus.audio(s, 1);
	~vla_r_pan = Synth.new(\pan, [\in, ~vla_r_b.index, \out, c.out_b.index], c.xg, \addAfter);	~vla_r_del = Synth.new(\delay, [\in, c.in_b.index + 1, \out, ~vla_r_b.index], c.xg);
	~vla_r_lpf = Synth.new(\lpf_ins, [\bus, ~vla_r_b.index, \hz, 6000], c.xg, \addToTail);
	~vla_r_hishelf = Synth.new(\hishelf_ins, [\bus, ~vla_r_b.index, \hz, 2000, \db, -8], c.xg, \addToTail);
	
	SynthDef.new(\modsine, {
		arg out=0, pan=0.0, hz, amp, phase,
			amplag=1.0, hzlag=1.0, phaselag=1.0, 
			hzmodhz, panmodhz, phasemodhz,
			hzmoddepth, panmoddepth, phasemoddepth;
			
			var sig;
			
			hz = Lag.kr(hz, hzlag);
			amp = Lag.kr(amp, amplag);
			phase = Lag.kr(phase, phaselag);
			
			hz = hz * ((1 + SinOsc.kr(hzmodhz, 0, hzmoddepth)));
			phase = phase * ((1 + SinOsc.kr(phasemodhz, 0, phasemoddepth)));
			pan = pan * ((1 + SinOsc.kr(panmodhz, 0, panmoddepth)));
			
			sig = SinOsc.ar(hz, phase, amp);
			Out.ar(out, Pan2.ar(sig, pan));
	}).send(s);
	
	
	SynthDef.new(\modsaw_lpf, {
		arg out=0, pan=0.0, hz, amp, phase, lpf=440, rq=0.5,
			amplag=1.0, hzlag=1.0, 
			hzmodhz, panmodhz, lpfmodhz, rqmodhz,
			hzmoddepth, panmoddepth, lpfmoddepth, rqmoddepth;
			
			var sig;
			
			hz = Lag.kr(hz, hzlag);
			amp = Lag.kr(amp, amplag);
			
			hz = hz * ((1 + SinOsc.kr(hzmodhz, 0, hzmoddepth)));
			pan = pan * ((1 + SinOsc.kr(panmodhz, 0, panmoddepth)));
			lpf = lpf * ((1 + SinOsc.kr(lpfmodhz, 0, lpfmoddepth)));
			rq = rq * ((1 + SinOsc.kr(rqmodhz, 0, rqmoddepth)));
			
			sig = Saw.ar(hz, amp);
			sig = RLPF.ar(sig, lpf, rq);
			Out.ar(out, Pan2.ar(sig, pan));
	}).send(s);
	
	
	s.sync;

	
	~hz = 55 * 8/9;

	~hzmodhz =    [ 1/27, 1/32, 1/46, 1/35 ];
	~phasemodhz = [ 1/27, 1/32, 1/46, 1/35 ].rotate(1) * 3.0;
	~panmodhz = [ 1/27, 1/32, 1/46, 1/35 ].rotate(2) * 2.0;
	
	~sines = List.new;
	~sine_g = Group.new(c.xg);
	
	4.do({ |i| 
		~sines.add(
			Synth.new(\modsine, [
				\hz, ~hz * (2 ** (i % 2)),
				\amp, -24.dbamp,
				\pan, i.linlin(0, 3, -0.7, 0.7),				\hzmodhz, ~hzmodhz.wrapAt(i) / 16,
				\phasemodhz, ~phasemodhz.wrapAt(i) / 6,
				\panmodhz, ~panmodhz.wrapAt(i) * 9/8,
				
				\hzmoddepth, ~panmodhz.wrapAt(i) ** 9/8,
				\phasemoddepth, ~phasemodhz.wrapAt(i) * 6/5,
				\panmoddepth, ~hzmodhz.wrapAt(i) * 24,
				
				\out, c.out_b.index;
			], ~sine_g);
		);
	});
	
	
	~saws = List.new;
	~saw_g = Group.new(c.xg);
	
	5.do({ |i| 
		~saws.add(
			Synth.new(\modsaw_lpf, [
				\hz, ~hz * (2 ** (i % 3)),
				\lpf, ~hz * (2 ** (i % 2)) * 2,
				\amp, -24.dbamp,
				\pan, i.linlin(0, 3, -0.7, 0.7),
				\rq, 0.1,
				
				\hzmodhz, ~hzmodhz.wrapAt(i) / 7,
				\lpfmodhz, ~phasemodhz.wrapAt(i) / 6/5,
				\panmodhz, ~panmodhz.wrapAt(i) / 9/8,
				\rqmodhz, ~panmodhz.wrapAt(i + 1) / 9/8,
				
				\hzmoddepth, ~panmodhz.wrapAt(i) / 8,
				\panmoddepth, ~hzmodhz.wrapAt(i) * 8,
				\lpfmoddepth, ~phasemodhz.wrapAt(i) * 6/5,
				\rqmoddepth, ~phasemodhz.wrapAt(i+1) * 8,
				
				\out, c.out_b.index;
			], ~saw_g);
		);
	});
});