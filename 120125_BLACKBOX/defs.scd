
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
