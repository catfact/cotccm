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
}).send(s);

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

SynthDef.new(\in_hw, { arg in=0, out=0, amp=1.0, amplag = 1.0;
	amp = Lag.kr(amp, amplag);
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
	arg in=1, out=0, amp=1.0,
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




SynthDef.new(\bufgrain, {
	arg out=0, amp=1.0, amplag = 0.1, buf=0, rate=1.0, dur=1.0, trigrate=6.0, posrate=1.0, interp=2;
	var pos, grains, trig;
	
	pos = LFTri.kr(posrate);
	trig = Impulse.kr(trigrate);
	amp = Lag.kr(amp, amplag);
	grains = GrainBuf.ar(1, trig, dur, buf, rate, pos, interp);
	Out.ar(out, grains * amp);
}).send(s);




SynthDef.new(\bufgrain_pan, {
	arg out=0, amp=1.0, amplag = 0.1, buf=0, rate=1.0, dur=1.0, trigrate=6.0, posrate=1.0, pan=0.0, pos_offset = 0.0;
	var pos, grains, trig;
	
	pos = (LFTri.kr(posrate) + pos_offset).wrap(0.0, 1.0);
	
	trig = Impulse.kr(trigrate);
	
	amp = Lag.kr(amp, amplag);
	
	grains = GrainBuf.ar(1, trig, dur, buf, rate, pos, 2);
	
	Out.ar(out, Pan2.ar(grains * amp, pan));
}).send(s);


SynthDef.new(\bufgrain_pan_1shot, {
	arg out=0, amp=1.0, amplag = 0.1, buf=0, rate=1.0, dur=1.0, trigrate=6.0, posrate=1.0, pan=0.0, pos_offset = 0.0,
	attack, sustain, release;
	var pos, grains, trig, env;
	
	pos = (LFTri.kr(posrate) + pos_offset).wrap(0.0, 1.0);
	
	trig = Impulse.kr(trigrate);
	
	amp = Lag.kr(amp, amplag);
	
	grains = GrainBuf.ar(1, trig, dur, buf, rate, pos, 2);
	
	env = EnvGen.ar(Env.new([0.0, 1.0, 1.0, 0.0], [attack, sustain, release]), doneAction:2);
	
	Out.ar(out, Pan2.ar(grains * amp * env, pan));
}).send(s);

