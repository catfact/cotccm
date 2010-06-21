SynthDef.new(\looper, {
	arg buf, in=0, out=0,
		reclevel=0.0, prelevel=1.0, looptime=10.0,
		trig=0,
		amp=0.0, amplag = 1.0,
		rate=1.0;
	
	var sig, rec, play, rtrig, ptrig;
	
	amp = Lag.kr(amp, amplag);
	
	sig = SoundIn.ar(in);

	ptrig = LFPulse.kr(1.0 / looptime, 0.0, 0.5) + trig;
	rtrig = DelayN.kr(ptrig, 0.01, 0.001);
	
	rec = RecordBuf.ar(sig, buf, 0, reclevel, prelevel, 1, 1, rtrig);
	
	play = PlayBuf.ar(1, buf, rate * BufRateScale.kr(buf), ptrig, 0.0, 1);
	play = play * amp;
	
	Out.ar(out, play);
	
}).store;

s = Server.local;
s.boot;

~loop_buf = Buffer.alloc(s, 60.0 * s.sampleRate, 1);

~loop_s = Synth.new(\looper, [
	\buf, ~loop_buf.bufnum,
	\looptime, 10.0
]);

~loop_s.set(\amp, 1.0);
~loop_s.set(\reclevel, 1.0);
~loop_s.set(\reclevel, 0.0);
~loop_s.set(\prelevel, 0.5);

~loop_buf.plot;

~loop_s.set(\looptime, 15.0);


~loop_s.set(\amplag, 10.0);

~loop_s.set(\amp, 0.0);

~loop_s.trace

