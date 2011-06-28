s = Server.default;
s.boot;
s.waitForBoot { Routine {

SynthDef.new(\sine, {
	arg out=0, pan=0.0, hz, amp, phase,
		amplag=1.0, hzlag=1.0, phaselag=1.0, 
		hzmodhz, panmodhz, phasemodhz,
		hzmoddepth, panmoddepth, phasemoddepth;
		
		var sig;
		
		hz = Lag.kr(hz, hzlag);
		amp = Lag.kr(amp, amplag);
		phase = Lag.kr(phase, phaselag);
		
		hz = hz * ((1 + SinOsc.kr(hzmodhz, 0, hzmoddepth * hz)));
		phase = phase * ((1 + SinOsc.kr(phasemodhz, 0, phasemoddepth)));
		pan = pan * ((1 + SinOsc.kr(panmodhz, 0, panmoddepth)));
		
		
		sig = SinOsc.ar(hz, phase, amp);
		Out.ar(0, Pan2.ar(sig, pan));
}).send(s);

s.sync;


~hz = 55 * 8/9;

~sines = List.new;

~sines.add(Synth.new(\sine, [\hz, ~hz, \amp, -12.dbamp, 
	\hzmodhz, ~hz / 64.0, \hzmoddepth, 0.000001,
	\panmodhz, ~hz / 48.0, \panmoddepth, 0.25,
	\phasemodhz, ~hz / 60, \phasemoddepth, 0.1]));
~sines.add(Synth.new(\sine, [\hz, ~hz * 2, \amp, -18.dbamp, 
	\hzmodhz, ~hz / 60.0, \hzmoddepth, 0.00000001,
	\panmodhz, ~hz / 72.0, \panmoddepth, 0.25,
	\phasemodhz, ~hz / 128, \phasemoddepth, 0.1]));
~sines.add(Synth.new(\sine, [\hz, ~hz * 4, \amp, -24.dbamp, 
	\hzmodhz, ~hz / 128.0, \hzmoddepth, 0.00000001,
	\panmodhz, ~hz / 81.0, \panmoddepth, 0.25,
	\phasemodhz, ~hz / 72, \phasemoddepth, 0.1]));
~sines.add(Synth.new(\sine, [\hz, ~hz * 8, \amp, -34.dbamp, 
	\hzmodhz, ~hz / 72.0, \hzmoddepth, 0.0000001,
	\panmodhz, ~hz / 120.0, \panmoddepth, 0.25,
	\phasemodhz, ~hz / 96, \phasemoddepth, 0.1]));




}.play; };