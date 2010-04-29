s = Server.local;
s.boot;
s.freeAll;

~norm_buf = Buffer.alloc(s, 10.0 * s.sampleRate, 1);

SynthDef.new(\norm_rec, {arg input, buf, norm_dur=1.0, run=1, loop=0; 
	RecordBuf.ar(Normalizer.ar(SoundIn.ar(input), norm_dur), buf, run:run, loop:loop);
}).load(s);

//~rec_norm_s = { RecordBuf.ar(Normalizer.ar(SoundIn.ar(1), 1.0), ~norm_buf.bufnum) }.play;
~rec_norm_s = Synth.new(\norm_rec, [\input, 1, \buf, ~norm_buf.bufnum; ]);
SystemClock.sched(~norm_buf.duration + 0.01, { ~rec_norm_s.free; nil });

~norm_buf.plot;

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
}).load(s);

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
}).load(s);


x = Synth.new(\buf_ringz_lpf_env, [
	\buf, ~norm_buf.bufnum,
	\pulsehz, (0.5 / 1.2),
	\lpfhz, 55.midicps,
	\ringhz, 43.midicps,
	\rate, 0.5,
	\ringdecay, 0.007,
	\amp, -12.dbamp
]);

/*
x.free;
*/

y = Synth.new(\buf_ringz_dist_hpf_env, [
	\buf, ~norm_buf.bufnum,
	\pulsehz, (0.125 / 1.2),
	\hpfhz, 55.midicps,
	\ringhz, 69.midicps,
	\rate, 1.0,
	\ringdecay, 0.007,
	\envattack, 6.0,
	\amp, -12.dbamp
]);

/*

y.free;

*/

x.free;

z  = {Out.ar(0, Pan2.ar(SinOsc.ar(220) * (-12.dbamp) )) }.play;
z.free;