s = Server.local;
s.waitForBoot
{	
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
			attack=10.0, release=30.0, level=0.1, gate=1;
			
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
		amp = LagUD.kr(level, attack, release); // Linen.kr(gate, attack, release) * level;
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
}
