/*
	SynthDef.new(\xlop, {
	arg buf=0, out=0, 
	start=1.0, end=9.0,
	rate = 1.0, amp =0.5;
	
	
	
	});
*/

Routine {

	~fltlb = Bus.audio(s, 1);
	~fltlg = Group.new(s);

	SynthDef.new(\grain_tripos, {
		arg buf, out=0, amp=0.5,
		trigrate=8.0, trigratenoise=0.125,
		playrate=1.0, playratenoise=0.0001,
		posrate=0.25, posratenoise=0.000125,
		dur=4.0, durnoise=0.0001,
		poslen = 8.0, posoff=0.0,
		pan = 0, pannoise = 0.5,
		amplag = 1.0;
		var trig, grain, pos;
		amp = Lag.kr(amp, amplag);
		trigrate = trigrate * (1 +  WhiteNoise.kr(trigratenoise));
		playrate = playrate * (1 +  WhiteNoise.kr(playratenoise));
		posrate = posrate * (1 + WhiteNoise.kr(posratenoise) );
		dur = dur * (1 + WhiteNoise.kr(durnoise));
		pan = pan * (1 + WhiteNoise.kr(pannoise));
		posrate = posrate / poslen; //BufDur.kr(buf) ;
		pos = (LFTri.kr(posrate).range(0, poslen) + posoff)  / BufDur.kr(buf);
		trig = Impulse.ar(trigrate);
		dur = dur / trigrate;
		grain = GrainBuf.ar(2, trig, dur, buf, playrate, pos, 1, pan, -1, 64);
		Out.ar(out, grain * amp);
	}).send(s);

	SynthDef.new(\lim_pan, {
		arg in=0, out=0, amp=1.0, pan=0.0,
		level=0.5, dur=1.0;
		Out.ar(out, Pan2.ar(Limiter.ar(In.ar(in), level, dur) * amp, pan));
	}).send(s);

	s.sync;	

	~fltlpl = Array.fill(8, { arg i; Array.fill(5, { arg j;
		var rate;
		rate = (((j*5)%3) + 1) / ((((j*5) + (i+1 * 3)) % 7) + 1);
		postln("loop rate: " ++ rate);
		Synth.new(\grain_tripos, [
			\buf, ~fltl_buf[i].bufnum,
			\amp, 0.0,
			\rate, rate,
			\out, ~fltlb.index
		], ~fltlg);
	}); });

	~fltlo = Synth.new(\lim, [
		\in, ~fltlb.index,
		\out, 0
	], ~fltlg, \addAfter);

}.play;

/*
	~fltl_buf[2].plot;
	~fltl_buf.do({ arg buf; buf.normalize; });
	~fltl_buf.do({ arg buf; buf.plot; });
	~fltlpl[0].set(\amp, 0.5);
	~fltlpl[0].set(\rate, 2.0);


	~fltlpl[2][0].set(\amp, 0.25);
	~fltlpl[2].set(\rate, 2.0);

	~fltlpl.do({ arg syn; syn.free; });


*/