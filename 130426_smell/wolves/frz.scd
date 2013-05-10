Routine {

	SynthDef.new(\rec, {
		arg in=0, buf=0,
		reclevel=1.0, prelevel=0.0, offset=0.0, trig=1.0, loop=0, run=1,
		atk=0.01, rel=0.01, gate=1;
		
		RecordBuf.ar(In.ar(in, 1),
			bufnum: buf, 
			offset:0,
			recLevel:reclevel,
			preLevel:prelevel,
			run:run,
			loop:loop,
			trigger:trig
		);
	}).send(s);

	/// length
	~frLen = 8.0;
	/// count
	~frN = 8;
	// bufs
	~frBuf = Array.fill(~frN, { Buffer.alloc(s, s.sampleRate * ~frLen); });  
	/// synths
	~frRec = Array.fill(~frN, { |i|
		Synth.new(\rec, [
			\in, c.in_b.index,
			\buf, ~frBuf[i].bufnum,
		], c.ig, \addAfter).run(false);
	});
	
	/// recording function, args are index and T/F
	~frz_rec = { arg n, val;
		postln( ["fr_rec", n, val]);
		Routine {  // apply value and reset
			~frRec[n].run(val);
			s.sync;
			~frRec[n].set(\trig, 0);
			s.sync;
			~frRec[n].set(\trig, 1);
			if(val.not, {
				~frBuf[n].normalize;
			});
		}.play;
};

s.sync;




SynthDef.new(\buf_ringz_lpf_env, {
	arg out=0,
		buf=0,
		amp = 1.0,
		ringhz = 200,
		lpfhz = 600,
		pulsehz = 1.0,
		ringmix = 0.5,
		envattack=0.08, envdecay = 5.0,
		ringdecay =  0.01,
		startpos=0.0,
		rate=1.0;
		
	var pulse, player, env, ring, lpf, output;
	
	pulse = Impulse.ar(pulsehz);
	player = PlayBuf.ar(1, buf, rate:rate, trigger:pulse, startPos:startpos, loop:0);
	ring = Ringz.ar(player, ringhz, ringdecay);
	ring = (ring * ringmix) + (player * (1.0 - ringmix));
	lpf = LPF.ar(ring, lpfhz);
	env = Decay2.ar(pulse, envattack, envdecay);
	output = env * lpf * amp;
	Out.ar(out, Pan2.ar(output));
}).send(s);

SynthDef.new(\buf_ringz_dist_hpf_env, {
	arg out=0,
		buf=0,
		amp = 1.0,
		ringhz = 1600,
		hpfhz = 800,
		pulsehz = 1.0,
		ringmix = 0.5,
		distmix = 0.5,
		envattack=0.08, envdecay = 5.0,
		ringdecay =  0.001,
		startpos=0.0,
		rate=1.0;
	var pulse, player, env, ring, dist, hpf, output;
	pulse = Impulse.ar(pulsehz);
	player = PlayBuf.ar(1, buf, rate:rate, trigger:pulse, startPos:startpos, loop:0);
	ring = Ringz.ar(player, ringhz, ringdecay);
	ring = (ring * ringmix) + (player * (1.0 - ringmix));
	dist = ring.distort.distort;
	dist = (dist * distmix) + (ring * (1.0 - distmix));
	hpf = HPF.ar(ring, hpfhz);
	env = Decay2.ar(pulse, envattack, envdecay);
	output = env * hpf * amp;
	Out.ar(out, Pan2.ar(output));
}).send(s);



}.play;

/*
~frBuf.do({ arg buf; buf.plot; });

*/




