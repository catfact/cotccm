Routine {

	~bpm = 80.0;
	~loop_beats = 8;
	~beat = 60.0/~bpm;
	~beat.postln;
	~loop_t = ~beat * ~loop_beats;


	SynthDef.new(\justloop_rec, {
		arg in=0, buf=0,
		reclevel=1.0, prelevel=0.0, offset=0.0, trig=1.0, loop=0, run=1,
		atk=0.01, rel=0.01, gate=1;
		
		RecordBuf.ar(SoundIn.ar(in, 1),
			bufnum: buf, 
			offset:0,
			recLevel:reclevel,
			preLevel:prelevel,
			run:run,
			loop:loop,
			trigger:trig
		);
	}).send(s);

	SynthDef.new(\play_env_norm, {
		arg out=0, buf, start=0, dur=1, atk=0.1, rel=0.5, rate=1.0, level=1.0;
		var phase, play, amp, env, sr;
		sr = BufSampleRate.kr(buf);
		phase = Line.ar(sr*start, sr*(start + dur), dur);
		play = BufRd.ar(1, buf, phase, 0);
		env = Env.linen(atk, dur - atk - rel, rel);
		amp = EnvGen.ar(env, doneAction:2);

		//Compander.ar(in, control, thresh, slopeBelow, slopeAbove, 
		//clampTime, relaxTime, mul, add)
		play = Compander.ar(play, play, 0.5, 1.0, 0.1, 0.001, 0.02, 2.0);
		Out.ar(out, play * amp * level);
	}).send(s);

	~vlop_buf = Buffer.alloc(s, s.sampleRate * ~loop_t * 5.0, 1);

	s.sync;

~vlop_buf.bufnum.postln;

	~counts = 8;
	~counts.do({ arg i;
		postln(["countdown: ", (8-i)]);
		~beat.wait;
	});
	postln("recording...");

	~vlop_rec = Synth.new(\justloop_rec, [\buf, ~vlop_buf.bufnum, prelevel:1.0, \in, 0]);
	
	(~loop_beats * 10).do({
		postln("tick");
		(~beat * 0.5).wait;
	});
	(~vlop_buf.duration + 1).wait;
	~vlop_buf.normalize;

}.play;

~vlamp = 0.0;
~vlop_play = { arg b; // which starting beat
	4.do({ arg i;
		var start = ~loop_t * i + (~beat * b);
		start.postln;

		Synth.new(\play_env_norm, [
			\buf, ~vlop_buf.bufnum,
			\start, start,
			\dur, ~beat * 2,
			\atk, 0.0625 * (i+1) ,
			\rel, (0.0625 * (4-i)),
			\level, ~vlamp
		]);
	});
}


/*
	~vlop_play.value(0);
	~vlop_play.value(1);
	~vlop_play.value(2);
	~vlop_play.value(3);
	~vlop_play.value(4);
	~vlop_play.value(5);
	~vlop_play.value(6);
	~vlop_play.value(7);

~vlop_buf.normalize;


	~vlop_buf.plot;

*/