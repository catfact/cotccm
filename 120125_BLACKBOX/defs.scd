
SynthDef.new(\bufdelay_bpf_fb_pan, {
	arg in=0, 
		out=0,
		buf=0,
		amp = 1.0,
		in_amp = 1.0,
		time= 1.0,
		fb = 0.0,
		bpf_mix = 0.0,
		bpf_hz = 400,
		bpf_rq = 0.9,
		pan = 0.0,
		
		amp_lag=0.1,
		in_amp_lag=0.1,
		time_lag=0.01,
		fb_lag = 0.1,
		bpf_mix_lag = 0.1,
		bpf_hz_lag = 0.1,
		bpf_rq_lag = 0.1,
		pan_lag = 0.1,
		
		dummy = 0;
		
	var delay, bpf;
	
	amp = Lag.kr(amp, amp_lag);
	in_amp = Lag.kr(in_amp, in_amp_lag);
	fb = Lag.kr(fb, fb_lag);
	time = Lag.kr(time, time_lag);
	bpf_mix = Lag.kr(bpf_mix, bpf_mix_lag);
	bpf_hz = Lag.kr(bpf_hz, bpf_hz_lag);
	bpf_rq = Lag.kr(bpf_rq, bpf_rq_lag);
	pan = Lag.kr(pan, pan_lag);
	
	delay = BufDelayL.ar(buf, (In.ar(in) * in_amp) + (LocalIn.ar(1)), time) * amp;
	bpf = BPF.ar(delay, bpf_hz, bpf_rq);
	delay = delay * (1.0 - bpf_mix) + (bpf_mix * bpf);
	LocalOut.ar(delay * fb);
	Out.ar(out, Pan2.ar(delay * amp, pan));
	
}).send(s);




SynthDef.new(\chopgrain_1shot, {
	arg buf, out=0, level=1.0,
	rate=1.0, choprate=1.0, posrate=0.25,
	atk=1.0, rel=1.0, gate=1,
	minframes=0, maxframes=44100,
	dur=4.0, posphase=0.0;
	
	var ampenv, pos, trig, phase, read,
	sr, frames, ratescale, framediff;
	
	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	framediff = maxframes - minframes;
	
	ampenv = EnvGen.ar(Env.linen(atk, dur, rel), gate:gate, doneAction:2);
	
	trig = Impulse.ar(choprate);
	
	pos = LFSaw.kr(posrate / framediff * sr, posphase, framediff, minframes).wrap(minframes, maxframes - (sr / choprate));
	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:1);
	
	Out.ar(out, (read * ampenv * level * 0.6).dup);
}).send(s);



SynthDef.new(\justloop_play, {
	arg out=0, buf=0,
	pos=0.0, rate=1.0, loop=0,
	atk=0.01, dur=10.0, rel=0.01, gate=1, doneaction=2,
	looptime=2.0, level=0.63,
	ratelag=0.01, pan=0.0,
	shift_ratio=0.5, shift_amp=0.0, shift_amplag=1.0, shift_window=0.125;
	
	var sig, amp, env, trig, shift;
	
	env = Env.asr(atk, 1.0, rel);
	amp = EnvGen.ar(env, gate, doneAction:doneaction);
	trig = Impulse.kr(1.0 / looptime);
	rate = Lag.kr(rate, ratelag);
	sig = PlayBuf.ar(1, buf, rate, trig, pos, loop:loop);
	
	shift_amp = Lag.kr(shift_amp, shift_amplag);
	shift = PitchShift.ar(sig, shift_window, shift_ratio);
	sig = sig + (shift * shift_amp);
	
	Out.ar(out, Pan2.ar(sig * amp * level, pan));
}).send(s);


SynthDef.new(\cmpcho, {
	arg in, out, time, maxtime=1.0, amp=1.0,
		thresh=0.125, slopebelow=4.0, slopeabove=1.0, clamp=0.7, relax=0.3;
	var input, del;
	input = In.ar(in);
	del =  DelayL.ar(input, maxtime, time);
	del = Compander.ar(del, input, thresh, slopebelow, slopeabove, clamp, relax);
	Out.ar(out, del * amp);
}).send(s);

SynthDef.new(\adc, {arg in=0, out=0, amp=1, amplag = 0.01;
	var sig;
	amp = Lag.kr(amp, amplag);
	sig = SoundIn.ar(in);
	Out.ar(out, sig * amp);
}).send(s);

SynthDef.new(\echo_buf, {
	arg buf, in, out, time, amp=1.0;
	Out.ar(out, BufDelayL.ar(buf, In.ar(in), time, amp));
}).send(s);



SynthDef.new(\crumblr_over_s, {
	arg in=0, out=0, amp=0.0, amplag = 10.0,
		thresh= 0.0, stretch=1.0, shift = 0.0,
		delaytime = 0.0;

	var chain, output;
	
	amp = Lag.kr(amp, amplag);
	
	chain = FFT(LocalBuf(2048, 2), In.ar(in, 2));
	chain = PV_MagAbove(chain, thresh);
	chain = PV_BinShift(chain, stretch, shift);
	output = DelayL.ar(IFFT(chain), 2.0, delaytime);
	Out.ar(out, output.dup * amp);
}).send(s);

SynthDef.new(\crumblr_under_s, {
	arg in=0, out=0, amp=0.0, amplag = 10.0,
		thresh= 0.0, stretch=1.0, shift = 0.0,
		delaytime = 0.0;

	var chain, output;
	
	chain = FFT(LocalBuf(2048, 2), In.ar(in, 2));
	chain = PV_MagBelow(chain, thresh);
	chain = PV_BinShift(chain, stretch, shift);
	amp = Lag.kr(amp, amplag);
	output = DelayL.ar(IFFT(chain), 2.0, delaytime);
	Out.ar(out, output.dup * amp);
}).send(s);



SynthDef.new(\norm_rec, {arg input, buf, norm_dur=1.0, run=1, loop=0; 
	RecordBuf.ar(Normalizer.ar(SoundIn.ar(input), norm_dur), buf, run:run, loop:loop);
}).load(s);

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



 SynthDef.new(\bufdelay, {
	arg in=6, 
		out=0,
		buf=0,
		buflength = 1.0,
		amp = 1.0,
		amplag = 0.0,
		inputamp = 1.0,
		delaytime= 1.0,
		feedback = 0.0;
	var delay, fb;
	amp = Lag.kr(amp, amplag);
	delay = BufDelayL.ar(buf, In.ar(in) * inputamp, delaytime) * amp;
	fb = RecordBuf.ar(delay, buf, recLevel:feedback, preLevel:1.0, loop:1);
	Out.ar(out, (delay * amp).dup );
}).send(s);


SynthDef.new(\bufdelay_fb, {
	arg in=6, 
		out=0,
		buf=0,
		buflength = 1.0,
		amp = 1.0,
		inputamp = 1.0,
		delaytime= 1.0,
		feedback = 0.0;
	var delay, fb;
	delay = BufDelayL.ar(buf, (In.ar(in) * inputamp) + (LocalIn.ar(1)), delaytime) * amp;
	LocalOut.ar(delay * feedback);
	Out.ar(out, (delay * amp).dup );

}).send(s);

SynthDef.new(\in_hw, { arg in=0, out=0, amp=1.0;
	Out.ar(out, SoundIn.ar(in) * amp);
}).send(s);

SynthDef.new(\patch, { arg in=0, out=0, amp=1.0;
	Out.ar(out, In.ar(in) * amp);
}).send(s);


SynthDef.new(\adc_patch, { arg in=0, out=0, amp=1.0;
	Out.ar(out, SoundIn.ar(in) * amp);
}).send(s);


SynthDef.new(\patch_s, { arg in=0, out=0, amp=1.0;
	Out.ar(out, In.ar(in, 2) * amp);
}).send(s);


SynthDef.new(\in_pan, { arg in=0, out=0, amp=1.0, pan=0.0;
	Out.ar(out, Pan2.ar(In.ar(in) * amp, pan));
}).send(s);


SynthDef.new(\in_fb, { arg in=0, out=0, amp=1.0;
	Out.ar(out, InFeedback.ar(in) * amp);
}).send(s);	


SynthDef.new(\god_vox, {
	argÊin=1, out=0, amp=1.0,
	verb_mix=0.24, verb_room=0.8, verb_damp=1.0,
	delaydc = 0.002,
	delaytime = 0.1,
	delaylpf = 1200,
	delayamp = 0.4,
	gate_thresh = 0.00001,
	gate_slope = 10.0,
	gate_clamp = 0.004, 
	gate_release = 0.05,
	comp_thresh = 0.5,
	comp_slope = 0.25,
	comp_clamp = 0.003,
	comp_release = 0.1;
	var input, gate, comp, eq, del, verb;
	
	input = SoundIn.ar(in);
	
	gate = Compander.ar(input, input, gate_thresh, gate_slope, 1.0, gate_clamp, gate_release);
	comp = Compander.ar(gate, input, comp_thresh, 1.0, comp_slope, comp_clamp, comp_release);
//	comp = Compander.ar(input, input, comp_thresh, 1.0, comp_slope, comp_clamp, comp_release);

	del = DelayL.ar(comp, 1.0, delaytime);
	del = LPF.ar((del + DC.ar(delaydc)).softclip, delaylpf) * delayamp;

	verb = FreeVerb.ar(comp + del, verb_mix, verb_room, verb_damp);
//	verb = FreeVerb.ar(input, verb_mix, verb_room, verb_damp);
//	verb = FreeVerb.ar(gate, verb_mix, verb_room, verb_damp);	
	Out.ar(out, Pan2.ar(verb * amp));
}).send(s);

SynthDef.new(\metro, {arg out=0, amp=0.25, lpfhz=600, ringhz=100, impulsehz=1.0, ringtime=2.0;
	Out.ar(out, Pan2.ar(LPF.ar(Ringz.ar(Impulse.ar(impulsehz), ringhz, ringtime), lpfhz)) );
}).send(s);







//////
/////

///


SynthDef.new(\pitch, { arg in=0, out=0;
		Out.kr(out, Pitch.kr(In.ar(in, 1)));
	}).send(s);
	
	SynthDef.new(\patch_pan, {arg in=0, out=0, amp=1.0, pan=0.0;
		Out.ar(out, Pan2.ar(In.ar(in, 1), pan));
	}).send(s);
	
	SynthDef.new(\record, {arg in=0, buf=0, run=0, reclevel=1.0, prelevel=0.0, loop=1, off=0.0, trig=0;
		RecordBuf.ar(In.ar(in, 1), buf, off ,reclevel, prelevel, run, loop, trig);
	}).send(s);
	
	SynthDef.new(\record_adc, {arg in=0, buf=0, run=0, reclevel=1.0, prelevel=0.0, loop=1, off=0.0, trig=0;
		RecordBuf.ar(SoundIn.ar(in, 1), buf, off, reclevel, prelevel, run, loop, trig);
	}).send(s);
	
	SynthDef.new(\record_stereo, {arg in=0, buf=0, run=0, reclevel=1.0, prelevel=0.0, loop=1, off=0.0, trig=0;
		RecordBuf.ar(In.ar(in, 2), buf, off ,reclevel, prelevel, run, loop, trig);
	}).send(s);
	
	SynthDef.new(\gaterecord_adc, {arg in=0, buf=0, run=0, reclevel=1.0, prelevel=0.0, loop=1, off=0.0, trig=0, releasetime=0.1, thresh=0.1;
		var input, amp, gate;
		input = SoundIn.ar(in, 1);
		amp = Amplitude.kr(in);
		gate = LagUD.kr(amp, 0.0, releasetime) > thresh; 
		RecordBuf.ar(input, buf, off, reclevel, prelevel, gate * run, loop, trig);
	}).send(s);
	
	
	SynthDef.new(\phasegrain, {
		arg out=0, buf=0, grainrate=10.0, graindur=10.0,
			posrate=0.1, posrand=0.01,
			phasemin=0.0, phasemax=1.0,
			resetpos=0.0, trig=0,
			pitch=1.0, pitchpitch=2.0, pitchpitchblend=0.1,
			pitchgrainsize=0.5,
			pannoiserate=4.0, pannoisewidth=0.2, pannoisecenter=0.0,
			attack=10.0, release=10.0, level=0.1, gate=1;
			
		var pos, pulse, dur, bufdur, pan, grains, pitched, amp;
		
		bufdur = BufDur.kr(buf);
		dur = graindur / grainrate;
		pulse = Impulse.kr(grainrate);
		pos = Phasor.kr(
			trig,
			posrate / bufdur,
			0.0,
			2.0 * bufdur,
			resetpos
		);
		amp = amp = LagUD.kr(level, attack, release); // Linen.kr(gate, attack, release) * level;
		FreeSelf(amp);
		pos = pos + TRand.kr(0, 0.01, pulse);
		pos = pos.fold(phasemin * bufdur, phasemax * bufdur);
		pan = LFNoise0.kr(pannoiserate, pannoisewidth, pannoisecenter).wrap(-1, 1);
		grains =  TGrains.ar(2, pulse, buf, pitch, pos, dur, pan, 0.1);
		pitched = PitchShift.ar(grains, pitchgrainsize, pitchpitch);
		Out.ar(out, amp * (grains + (pitched * pitchpitchblend)));
		FreeSelf.kr(amp.max(gate));
	}).send(s);

	// linear interp
	SynthDef.new(\rawscl, {
		arg out=0, hz=220, hz_off=0.25, crate=2.0,
			level=0.0,
			dst=2.0,
			gate=1,attack=100, release=60,
			k=1.0, klag=60, lpfhz=220,
			limthresh=1.0, limgain=1.0;
		var amp, output,
			ampnoise, hznoise1, hznoise2,
			lagk, lagc, laghz, laglpfhz;
		amp = LagUD.kr(level, attack, release);
		lagk = Lag.kr(k, klag);
		lagc = Lag.kr(crate, klag);
		laghz= Lag.kr(hz, klag);
		laglpfhz = Lag.kr(lpfhz, klag);
		ampnoise = LPF.ar(StandardL.ar(hz * lagc, lagk), laglpfhz);
		hznoise1 = LPF.ar(StandardL.ar(lagc, lagk), laglpfhz);
		hznoise2 = LPF.ar(StandardL.ar(lagc, lagk), laglpfhz);
		output = ring1(SinOsc.ar([laghz, laghz + hz_off]), ampnoise)
			+ (SinOsc.ar([laghz + (hznoise1*hz_off), hz - (hznoise2*hz_off)]) * Lag.kr(dst, klag)).distort;
		output = output * amp;
		Out.ar(out, Compander.ar(output, output, limthresh, 1.0, 0.0, 0.001, 0.04, limgain));
		FreeSelf.kr(amp.max(gate));
	}).send(s);

	// no interp
	SynthDef.new(\rawscn, {
		arg out=0, hz=220, hz_off=0.25, crate=2.0,
			level=0.0,
			dst=2.0,
			gate=1,attack=100, release=60,
			k=1.0, klag=60, lpfhz=2220,
			limthresh=1.0, limgain=1.0;
		var amp, output,
			ampnoise, hznoise1, hznoise2,
			lagk, lagc, laghz, laglpfhz;
		amp = LagUD.kr(level, attack, release);
		lagk = Lag.kr(k, klag);
		lagc = Lag.kr(crate, klag);
		laghz= Lag.kr(hz, klag);
		laglpfhz = Lag.kr(lpfhz, klag);
		ampnoise = LPF.ar(StandardN.ar(hz * lagc, lagk), laglpfhz);
		hznoise1 = LPF.ar(StandardN.ar(lagc, lagk), laglpfhz);
		hznoise2 = LPF.ar(StandardN.ar(lagc, lagk), laglpfhz);
		output = ring1(SinOsc.ar([laghz, laghz + hz_off]), ampnoise)
			+ (SinOsc.ar([laghz + (hznoise1*hz_off), hz - (hznoise2*hz_off)]) * Lag.kr(dst, klag)).distort;
		output = output * amp;
		Out.ar(out, Compander.ar(output, output, limthresh, 1.0, 0.0, 0.001, 0.04, limgain));
		FreeSelf.kr(amp.max(gate));
	}).send(s);
	
	/*
	SynthDef.new(\rawsc, {
		arg out=0, hz=220, hz_off=0.25, crate=2.0, level=0.0, timescale=60.0, dst=2.0, gate=1, k=1.0, klag=60;
		var amp, output, ampnoise, hznoise1, hznoise2, lagk, lagc;
		amp = Lag.kr(level, timescale);
		lagk = Lag.kr(k, klag);
		lagc = Lag.kr(crate, klag);
		ampnoise = StandardL.ar(hz * lagc, lagk);
		hznoise1 = StandardL.ar(lagc, lagk);
		hznoise2 = StandardL.ar(lagc, lagk);
		output = ring1(SinOsc.ar([hz, hz + hz_off]), ampnoise) + (SinOsc.ar([hz + (hznoise1*hz_off), hz - (hznoise2*hz_off)]) * Lag.kr(dst, klag)).distort;
		Out.ar(out, output * amp);
	}).send(s);
	*/