~basepath = Document.current.dir ++"/";
 x = { |p| this.executeFile(~basepath++p); };

x.value("0_40h.scd");


s = Server.local;
c = CfAudioContext.new(s, 2, { Routine {
	
	~vla_gr_buf = Buffer.alloc(s, s.sampleRate * 8.0, 1);
	~bass_gr_buf = Buffer.alloc(s, s.sampleRate * 8.0, 1);
	~vla_gr_buf2 = Buffer.alloc(s, s.sampleRate * 32.0, 1);
	~bass_gr_buf2 = Buffer.alloc(s, s.sampleRate * 32.0, 1);
	
	SynthDef.new(\gr, {
		arg buf,
//		in = c.in_b.index,
		out = c.out_b.index,
		amp = 0.0,
		amplag = 30.0,
		pitch = 2.0,
		posrate = 0.5,
		pulserate = 12.0,
		dur=1.0,
		rec=1;
		
		var pos, pulse, grains;
		
		amp = Lag.kr(amp, amplag);
		
		pos  = LFTri.kr(posrate / BufDur.kr(buf)) * 0.49 + 0.5;
		pulse = LFPulse.kr(pulserate);
		grains = GrainBuf.ar(2, pulse, dur, buf, pitch, pos, maxGrains:128);
		Out.ar(out, grains * amp);
	}).send(s);
	
	s.sync;
	
	~bass_gr_in_b = Bus.audio(s, 1);
	~vla_gr_in_b = Bus.audio(s, 1);
	~freeze_in_b = Bus.audio(s, 1);

	~bass_gr_in_s = Synth.new(\patch, [\in, c.in_b.index, \out, ~bass_gr_in_b.index], c.ig, \addToTail);
	~vla_gr_in_s = Synth.new(\patch, [\in, c.in_b.index + 1, \out, ~vla_gr_in_b.index], c.ig, \addToTail);
	
	~bass_gr_rec_s = Synth.new(\rec, [\in, ~bass_gr_in_b.index,\buf, ~bass_gr_buf.bufnum], c.ig, \addAfter);
	~vla_gr_rec_s = Synth.new(\rec, [\in, ~vla_gr_in_b.index,\buf, ~vla_gr_buf.bufnum], c.ig, \addAfter);
	
	~bass_gr_rec2_s = Synth.new(\rec, [\in, ~bass_gr_in_b.index,\buf, ~bass_gr_buf2.bufnum], c.ig, \addAfter);
	~vla_gr_rec2_s = Synth.new(\rec, [\in, ~vla_gr_in_b.index,\buf, ~vla_gr_buf2.bufnum], c.ig, \addAfter);
	
	
	~bass_gr_s.set(\pulserate, 6.0);
	~bass_gr_s = Synth.new(\gr, [\out, c.out_b.index, \buf, ~bass_gr_buf.bufnum], c.xg);
	~vla_gr_s = Synth.new(\gr, [\out, c.out_b.index, \buf, ~vla_gr_buf.bufnum], c.xg);
	
	~vla_gr_s.set(\pulserate, 8.0);
	~bass_gr_s.set(\pitch, 4.0);
	~bass_gr_s.set(\pulserate, 6.0);
	
	
	~quadOnFuncs[0] = { ~bass_gr_s.set(\amp, 0.5); ~vla_gr_s.set(\amp, 0.5); "onnn".postln;};
	~quadOffFuncs[0] = { ~bass_gr_s.set(\amp, 0.0); ~vla_gr_s.set(\amp, 0.0); "offff".postln;};

//	x.value("freeze.scd");
	x.value("grans.scd");
	
	
	
}.play; });