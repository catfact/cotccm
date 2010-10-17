~buffer_a.plot; 
~buffer_a.bufnum;
x = Synth.new(\grain1shot, [\buf, ~buffer_a.bufnum, \out, 1], s);
y = Synth.new(\grain1shot, [\buf, ~buffer_a.bufnum, \out, 0], s);
z = {SinOsc.ar}.play(s);
z.free; 

z = {PlayBuf.ar(1, ~buffer_a.bufnum, 1.0, doneAction:2)}.play(s); 


~chop_loop_r.stop;
SystemClock.clear;


t = SynthDef.new(\conductor_chorus, { arg out=0, in=0, period=0.125, lfoWidth=0.5, lfoAttack=0.001, lfoDecay=0.001, delWidth=0.1, delBase=0.01; 
	var del, deltime;
//	deltime = Decay2.ar(LFPulse.ar(1.0 / period, 0.0, lfoWidth), lfoAttack, lfoDecay) * 0.1 + 0.1; 
	deltime = LFPulse.ar(1.0/period, 0, lfoWidth)*delWidth + delBase;
	del = DelayC.ar(SoundIn.ar(in), 1.0, A2K.kr(deltime));
	Out.ar(out, del);
}).play(s, [\period, ~period_a * 2.0]);	 

t.set(\period, 60.0/70.0);
t.set(\delWidth, 0.0005);
t.set(\delBase, 0.02);
t.free;