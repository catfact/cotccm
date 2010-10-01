
	SynthDef.new(\glick, {
		arg buf=0, out=0,
			amp=1.0, pan= -0.5,
			pulserate=1.0, posrate=0.25, playrate=1.0,
			thepos=0.0;
		var pulse, pos, play;
		pulse = Impulse.kr(pulserate);
		pos = Phasor.ar(0, posrate, 0, BufFrames.kr(buf));
		//pos = LFTri.kr(posrate / BufFrames.kr(buf) * BufRateScale.kr(buf) * 0.5) * 0.5 + 0.5;
		//pos = pos * BufFrames.kr(buf);
		//pos=thepos;
		
		play = PlayBuf.ar(1, buf, playrate, pulse, pos, 1);
		Out.ar(out, Pan2.ar(play * amp, pan));
	}).store;
	
//	0.2.wait;
	
	
	~glick1 = Synth.new(\glick, [
		\buf, ~vla_del_buf[0].bufnum,
		\pan, -0.5,
		\pulserate, 0.5,
		\posrate, 0.25,
		\out, 0 // ~glick_b.index
	], ~glick_g); 
	
	~glick2 = Synth.new(\glick, [
		\buf, ~vla_del_buf[1].bufnum,
		\pan, 0.5,
		\pulserate, 0.6,
		\posrate, 0.5,
		\out, 0 // ~glick_b.index
	], ~glick_g); 
	
	~glick3 = Synth.new(\glick, [
		\buf, ~vla_del_buf[0].bufnum,
		\pan, 0.35,
		\pulserate, 0.75,
		\posrate, 0.4,
		\playrate, 2.0,
		\out, 0 // ~glick_b.index
	], ~glick_g); 
	
	~glick4 = Synth.new(\glick, [
		\buf, ~vla_del_buf[1].bufnum,
		\pan, -0.35,
		\pulserate, 1.125,
		\posrate, 0.3,
		\playrate, 2.0,
		\out, 0 // ~glick_b.index
	], ~glick_g);  
	
	~glick5 = Synth.new(\glick, [
		\buf, ~vla_del_buf[0].bufnum,
		\pan, 0.35,
		\pulserate, 0.25,
		\posrate, 0.2,
		\playrate, 0.5,
		\out, 0 // ~glick_b.index
	], ~glick_g); 
	
	~glick6 = Synth.new(\glick, [
		\buf, ~vla_del_buf[1].bufnum,
		\pan, -0.35,
		\pulserate, 0.35,
		\posrate, 0.6,
		\playrate, 0.5,
		\out, 0 // ~glick_b.index
	], ~glick_g);  
 