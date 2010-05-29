//s = Server.internal;
//s.waitForBoot{ Routine {

SynthDef.new(\adc_rec, {arg input=0, buf, run=1, loop=0, prelevel=0.0; 
	RecordBuf.ar(SoundIn.ar(input), buf, run:run, loop:loop, preLevel:prelevel);
}).load(s);

SynthDef.new(\grainbuf_square, {
	arg out=0, buf, 
		grainenvbuf= -1, interp=2,
		grainposrate=0.25, graindurratio=4.0,
		squarerate=0.75, squareduty=0.5, squarelag=0.75,
		grainpulserate0=4.0, grainpulserate1=8.0,
		amp=0.0, amplag=10.0;
	
	var square,
		grainpulserate, grainpulse,
		grainpos, graindur,
		grainpan=0.0,
		grain;
		
	amp = Lag.kr(amp, amplag);
	
	square = LFPulse.kr(squarerate, 0, squareduty);
	square = Lag.kr(square, squarelag);
	
	grainpulserate = grainpulserate0 + ((grainpulserate1 - grainpulserate0) * square);
	
	grainpulse = Impulse.kr(grainpulserate);
	graindur = (1.0 / grainpulserate) * graindurratio;
	grainpos =  LFTri.kr(0.5).abs.wrap(0.0, 1.0 - (graindur / BufDur.kr(buf)));
	
	grain = GrainBuf.ar(1, grainpulse, graindur, buf, 1.0, grainpos, interp, grainpan, grainenvbuf);
	
	Out.ar(out, grain * amp);
}).load(s);


s.postln;

"grain defs?".postln;

0.25.wait;

~vla_grain_buf = Buffer.alloc(s, s.sampleRate * 2.0, 1);

0.25.wait;

~vla_grain_rec_s = Synth.new(\adc_rec, [\buf, ~vla_grain_buf.bufnum, \loop, 1], s);
~vla_grain_rec_s.set(\prelevel, 0.4);
~vla_grain_rec_s.set(\input, ~input_map[\fxloop]);

~vla_grain_env = Env.new([0, 1, 1, 0], [0.02, 0.1, 1.0], -4);
0.1.wait;
//~grain_env.plot;
~vla_grain_signal = ~vla_grain_env.asSignal(s.sampleRate);
//~grain_signal.plot;
~vla_grain_env_buf = Buffer.loadCollection(s, ~vla_grain_signal.asCollection);
//~grain_env_buf.plot;

0.25.wait;

~vla_grain_s = Synth.new(\grainbuf_square, [
	\buf, ~vla_grain_buf.bufnum,
	\grainenvbuf, ~vla_grain_env_buf.bufnum
], s);

~vla_grain_s_2 = Synth.new(\grainbuf_square, [
	\buf, ~vla_grain_buf.bufnum,
	\grainenvbuf, ~vla_grain_env_buf.bufnum,
	\grainenvbuf,  -1, 
	\interp, 2,
	\grainposrate, 0.5, 
	\graindurratio, 8.0,
	\squarerate, 2.0, 
	\squareduty, 0.75, 
	\squarelag, 0.25,
	\grainpulserate0, 6.0, 
	\grainpulserate1, 12.0,
	\grainrate, 2.0
], s);

/*
~grain_buf.plot;
*/

/*
~grain_s.trace
*/

// }.play; };

