//s = Server.internal;

//s.waitForBoot{

SynthDef.new(\limit_insert_s, { arg bus=0, mix=1.0, controlin = -1, mixlag=0.01, limthresh=0.4, amp=0.08, preamp=1.0;
	var inp, inctl, lim;
	if (controlin == -1, {controlin = bus});
	inp = In.ar([bus, bus+1]) * preamp;
	inctl = In.ar([controlin, controlin+1]) * preamp;
	lim = Compander.ar(inp, inctl, thresh:limthresh, slopeBelow:1.0, slopeAbove: 0.01, clampTime:0.01, relaxTime:0.01);
	lim = lim * (1.0 / limthresh) * amp;
	mix = Lag.kr(mix, mixlag);
	ReplaceOut.ar(bus, (lim*mix) + (inp*(1.0-mix)));
}).load(s);


SynthDef.new(\limit_insert, { arg bus=0, mix=1.0, controlin = -1, mixlag=0.01, limthresh=0.4, clamptime=0.01, relaxtime=0.01, amp=0.08, preamp=1.0;
	var inp, inctl, lim;
	if (controlin == -1, {controlin = bus});
	inp = In.ar(bus) * preamp;
	inctl = In.ar(controlin) * preamp;
	lim = Compander.ar(inp, inctl, thresh:limthresh, slopeBelow:1.0, slopeAbove: 0.01, clampTime:clamptime, relaxTime:relaxtime);
	lim = lim * (1.0 / limthresh) * amp;
	mix = Lag.kr(mix, mixlag);
	ReplaceOut.ar(bus, (lim*mix) + (inp*(1.0-mix)));
}).load(s);



SynthDef.new(\rlpf_insert_s, { arg bus=0, mix=1.0, freq=100, rq=0.05, freqlag=0.01, rqlag=0.01;
	var inp, lpf;
	inp = In.ar([bus, bus+1]);
	lpf = RLPF.ar(inp, Lag.kr(freq, freqlag), Lag.kr(rq,rqlag));
	ReplaceOut.ar(bus, (lpf*mix) + ( inp* (1.0 - mix)));
}).load(s);

SynthDef.new(\patch, { arg in = 0, out=0, amp = 1.0, amplag = 0.01;	Out.ar(out, In.ar(in) * Lag.kr(amp, amplag));
}).load(s);

SynthDef.new(\patch_s, { arg in = 0, out=0, amp = 1.0, amplag = 0.01;	Out.ar(out, In.ar([in, in+1]) * Lag.kr(amp, amplag));
}).load(s);

SynthDef.new(\patch_pan, { arg in = 0, out=0, amp = 1.0, amplag = 0.01, pan=0.0, panlag=0.01;	Out.ar(out, Pan2.ar(In.ar(in) * Lag.kr(amp, amplag), Lag.kr(pan, panlag)));
}).load(s);

SynthDef.new(\adc_patch_s, { arg in = 0, out=0, amp = 1.0, amplag = 0.01;	Out.ar(out, SoundIn.ar([in, in+1]) * Lag.kr(amp, amplag));
}).load(s);

SynthDef.new(\adc_patch, {arg in=0, out=0, amp=1, amplag = 0.01;
	var sig;
	amp = Lag.kr(amp, amplag);
	sig = SoundIn.ar(in);
	Out.ar(out, sig * amp);
}).load(s);

SynthDef.new(\rec, {arg in=0, buf=0, reclevel=1.0, prelevel=0.0, offset=0.0, trig=1.0, loop=0, run=1;
	RecordBuf.ar(In.ar(in, 1),
		bufnum: buf, 
		offset:0,
		recLevel:reclevel,
		preLevel:prelevel,
		run:run,
		loop:loop,
		trigger:trig
	);
}).load(s);

SynthDef.new(\play, {arg out=0, buf=0, trig=0, dur=1.0, rate=1.0, loop=0;
	var sig, amp, env;
	env = Env.linen(0.01, 1.0, 0.01);
	amp = EnvGen.ar(env, trig, timeScale:dur);
	sig = PlayBuf.ar(1, buf, rate, trig, loop:loop);
	Out.ar(out, sig * amp);
}).load(s);

SynthDef.new(\mousex, { arg out, minval=0.0, maxval=1.0, warp=0.0;
	Out.kr(out, MouseX.kr(minval, maxval, warp));
}).load(s);


SynthDef.new(\mousey, { arg out, minval=0.0, maxval=1.0, warp=0.0;
	Out.kr(out, MouseX.kr(minval, maxval, warp));
}).load(s);


SynthDef.new(\amp, { arg in=0, out=0, attackTime = 0.01, releaseTime = 0.01, mul = 1.0, add = 0.0;
	Out.kr(out, Amplitude.kr(In.ar(in), attackTime, releaseTime, mul, add));
}).load(s);

SynthDef.new(\amp_s, { arg in=0, out=0, attackTime = 0.01, releaseTime = 0.01, mul = 1.0, add = 0.0;
	Out.kr(out, Amplitude.kr(In.ar([in, in+1]), attackTime, releaseTime, mul, add));
}).load(s);

SynthDef.new(\schmidt, { arg in=0, out=0, lo=0, hi=1; 
	Out.kr(out, Schmidt.kr(In.ar(in), lo, hi));
}).load(s);


SynthDef.new(\sine_chop, {arg bus=0, hi=0.15, range=0.125, tune=1.0, attack=0.02, release=0.03, osc_lag=0.05, lpf_hz=3000, hpf_hz=30, mix=1.0, osc_amp=0.1; 
	var inrange, osc, pitch, input, lo, haspitch;
	lo = hi * range;
	input = In.ar(bus, 1);
	inrange = InRange.kr(Amplitude.kr(input, attack, release), lo, hi);
	inrange = Lag.kr(inrange, osc_lag);
	//inrange = inrange * mix_range;
	#pitch, haspitch = Pitch.kr(LPF.ar(HPF.ar(input, hpf_hz), lpf_hz)) * tune;
	inrange = inrange.max(haspitch);
	osc = SinOsc.ar(pitch) * osc_amp;
	//osc = SinOsc.ar(Pitch.kr(input)) * Amplitude.kr(input);
	ReplaceOut.ar(bus, mix*((input * (1.0 - inrange)) + (osc*inrange)) + ((1.0-mix)*input));
}).load(s);

SynthDef.new(\centroid_delay, {arg in=0, out=0, delaytime=1.0, maxdelaytime=10.0, mul=1.0, add=0.0, buf=0;
	var chain, input;
	input = In.ar(in, 1);
	chain = FFT(buf, input);
	Out.kr(out, DelayN.kr(SpecCentroid.kr(chain), maxdelaytime, delaytime, mul, add));
}).load(s);

SynthDef.new(\play_loop_trig, {arg out=0, buf=0, trig=0, dur=1.0, rate=1.0, loop=1.0, startpos=0.0;
	trig = trig + Impulse.kr(1.0 / dur);
	Out.ar(out, PlayBuf.ar(1, buf, rate, trig, startpos, loop));
}).load(s);


SynthDef.new(\vorg_1shot, 
{	arg out=0, timbre1_0, timbre1_1, timbre2_0, timbre2_1, timbre3_0, timbre3_1, freq=440, gate=1, level=0.1, attack=0.1, release=0.1, dur=10, filter_level=0.0, noise_level = 0.0, sub_level=1.0, numbufs=4, basebuf=0, pan=0.0;
	var timbre1, timbre2, timbre3, sin, saw, ring, saws, amp, saw_amp, env, noise, filter;
	timbre1 = Lag.kr(timbre1_0, dur*0.0625);
	timbre2 = Lag.kr(timbre2_0, dur*0.0625);
	timbre3 = Lag.kr(timbre3_0, dur*0.0625);
//	freq = Lag.kr(freq, attack * 0.125);
	env = Env.linen(attack, dur, release, 1, 'lin');
	amp = EnvGen.ar(env, gate, timeScale:1); //, doneAction:2);
//	amp = LagUD.kr(level, attack, release);
	saw_amp = EnvGen.ar(env, gate, timeScale:2.0);
	//rq = 5.5 - EnvGen.ar(env, gate, 4.0, 0, 2.4); 
	saw = SyncSaw.ar(freq, freq * (2 ** (3 * timbre2)));
	sin = Mix.new([VOsc.ar((timbre1 * numbufs) + basebuf), FSinOsc.ar(freq * 0.5) * sub_level]);
	ring = sin * saw;
	saws = Mix.new([saw * timbre3, ring * timbre3]) * saw_amp;
	noise = LFNoise2.ar(freq * 64, sin + saws) * noise_level;
	level = Lag.kr(level, attack);
	filter = LPF.ar(Mix.new([sin, saws, noise]), freq + (filter_level * (9000-freq)));
	Out.ar(out, Pan2.ar(filter * amp * level, pan));
}).load(s);


SynthDef.new(\phasegrain, {
	arg out=0, buf=0, grainrate=10.0, graindur=10.0,
		posrate=0.1, posrand=0.01,
		phasemin=0.0, phasemax=1.0,
		resetpos=0.0, trig=0,
		pitch=1.0, pitchpitch=2.0, pitchpitchblend=0.1,
		pitchgrainsize=0.5,
		pannoiserate=4.0, pannoisewidth=0.2, pannoisecenter=0.0,
		attack=10.0, release=30.0, level=0.1, gate=1; //bufdur = 10.0;
		
	var pos, pulse, dur,
	 bufdur, bufframes,
	 pan, grains, pitched, amp;
	
	// pass as argument
	bufdur = BufDur.kr(buf); 
	bufframes = BufFrames.kr(buf);
	dur = graindur / grainrate;
	pulse = Impulse.kr(grainrate);
	pos = Phasor.kr(
		trig,
		posrate,
		0.0,
		2.0 * bufdur,
		resetpos
	);
	
	pitchpitch= Lag.kr(pitchpitch, 14.0);
	
	amp = LagUD.kr(level, attack, release); // Linen.kr(gate, attack, release) * level;
	//FreeSelf(amp);
	pos = pos + TRand.kr(0, 0.01, pulse);
	pos = pos.fold(phasemin * bufdur, phasemax * bufdur);
	pan = LFNoise0.kr(pannoiserate, pannoisewidth, pannoisecenter).wrap(-1, 1);
	grains =  TGrains.ar(2, pulse, buf, pitch, pos, dur, pan, 0.1);
	pitched = PitchShift.ar(grains, pitchgrainsize, pitchpitch);
	Out.ar(out, amp * (grains + (pitched * pitchpitchblend)));
	//FreeSelf.kr(amp.max(gate));
}).load(s);

SynthDef.new(\norm_loop_filt, {
	arg out=0, buf=0, amp = -24.dbamp,
		hz=100.0,
		rq=0.4,
		mix=1.0,
		amp_lag_u = 0.1,
		amp_lag_d = 0.1,
		hz_lag_u = 0.1,
		hz_lag_d= 0.1,
		rq_lag_u= 0.1,
		rq_lag_d= 0.1,
		mix_lag_u= 0.1,
		mix_lag_d= 0.1,
		rate=1, trigger=1, startpos=0, loop=1,
		norm_dur_1=0.01,
		norm_dur_2= 0.014,
		norm_dur_3= 0.013,
		norm_dur_4= 0.021;
		
		var pb, filt;
		
		amp = LagUD.kr(amp, amp_lag_u, amp_lag_d);
		hz = LagUD.kr(hz, hz_lag_u, hz_lag_d);
		rq = LagUD.kr(rq, rq_lag_u, rq_lag_d);
		mix = LagUD.kr(mix, mix_lag_u, mix_lag_d);
		
		pb = PlayBuf.ar(1, buf, rate, trigger, startpos, loop);
//		pb = Mix.new(Normalizer.ar(pb, 1.0, [norm_dur_1, norm_dur_2]));
		pb = Normalizer.ar(pb, 1.0, norm_dur_1);
		filt = pb*(1.0 - mix) + (mix * Resonz.ar(pb, hz, rq));
//		filt = Mix.new(Normalizer.ar(filt, 1.0, [norm_dur_3, norm_dur_4]));
		filt = Normalizer.ar(filt, 1.0, norm_dur_2);
		Out.ar(out, filt * amp);
		
}).load(s);


SynthDef.new(\norm_loop_filt_pan, {
	arg out=0, buf=0, amp = -24.dbamp,
		hz=100.0,
		rq=0.4,
		mix=1.0,
		amp_lag_u = 0.1,
		amp_lag_d = 0.1,
		hz_lag_u = 0.1,
		hz_lag_d= 0.1,
		rq_lag_u= 0.1,
		rq_lag_d= 0.1,
		mix_lag_u= 0.1,
		mix_lag_d= 0.1,
		rate=1, trigger=1, startpos=0, loop=1,
		norm_dur_1=0.01,
		norm_dur_2= 0.014,
		norm_dur_3= 0.013,
		norm_dur_4= 0.021,

		pan=0.0,
		pan_lag = 0.1;
		
		var pb, filt;
		
		amp = LagUD.kr(amp, amp_lag_u, amp_lag_d);
		hz = LagUD.kr(hz, hz_lag_u, hz_lag_d);
		rq = LagUD.kr(rq, rq_lag_u, rq_lag_d);
		mix = LagUD.kr(mix, mix_lag_u, mix_lag_d);
		
		pb = PlayBuf.ar(1, buf, rate, trigger, startpos, loop);
//		pb = Mix.new(Normalizer.ar(pb, 1.0, [norm_dur_1, norm_dur_2]));
		pb = Normalizer.ar(pb, 1.0, norm_dur_1);
		filt = pb*(1.0 - mix) + (mix * Resonz.ar(pb, hz, rq));
//		filt = Mix.new(Normalizer.ar(filt, 1.0, [norm_dur_3, norm_dur_4]));
		filt = Normalizer.ar(filt, 1.0, norm_dur_2);
		Out.ar(out, Pan2.ar(filt * amp, Lag.kr(pan, pan_lag)));
		
}).load(s);


////////// analysis
SynthDef.new(\amp, { arg in=0, out=0, attack=0.01, release=0.01; 
	Out.kr(out, Amplitude.kr(In.ar(in), attack, release));
}).load(s);


SynthDef.new(\pitch, { arg in=0, out=0; // output should be 2 channels
	Out.kr(out, Pitch.kr(In.ar(in)));
}).load(s);

SynthDef.new(\centroid, { arg in=0, out=0, buf=0;
	var chain, centroid;
	
	chain = FFT(buf, In.ar(in));
	centroid = SpecCentroid.kr(chain);
//	centroid.poll;
	Out.kr(out, centroid);
}).load(s);


SynthDef.new(\flatness, { arg in=0, out=0, buf=0;
	var chain, centroid;
	chain = FFT(LocalBuf(2048, 1), In.ar(in));
	centroid = SpecFlatness.kr(chain);
//	centroid.poll;
	Out.kr(out, centroid);
}).load(s);



/////////// delay

SynthDef.new(\bufd, {arg in=0, out=0, buf=0, time=1.0, amp=1.0, fbamp=0.0, inamp=1.0, amplag=1.0;
	var input = SoundIn.ar(in) + (LocalIn.ar(1) * fbamp);
	var delay;
	amp = Lag.kr(amp, amplag);
	delay = BufDelayC.ar(buf, input*inamp, time);
	LocalOut.ar(delay);
	Out.ar(out, delay * amp);
}).load(s);


SynthDef.new(\bufd_killattack, {
	arg in=0, out=0, buf=0, time=1.0, amp=1.0, fbamp=0.0, inamp=1.0, amplag=1.0,
		attack = 2.0, release=0.2, thresh = -24.dbamp, shorttime=0.13, shortamp=0.4;
	var input = SoundIn.ar(in) + (LocalIn.ar(1) * fbamp);
	var delay;
	var theamp;
	amp = Lag.kr(amp, amplag);
	
	theamp = Amplitude.kr(input);
	theamp = LagUD.kr(InRange.kr(theamp, thresh), attack, release);
	
	delay = BufDelayC.ar(buf, input*inamp * theamp, time);
	delay = delay + (DelayN.ar(delay, 1.0, shorttime) * shortamp);
	LocalOut.ar(delay);
	Out.ar(out, delay * amp);
}).load(s);


SynthDef.new(\bufdb, {arg in=0, out=0, buf=0, time=1.0, amp=1.0, fbamp=0.0, inamp=1.0, amplag=1.0;
	var input = In.ar(in) + (LocalIn.ar(1) * fbamp);
	var delay;
	amp = Lag.kr(amp, amplag);
	delay = BufDelayC.ar(buf, input*inamp, time);
	LocalOut.ar(delay);
	Out.ar(out, delay * amp);
}).load(s);

SynthDef.new(\bufd_svf, {
	arg in=0, out=0, buf=0, amp=1.0,
	delaytime=1.0,
	hzbus=0, hzmul=1.0, hzadd=0.0, hzdelay,
	hzlag=0.01,
	res=0.0,
	low=1.0, band=1.0, high=0.0, notch=0.0, peak=0.0,
	fb=0.0;
	
	var input, hz, del, output;
	
	fb = fb.min(0.8);
	
	input = In.ar(in) + (LocalIn.ar(1) * fb);
	del = BufDelayL.ar(buf, input, delaytime);
	
	hz = Lag.kr(In.kr(hzbus), hzlag, hzmul, hzadd);
	hz = DelayL.kr(hz, 10.0, hzdelay);
	
	output = SVF.ar(del, hz, res, low, band, high, notch, peak);
	
	LocalOut.ar(output);
	Out.ar(out, output * amp);
}).load(s);



SynthDef.new(\bufd_svf_pan, {
	arg in=0, out=0, buf=0, amp=1.0,
	delaytime=1.0,
	hzbus=0, hzmul=1.0, hzadd=0.0, hzdelay,
	hzlag=0.01,
	res=0.0,
	low=1.0, band=1.0, high=0.0, notch=0.0, peak=0.0,
	fb=0.0,
	pan=0.0;
	
	var input, hz, del, output;
	
	fb = fb.min(0.7);
	
	input = In.ar(in) + (LocalIn.ar(1) * fb);
	del = BufDelayL.ar(buf, input, delaytime);
	
	hz = Lag.kr(In.kr(hzbus), hzlag, hzmul, hzadd);
	hz = DelayL.kr(hz, 10.0, hzdelay);
	
	output = SVF.ar(del, hz, res, low, band, high, notch, peak);
	
	LocalOut.ar(output);
	Out.ar(out, Pan2.ar(output * amp, pan));
}).load(s);


// 
SynthDef.new(\sine_pitchbus, {
	arg out=0, pitchbus=0, ampbus=0, 
		tune=1.0, level=1.0, 
		ampthresh = -26.dbamp, attack=0.01, release=0.01,
		pitchattack=0.01, pitchrelease=0.01,
		pitchmedian = 2,
		snap = 0;
	
	var pitch, haspitch, ampinrange, outamp, output;
	pitch = Median.kr(pitchmedian, In.kr(pitchbus));
	pitch = if (snap, pitch.cpsmidi.round(snap).midicps, pitch);
	pitch = LagUD.kr(pitch, pitchattack, pitchrelease);
	haspitch = In.kr(pitchbus + 1);
	
	ampinrange = InRange.kr(In.kr(ampbus), ampthresh) * haspitch.poll;
	outamp = LagUD.kr(ampinrange, attack, release, level);
	
	output = SinOsc.ar(pitch, 0, outamp);
	
	Out.ar(out, output);
}).load(s);

SynthDef.new(\sustainer_rec, {
	arg in=0, out=0, buf=0,
		thresh= -36.dbamp, attack=0.01, release=0.2;
	var amp, input, ampinrange;
	input = In.ar(in);
	amp = Amplitude.kr(input, attack, release);
	ampinrange = InRange.kr(amp, thresh);
//	ampinrange.poll;
	RecordBuf.ar(input, buf, loop:1, trigger:ampinrange, run:ampinrange);
}).load(s);



SynthDef.new(\sustainer_rec_retrig, {
	arg in=0, out=0, buf=0,
		thresh= -36.dbamp, attack=0.01, release=0.2,
		trigrate = 1.0, run=1;
	var amp, input, ampinrange, trig;
	input = In.ar(in);
	amp = Amplitude.kr(input, attack, release);
	ampinrange = InRange.kr(amp, thresh);
//	ampinrange.poll;
	//trig = Trig.kr(ampinrange) + Trig.kr(Impulse.kr(trigrate));
	trig = Trig.kr(Impulse.kr(trigrate));
	RecordBuf.ar(input, buf, loop:1, trigger:trig, run:(ampinrange * run));
}).load(s);



SynthDef.new(\playbuf_retrig, {
	arg buf=0, out=0, amp=1.0, amplag = 0.1,
		rate=1.0, trigrate = 0.0, trigger, loop=0, startpos=0.0;
	var trig, output;
	
	trig = Impulse.kr(trigrate);
	
	output = PlayBuf.ar(1, buf, rate, trig + trigger, startpos, loop);
	
	Out.ar(out, output * Lag.kr(amp, amplag));
}).load(s);
	

SynthDef.new(\killattack, {
	arg in=0, out=0, attack = 2.0, release=0.2, thresh = -24.dbamp;
		
	var input, amp;
	input = In.ar(in);
	
	amp = Amplitude.kr(input);
	amp = LagUD.kr(InRange.kr(amp, thresh), attack, release);
	
	Out.ar(out, input * amp);
}).load(s);

SynthDef.new(\specfreeze, {
	arg in=0, freeze=0, out=0,
		amp=1.0, amplag=0.1;
	var chain, input, output;
	input = In.ar(in);
	chain = FFT(LocalBuf(2048, 1), input);
	chain = PV_Freeze(chain, freeze);
	output = IFFT(chain);
	amp = Lag.kr(amp, amplag);
	Out.ar(out, output  * amp);
}).load(s);


SynthDef.new(\specfreeze_shift, {
	arg in=0, freeze=0, out=0,
		amp=1.0, amplag=0.1,
		stretch=1.0, shift=1.0;
	var chain, input, output;
	input = In.ar(in);
	chain = FFT(LocalBuf(2048, 1), input);
	chain = PV_Freeze(chain, freeze);
	chain = PV_BinShift(chain, stretch, shift);
	output = IFFT(chain);
	amp = Lag.kr(amp, amplag);
	Out.ar(out, output  * amp);
}).load(s);

/*
SynthDef.new(\specfreeze_shift_env, {
	arg in=0, freeze=0, out=0, buf=0,
		amp=1.0,
		stretch=1.0, shift=1.0,
		attack=1.0, sustain=1.0, release=1.0;
	var chain, input, output, env, ampenv;
	input = In.ar(in);
	chain = FFT(LocalBuf(2048, 1), input);
	chain = PV_Freeze(chain, freeze);
	chain = PV_BinShift(chain, stretch, shift);
	output = IFFT(chain);
	env = Env.linen(attack, sustain, release, 1.0);
	ampenv = EnvGen.ar(env, doneAction:2) * amp;
	Out.ar(out, output  * ampenv);
}).load(s);
*/

/// map with delay
SynthDef.new(\specfreeze_shift_env, {
	arg in=0, freeze=0, out=0, buf=0,
		amp=1.0,
		stretchbus=0, shiftbus=0,
		stretchdelay = 1.0, shiftdelay = 2.0,
		stretchmul = 0.125, stretchadd=0.9,
		shiftmul = 0.125, shiftadd=0.9,
		attack=1.0, sustain=1.0, release=1.0,
		stretchlag=1.0, shiftlag=1.0;
	var chain, input, output, env, ampenv, stretch, shift;
	input = In.ar(in);
	stretch = DelayL.kr(In.kr(stretchbus), 10.0, stretchdelay, stretchmul, stretchadd);
	shift = DelayL.kr(In.kr(shiftbus), 10.0, shiftdelay, shiftmul, shiftadd);
	stretch = Lag.kr(stretch, stretchlag);
	shift = Lag.kr(shift, shiftlag);
	chain = FFT(LocalBuf(2048, 1), input);
	chain = PV_Freeze(chain, freeze);
	chain = PV_BinShift(chain, stretch, shift);
	output = IFFT(chain);
	env = Env.linen(attack, sustain, release, 1.0);
	ampenv = EnvGen.ar(env, doneAction:2) * amp;
	Out.ar(out, output  * ampenv);
}).load(s);

/// map with delay
SynthDef.new(\specfreeze_shift_env_pan, {
	arg in=0, freeze=0, out=0, buf=0,
		amp=1.0,
		stretchbus=0, shiftbus=0,
		stretchdelay = 1.0, shiftdelay = 2.0,
		stretchmul = 0.125, stretchadd=0.9,
		shiftmul = 0.125, shiftadd=0.9,
		attack=1.0, sustain=1.0, release=1.0,
		stretchlag=1.0, shiftlag=1.0,
		pan=0.0;
	var chain, input, output, env, ampenv, stretch, shift;
	input = In.ar(in);
	stretch = DelayL.kr(In.kr(stretchbus), 10.0, stretchdelay, stretchmul, stretchadd);
	shift = DelayL.kr(In.kr(shiftbus), 10.0, shiftdelay, shiftmul, shiftadd);
	stretch = Lag.kr(stretch, stretchlag);
	shift = Lag.kr(shift, shiftlag);
	chain = FFT(LocalBuf(2048, 1), input);
	chain = PV_Freeze(chain, freeze);
	chain = PV_BinShift(chain, stretch, shift);
	output = IFFT(chain);
	env = Env.linen(attack, sustain, release, 1.0);
	ampenv = EnvGen.ar(env, doneAction:2) * amp;
	Out.ar(out, Pan2.ar(output  * ampenv, pan));
}).load(s);


SynthDef.new(\bufd, {arg in=0, out=0, buf=0, time=1.0, amp=1.0, fbamp=0.0, inamp=1.0;
	var input = SoundIn.ar(in) + (LocalIn.ar(1) * fbamp);
	var delay = BufDelayC.ar(buf, input*inamp, time, amp);
	LocalOut.ar(delay);
	Out.ar(out, delay);
}).load(s);


SynthDef.new(\vosc, {
	arg out=0, amp = -24.dbamp,
	gate = 1, timescale = 1.0,
	hz=110, phase=0,
	// Vosc needs minumum 2 buffers or silent fail ... ?
	numbufs=1.0, buf=0,
	bufphase=0.0, bufphaselag=1.0,
	attack = 1.0, release = 1.0;
	
	var env, ampenv, sig;
	
	ampenv = EnvGen.ar(Env.asr(1.0, 1.0, 1.0), 
		gate:gate,
		timeScale:timescale,
		doneAction:2);
		
	sig = VOsc.ar(buf + ((numbufs - 1) * Lag.kr(bufphase, bufphaselag)), hz, phase, ampenv);
	
	Out.ar(out, sig * amp)
}).load(s);


SynthDef.new(\sine, {
	arg out=0, amp = -24.dbamp,
	gate = 1, timescale = 1.0,
	hz=110, phase=0,
	attack = 1.0, release = 1.0;
	
	var env, ampenv, sig;
	
	ampenv = EnvGen.ar(Env.asr(1.0, 1.0, 1.0), 
		gate:gate,
		timeScale:timescale,
		doneAction:2);
		
	sig = SinOsc.ar(hz, phase, ampenv);
	
	Out.ar(out, sig * amp)
}).load(s);



SynthDef.new(\sine_pan, {
	arg out=0, amp = -24.dbamp,
	gate = 1, timescale = 1.0,
	hz=110, phase=0,
	attack = 1.0, release = 1.0,
	pan=0;
	
	var env, ampenv, sig;
	
	ampenv = EnvGen.ar(Env.asr(1.0, 1.0, 1.0), 
		gate:gate,
		timeScale:timescale,
		doneAction:2);
		
	sig = SinOsc.ar(hz, phase, ampenv);
	
	Out.ar(out, Pan2.ar(sig * amp, pan))
}).load(s);




SynthDef.new(\vosc_rez_del, {
	arg out=0, amp = -24.dbamp,
	gate = 1, timescale = 1.0,
	voschz=110, phase=0,
	numbufs=1.0, buf=0,
	bufphase=0.0, bufphaselag=1.0,
	
	attack = 1.0, release = 1.0,
	hzbus=0, hzmul=1.0, hzadd=0.0, hzdelay,
	hzlag=0.01,
	res=0.0,
	low=1.0, band=1.0, high=0.0, notch=0.0, peak=0.0;
	
	var env, ampenv, sig, output, hz;
	
	ampenv = EnvGen.ar(Env.asr(1.0, 1.0, 1.0), 
		gate:gate,
		timeScale:timescale,
		doneAction:2);
		
		
	hz = Lag.kr(In.kr(hzbus), hzlag, hzmul, hzadd);
	hz = DelayL.kr(hz, 10.0, hzdelay);
	
	sig = VOsc.ar(buf + ((numbufs - 1) * Lag.kr(bufphase, bufphaselag)), voschz, phase, ampenv);
	
	output = SVF.ar(sig, hz, res, low, band, high, notch, peak);
	
	Out.ar(out, output * amp)
}).load(s);



SynthDef.new(\vosc_rez_del_detune, {
	arg out=0, amp = -24.dbamp,
	gate = 1, timescale = 1.0,
	voschz=110, phase=0,
	numbufs=1.0, buf=0,
	bufphase=0.0, bufphaselag=1.0,
	
	attack = 1.0, release = 1.0,
	hzbus=0, hzmul=1.0, hzadd=0.0, hzdelay,
	hzlag=0.01,
	res=0.0,
	low=1.0, band=1.0, high=0.0, notch=0.0, peak=0.0,
	detunehz = 4.0;
	
	var env, ampenv, sig, output, hz;
	
	ampenv = EnvGen.ar(Env.asr(1.0, 1.0, 1.0), 
		gate:gate,
		timeScale:timescale,
		doneAction:2);
		
		
	hz = Lag.kr(In.kr(hzbus), hzlag, hzmul, hzadd);
	hz = DelayL.kr(hz, 10.0, hzdelay);
	
	sig = Mix.new(
		VOsc.ar(buf + ((numbufs - 1) * Lag.kr(bufphase, bufphaselag)), 
			[voschz-(detunehz * 0.5), voschz + (detunehz * 0.5)]
			, phase, ampenv);
	);
	
	output = SVF.ar(sig, hz, res, low, band, high, notch, peak);
	
	Out.ar(out, output * amp)
}).load(s);


SynthDef.new(\vosc_rez_del_detune_env, {
	arg out=0, amp = -24.dbamp,
	attack=1.0, sustain = 1.0, release=1.0,
	voschz=110, phase=0,
	numbufs=1.0, buf=0,
	bufphase=0.0, bufphaselag=1.0,
	
	hzbus=0, hzmul=1.0, hzadd=0.0, hzdelay,
	hzlag=0.01,
	res=0.0, reslag=0.1, resdelay=0.01,
	low=1.0, band=1.0, high=0.0, notch=0.0, peak=0.0,
	detunehz = 4.0;
	
	var env, ampenv, sig, output, hz;
	
	env = Env.linen(attack, sustain, release, 1.0);
	ampenv = EnvGen.ar(env, gate:1, doneAction:2);
		
		
	hz = Lag.kr(In.kr(hzbus), hzlag, hzmul, hzadd);
	hz = DelayL.kr(hz, 10.0, hzdelay);
	
//	res = DelayL.kr(Lag.kr(res, reslag), 10.0, resdelay);
	
	sig = Mix.new(
		VOsc.ar(buf + ((numbufs - 1) * Lag.kr(bufphase, bufphaselag)), 
			[voschz-(detunehz * 0.5), voschz + (detunehz * 0.5)]
			, phase);
	);
	
	output = SVF.ar(sig, hz, res, low, band, high, notch, peak);
	
	Out.ar(out, output * amp * ampenv)
}).load(s);



SynthDef.new(\vosc_rez_del_detune_env_pan, {
	arg out=0, amp = -24.dbamp,
	attack=1.0, sustain = 1.0, release=1.0,
	voschz=110, phase=0,
	numbufs=1.0, buf=0,
	bufphase=0.0, bufphaselag=1.0,
	
	hzbus=0, hzmul=1.0, hzadd=0.0, hzdelay,
	hzlag=0.01,
	res=0.0, reslag=0.1, resdelay=0.01,
	low=1.0, band=1.0, high=0.0, notch=0.0, peak=0.0,
	detunehz = 4.0,
	pan=0.0;
	
	var env, ampenv, sig, output, hz;
	
	env = Env.linen(attack, sustain, release, 1.0);
	ampenv = EnvGen.ar(env, gate:1, doneAction:2);
		
		
	hz = Lag.kr(In.kr(hzbus), hzlag, hzmul, hzadd);
	hz = DelayL.kr(hz, 10.0, hzdelay);
	
//	res = DelayL.kr(Lag.kr(res, reslag), 10.0, resdelay);
	
	sig = Mix.new(
		VOsc.ar(buf + ((numbufs - 1) * Lag.kr(bufphase, bufphaselag)), 
			[voschz-(detunehz * 0.5), voschz + (detunehz * 0.5)]
			, phase);
	);
	
	output = SVF.ar(sig, hz, res, low, band, high, notch, peak);
	
	Out.ar(out, Pan2.ar(output * amp * ampenv, pan))
}).load(s);





SynthDef.new(\bufgrain, {
	arg out=0, amp=1.0, amplag = 0.1, buf=0, rate=1.0, dur=1.0, trigrate=6.0, posrate=1.0, interp=2;
	var pos, grains, trig;
	
	pos = LFTri.kr(posrate);
	trig = Impulse.kr(trigrate);
	amp = Lag.kr(amp, amplag);
	grains = BufGrain.ar(trig, dur, buf, rate, pos, interp);
	Out.ar(out, grains * amp);
}).load(s);




SynthDef.new(\bufgrain_pan, {
	arg out=0, amp=1.0, amplag = 0.1, buf=0, rate=1.0, dur=1.0, trigrate=6.0, posrate=1.0, pan=0.0, pos_offset = 0.0;
	var pos, grains, trig;
	
	pos = (LFTri.kr(posrate) + pos_offset).wrap(0.0, 1.0);
	
	trig = Impulse.kr(trigrate);
	
	amp = Lag.kr(amp, amplag);
	
	grains = BufGrain.ar(trig, dur, buf, rate, pos, 2);
	
	Out.ar(out, Pan2.ar(grains * amp, pan));
}).load(s);


SynthDef.new(\bufgrain_pan, {
	arg out=0, amp=1.0, amplag = 0.1, buf=0, rate=1.0, dur=1.0, trigrate=6.0, posrate=1.0, pan=0.0, pos_offset = 0.0,
	attack, sustain, release;
	var pos, grains, trig, env;
	
	pos = (LFTri.kr(posrate) + pos_offset).wrap(0.0, 1.0);
	
	trig = Impulse.kr(trigrate);
	
	amp = Lag.kr(amp, amplag);
	
	grains = BufGrain.ar(trig, dur, buf, rate, pos, 2);
	
	env = EnvGen.ar(Env.new([0.0, 1.0, 1.0, 0.0], [attack, sustain, release]), doneAction:2);
	
	Out.ar(out, Pan2.ar(grains * amp * env, pan));
}).load(s);






//////

SynthDef.new(\henonsvf, {
	arg out=0, amp=1.0,
	attack=1.0, release=1.0, gate=1,
	hz=220.0,
	hzlag=0.01,
	res=0.2,
	reslag = 4.0,
	osc_hz = 44100,
	a=1.4, b=0.3,
	alag=4.0, blag=4.0,
	low=1.0, band=1.0, high=0.0, notch=0.0, peak=0.0;
	
	var noise, output, env, ampenv;
	
	env = Env.asr(attack, 1.0, release);
	ampenv = EnvGen.ar(env, gate:gate, doneAction:2) * amp;
	
	a = Lag.kr(a, alag);
	b = Lag.kr(b, blag);
	
	noise = HenonN.ar(osc_hz, a, b);
	
	hz = Lag.kr(hz, hzlag);
	res = Lag.kr(res, reslag);
	
	output = SVF.ar(noise, hz, res, low, band, high, notch, peak);
	
	Out.ar(out, output * ampenv * amp);
	
}).load(s);


SynthDef.new(\henonsvf_pan, {
	arg out=0, amp=1.0,
	attack=1.0, release=1.0, gate=1,
	pan=0.0,
	hz=220.0,
	hzlag=0.01,
	res=0.2,
	reslag = 4.0,
	osc_hz = 44100,
	a=1.4, b=0.3,
	alag=4.0, blag=4.0,
	low=1.0, band=1.0, high=0.0, notch=0.0, peak=0.0;
	
	var noise, output, env, ampenv;
	
	env = Env.asr(attack, 1.0, release);
	ampenv = EnvGen.ar(env, gate:gate, doneAction:2) * amp;
	
	a = Lag.kr(a, alag);
	b = Lag.kr(b, blag);
	
	noise = HenonN.ar(osc_hz, a, b);
	
	hz = Lag.kr(hz, hzlag);
	res = Lag.kr(res, reslag);
	
	output = SVF.ar(noise, hz, res, low, band, high, notch, peak);
	
	Out.ar(out, Pan2.ar(output * ampenv * amp, pan));
	
}).load(s);
