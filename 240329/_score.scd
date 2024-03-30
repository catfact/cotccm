e = ();
e.idx = -1;
e.t = SystemClock.seconds;

~perform_step = { arg step, step1;
	var dt;
	var t1 = SystemClock.seconds;
	dt = t1 - e.t;

	if (dt > 1, {

		e.t = t1;

		if (step.size > 1, {
			if (step.size > 2, {
				~notify.value(step[1], step[2]);
			}, {
				~notify.value(step[1]);
			});
		});
		AppClock.sched(2, {
			~notify.value("next: " ++ step1[1], Color.new(0.5, 0.5, 0.5, 0.5));
			nil
		});

		step[0].value(nil, dt);
		true
	}, {
		false
	});
};

~advance_score = {
	var step, step1;
	e.idx = e.idx + 1;
	step = e.steps.wrapAt(e.idx);
	step1 = e.steps.wrapAt(e.idx + 1);
	if (~perform_step.value(step, step1).not, {
		e.idx = e.idx - 1;
	});
};

~reverse_score = {
	var step;
	e.idx = e.idx - 1;
	step = e.steps.wrapAt(e.idx);
	if (~perform_step.value(step).not, {
		e.idx = e.idx + 1;
	});

};


// each step is an array: [function, text, <,color>]
e.steps = [
	[{
		~jl_start_record.value(0);
	}, "rec jl0"],

	[{
		~jl_stop_record.value(0);
	}, "play jl0"],

	[{
		~jl_start_record.value(1);
	}, "rec jl1"],

	[{
		~jl_stop_record.value(1);
	}, "play jl1"],

	[{
		~jl_start_record.value(2);
	}, "rec jl2"],

	[{
		~jl_stop_record.value(2);
	}, "play jl2"],

	[{
		~jl_start_record.value(3);
	}, "rec jl3"],

	[{
		~jl_stop_record.value(3);
	}, "play jl3"],

	//// part 1
	[{

		x.value("_vlabeet.scd");
	}, "vla bbt"],

	[{
		~vla_loop_del = Synth.new(\bufdelay_fb, [
			\buf, ~vla_loop1_buf.bufnum,
			\in, ~vla_in_b.index,
			\delaytime, 60/80,
			\amp, -14.0.dbamp,
			\out, 0;
		], ~xg);

		~vla_loop_start = SystemClock.seconds;
		//		x.value("_sines.scd");
	}, "recording [viola loop 1]"],

	//		{
	//			x.value("_threshchop.scd");
	//	},

	[{
		arg val, time;
		~vla_loop_del.set(\delaytime, (SystemClock.seconds - ~vla_loop_start) / 32.0);
		~vla_loop_del.set(\amp, -9.dbamp);
		~vla_loop_del.set(\feedback, -12.dbamp);
		// ~notify.value("playback vla loop 1");
		~vla_loop1_buf.copyData(~vla_chord1_buf, 0, 0, -1);
	}, "save vla 1"],
	[{
		~vla_grain1_rec = Synth.new(\rec_loop, [\buf, ~vla_grain1_buf.bufnum, \in, ~vla_in_b.index], ~xg);
	}, "recording vla grain 1"],
	[{
		arg val, time;
		time.postln;
		~sine_r.stop;
		~vla_loop_del.set(\amplag, time * 0.25);
		~vla_loop_del.set(\amp, 0);
		~vla_loop_del.set(\feedback, 0.0);
		~vla_loop_del.set(\inputamp, 0.0);
		~vla_grain1_rec.run(false);
		~vla_grain1_play = Group.new;
		5.do({ arg i;
			Synth.new(\chopgrain, [
				\out, (i%2) + 4,
				\buf, ~vla_grain1_buf.bufnum,
				\rate, 2**(i),
				\choprate, 1.0 / (time / 16) * (i+1),
				\posrate, 1/(i+3),
				\rel, 60.0 + i,
				\atk, 14.0,
				\level, (i * -3).dbamp * -7.dbamp
			], ~vla_grain1_play);
		});
	}, "play vla grain 1"],

	// modulate to d
	[{
		~vla_grain1_play.set(\gate, 0);
		x.value("_moveloops.scd");
	}, "fade out grains / modulate"],

	//// part 2
	//	Routine {
	[{
		~tempo = 155/120;
		~vox_delay = Synth.new(\echo_buf, [\in, ~
			vox_in_b.index, \buf, ~vox_echo1_buf.bufnum,
			\time, ~tempo,
			\out, 4,
			\amp, 0.125], ~xg);
		~chopr.stop;
		~chopr2.stop;
		~vlabeet_rbase = 0.75;
		~vlabeet_dur_base = 0.5;
		~vlabeet_t = ~tempo;
		~vlabeet_level = 1.0;
	}, "part 2 - vox echo", Color.new(1.0, 1.0, 0.0)],
	[{
		~vla_loop_del.set(\amplag, 0.0);
		~vla_loop_del.set(\amp, 0.0);
		~vla_loop_del.set(\feedback, 1.0);
		~vla_loop_del.set(\inputamp, 1.0);
		~vla_loop_del.set(\buf, ~vla_loop2_buf.bufnum);

	}, "recording [viola loop 2]", Color.red],
	[{
		arg val, time;
		//		time.postln;
		~vla_loop_del.set(\delaytime, ~tempo * 32);

		// i don't want to hear this today
		// ~vla_loop_del.set(\amp, 1.0);

		//		time.postln;
		~tempo = time* 2.0;
		~bufbass = Synth.new(\buf_ringz_lpf_env, [
			\out, 4,
			\buf, ~vla_loop1_buf.bufnum,
			\pulsehz, 1.0 / ~tempo,
			\lpfhz, 110 * 4 / 3,
			\ringhz, 55 * 4 / 3,
			\rate, 0.25,
			\ringdecay, 0.007,
			\envdecay, 20.0,
			\amp, -18.dbamp
		]);
		/*
		~bufbass.free;
		*/



		/// grab first two take only
		SystemClock.sched(time, {
			~vla_loop2_buf.copyData(~vla_chord2_buf, 0, 0, -1);
			nil
		});
	}, "playback [viola loop 2]", Color.green],
	[{
		~vla_loop_del.set(\inputamp, 0.0);
		~vox_echo_pre = Synth.new(\cmpcho, [
			\in, ~vox_in_b.index,
			\out, ~vox_in_b.index, \time, ~tempo /3, \maxtime, ~tempo, \amp, 0.7], ~ig, \addAfter);
		~vox_echo_out = Synth.new(\cmpcho, [
			\in, ~vox_in_b.index,
			\out, 4,
			\time, ~tempo /3, \maxtime, ~tempo, \amp, -9.dbamp], ~vox_echo_pre, \addAfter);

		~vox_delay2 = Synth.new(\echo_buf, [
			\in, ~vox_in_b.index,
			\buf, ~vox_echo2_buf.bufnum, \time, ~tempo * 4 * 3,
			\out, 5, \amp, -9.dbamp], ~vox_echo_pre, \addAfter);

		~vox_delay.set(\amp, -12.dbamp);
		~vox_del_switch = Routine({ inf.do({
			arg i;
			~vox_delay.set(\time, ~tempo * ((i+1) * 4).wrap(1, 7) / 4);
			(~tempo * 8).wait;
		}) }).play;
	}, "stop recording [viola loop 2]", Color.grey],
	[{
		~vla_loop_del.set(\inputamp, 1.0);
		~vla_loop_del.set(\feedback, 0.5);

		~vla_loop_del.set(\amp, 1.0);
		~vla_delay = Synth.new(\echo_buf, [
			\in, ~vla_in_b.index, \buf, ~vla_echo_buf.bufnum, \time,~tempo * 4 * 3,
			\out, 4,
			\amp, -6.dbamp], ~xg);
	}, "attempt to overwrite [viola loop 2] ?"],
	[{
		~vla_loop_del.set(\amplag, ~tempo * 8.0);
		~vla_loop_del.set(\amp, 0.0);
	}, "release [viola loop 2]"],
	[{
		x.value("_chordgrains.scd");
		~vlabeet_r.stop;
		~vox_del_switch.stop;
	}, "chordgrains"],
	[{
		~chordgrains_r.stop;
	}, "end"],
	[{

		Routine {
			~vla_loop_del.free;
			~vla_delay.free;
			~vla_delay3.free;
			~vox_delay.free;
			~vox_delay2.free;
			//~vox_delay3.free;
		}.play;
	}, "stop everything"]
];