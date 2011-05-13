s = Server.local.boot;

SynthDef.new(\adc, {arg in=0, out=0, amp=1, amplag = 0.01;
	var sig;
	amp = Lag.kr(amp, amplag);
	sig = SoundIn.ar(in);
	Out.ar(out, sig * amp);
}).send(s);

SynthDef.new(\rec, {
	arg in=0, buf=0,
		reclevel=1.0, prelevel=0.0, offset=0.0, trig=1.0, loop=0, run=1,
		atk=0.01, rel=0.01, gate=1;
	var env;
	env = EnvGen.ar(Env.asr(atk, 1.0, rel);
	RecordBuf.ar(In.ar(in, 1),
		bufnum: buf, 
		offset:0,
		recLevel:reclevel,
		preLevel:prelevel,
		run:run,
		loop:loop,
		trigger:trig
	);
}).send(s);

SynthDef.new(\play, {arg out=0, buf=0, trig=0, pos=0.0, rate=1.0, loop=0, atk=0.01, rel=0.01, gate=1, doneaction=2;
	var sig, amp, env;
	env = Env.asr(atk, 1.0, rel);
	amp = EnvGen.ar(env, gate, doneAction:doneaction);
	sig = PlayBuf.ar(1, buf, rate, trig, pos, loop:loop);
	Out.ar(out, sig * amp);
}).send(s);

~vla_loop_buf = Buffer.alloc(s, s.sampleRate * 300.0, completionMessage: {
	
	////////////////
	///////////////
	
0}); // buf alloc;

~ig = Group.new(s);
~xg = Group.after(~ig);
~og = Group.after(~xg);

~vla_in_b = Bus.audio(s, 1);
~vla_adc = Synth.new(\adc, [\in, 1, \out, ~vla_in_b.index], ~ig);

// record and play synths, paused for now
~vla_loop_rec = Synth.new(\rec, [\buf, ~vla_loop_buf.bufnum, \in, ~vla_in_b.index], ~xg).run(false);
~vla_loop_play = Synth.new(\play, [\buf, ~vla_loop_buf.bufnum, \loop:1], ~xg).run(false);


////// MIDI from akai mpkmini
// flag for start/stop
~vla_loop_clear = true;

~post_cc = CCResponder({
	arg src, chan, num, val;
	[src, chan, num, val].postln;
}, nil, nil, nil);


// record/play/stop switch
~vla_loop_rec_play_stop = CCResponder({
	 
	~vla_loop_rec.run(false); 
	~vla_loop_play.run(true);	
}, nil, nil, 9); // top row, left pad of mpkMini

// overdub
{
}