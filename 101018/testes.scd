~buffer_a.plot; 
~buffer_a.bufnum;

s = Server.internal.boot; 

b = Buffer.alloc(s, s.sampleRate * 10.0, 1);
r = SynthDef.new(\recAdc1shot, { arg in, buf;
				RecordBuf.ar(SoundIn.ar(in), buf, loop:0, doneAction:2);
			}).play(s, [\buf, b.bufnum, \in, 0]); 
			

b.plot;
 
x = Synth.new(\grain1shot, [\buf, b.bufnum, \out, 0, \dur, 2.0], s);
y = Synth.new(\grain1shot, [\buf, b.bufnum, \out, 0, \dur, 2.0, \start, 1.0], s);
 
 
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

~trem_s.set(\lfoAttack, 0.001);
~trem_s.set(\lfoWidth, 0.5);


s.freeAll;

~churchkey_func_a.value;


~guit_echo_s.set(\level, 1.0); 

~guit_loop_buf.plot 
~guit_loop_s.trace 

~dur.postln;
~guit_loop_buf.duration 


~guit_chord_buf[0].plot

~guit_chord_s = Synth.new(\drifter, [\buf, ~guit_chord_buf[0].bufnum], s); 
~guit_chord_s.set(\gate, 0);
~guit_chord_s.free; 
 x = Synth.new(\grain1shot, [\buf, ~guit_chord_buf[0].bufnum, \out, 0], s);

~guit_chord_s.trace 
 
 
~grain_out_dist_s = Synth.new(\churchdist, [\in, ~grain_b.index, \out, 0], ~grain_g, \addAfter);
 
 ~grain_out_dist_s.free;
~grain_out_dist_s.set(\level, 0.35);