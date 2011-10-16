~swyc_ok = false;

Routine {

// synthdefs
x.value("_defs.scd");
s.sync;

//// background loop engine
x.value("_justloops.scd");

s.sync;

////// buffers
~vla_loop1_buf = Buffer.alloc(s, s.sampleRate * 300.0, 1, completionMessage: { });
~vla_grain1_buf = Buffer.alloc(s, s.sampleRate * 120.0, 1, completionMessage: { });
~vla_loop2_buf = Buffer.alloc(s, s.sampleRate * 120.0, 1, completionMessage: { });

~vox_echo1_buf = Buffer.alloc(s, s.sampleRate * 60.0, 1, completionMessage: { });
~vox_echo2_buf = Buffer.alloc(s, s.sampleRate * 60.0, 1, completionMessage: { });
~vla_echo_buf = Buffer.alloc(s, s.sampleRate * 60.0, 1, completionMessage: { });

s.sync;

0.1.wait;

////// groups
~ig = Group.new(s);
~xg = Group.after(~ig);
~og = Group.after(~xg);

////// busses, i/o
~vla_in_b = Bus.audio(s, 1);
~vla_adc = Synth.new(\adc, [\in, 1, \out, ~vla_in_b.index], ~ig);
~vox_in_b = Bus.audio(s, 1);
~vox_adc = Synth.new(\adc, [\in, 0, \out, ~vox_in_b.index], ~ig);

// flag for start/stop
~vla_loop_clear = true;

~post_cc = CCResponder({
	arg src, chan, num, val;
	[src, chan, num, val].postln;
}, nil, nil, nil);


// timers
~event_tap = CfTapper.new;
~event_tap.tap;

~quads[3].toggle = false;
~quads[3].onAction = {
	~event_tap.tap;
	if (~event_tap.time > 1.0, {
		~events.next.value(1, ~event_tap.time);
	});
};

s.sync;

~events = Pseq([

	///// background vla loops
	{
		~jl_start_record.value(0);
		~notify.value("record justloop 0");
	},
	{
		~jl_stop_record.value(0);
		~notify.value("play justloop 0");
	},
	{
		~jl_start_record.value(1);
		~notify.value("record justloop 1");
	},
	{
		~jl_stop_record.value(1);
		~notify.value("play justloop 1");
	},
	{
		~jl_start_record.value(2);
		~notify.value("record justloop 2");
	},
	{
		~jl_stop_record.value(2);
		~notify.value("play justloop 2");
	},
	{
		~jl_start_record.value(3);
		~notify.value("record justloop 3");
	},
	{
		~jl_stop_record.value(3);
		~notify.value("play justloop 3");
	},

	//// part 1
	{	
		~vla_loop1_rec = Synth.new(\rec_loop, [\buf, ~vla_loop1_buf.bufnum, \in, ~vla_in_b.index], ~xg);
		~notify.value("recording [viola loop 1]");
		x.value("_sines.scd");
	},
	{	
		x.value("_threshchop.scd");
		~notify.value("noise chops");
	},
	{	arg val, time;
		~vla_loop1_rec.run(false); 
		~vla_loop1_play = Synth.new(\play_loop, [\buf, ~vla_loop1_buf.bufnum, \looptime, time], ~xg);
		~notify.value("stop recording, playback [viola loop 1]");
	},
	{
		~notify.value("recording [viola grain 1]");
		~vla_grain1_rec = Synth.new(\rec_loop, [\buf, ~vla_grain1_buf.bufnum, \in, ~vla_in_b.index], ~xg);
	},
	{	
		arg val, time;
		~sine_r.stop;
		~notify.value("play [viola grain 1]");
		~vla_loop1_play.set(\rel, time);
		~vla_loop1_play.set(\gate, 0);
		~vla_grain1_rec.run(false);
		~vla_grain1_play = Group.new;
		5.do({ arg i;
			Synth.new(\chopgrain, [
				\buf, ~vla_grain1_buf.bufnum,
				\rate, 2**(i),
				\choprate, 1.0 / (time / 16) * (i+1),
				\posrate, 1/(i+3),
				\rel, 60.0 + i,
				\atk, 4.0,
				\level, (i * -3).dbamp * -7.dbamp
			], ~vla_grain1_play);
		});
	},
	
	// modulate to d
	{
		~notify.value("fade out vla grains, modulate loop");
		~vla_grain1_play.set(\gate, 0);
		x.value("_moveloops.scd");
	},
	
	//// part 2
	{
		~tempo = 0.9;
		~vox_delay = Synth.new(\echo_buf, [\in, ~vox_in_b.index, \buf, ~vox_echo1_buf.bufnum, \time, ~tempo, \out, 0, \amp, 0.5], ~xg);
		~chopr.stop;
		~chopr2.stop;
		~notify.value("PART 2 [vox echo]");
	},
	{
		~vla_loop2_rec = Synth.new(\rec_loop, [\buf, ~vla_loop2_buf.bufnum, \in, ~vla_in_b.index, \looptime, ~tempo * 2 * 16, \prelevel, 1.0], ~xg);
		~notify.value("recording [viola loop 2]", Color.red);
	},
	{	arg val, time;
		~vla_loop2_play = Synth.new(\play_loop, [\buf, ~vla_loop2_buf.bufnum, \looptime, time * 2.0], ~xg);
		~vla_loop2_rec.set(\looptime, time * 2.0);
		~notify.value("playback [viola loop 2]", Color.green);
		~tempo = time / 8;
		~bufbass = Synth.new(\buf_ringz_lpf_env, [
			\buf, ~vla_loop2_buf.bufnum,
			\pulsehz, 1.0 / time,
			\lpfhz, 110 * 4 / 3,
			\ringhz, 55 * 4 / 3,
			\rate, 0.25,
			\ringdecay, 0.007,
			\envdecay, 20.0,
			\out, 0,
			\amp, -18.dbamp
		]);

	},
	{
		~notify.value("stop recording [viola loop 2]", Color.grey);
		~vla_loop2_rec.run(false); 
		~vox_echo_pre = Synth.new(\cmpcho, [\in, ~vox_in_b.index, \out, ~vox_in_b.index, \time, ~tempo /3, \maxtime, ~tempo, \amp, 0.7], ~ig, \addAfter);
		~vox_echo_out = Synth.new(\cmpcho, [\in, ~vox_in_b.index, \out, 0, \time, ~tempo /3, \maxtime, ~tempo, \amp, 0.7], ~ig, \addAfter);
		
		~vox_delay2 = Synth.new(\echo_buf, [\in, ~vox_in_b.index, \buf, ~vox_echo2_buf.bufnum, \time, ~tempo * 4 * 3, \out, 0, \amp, -4.dbamp], ~xg);
		~vox_delay.set(\amp, -6.dbamp);
		~vox_del_switch = Routine({ inf.do({
			arg i;
			~vox_delay.set(\time, ~tempo * ((i+1) * 4).wrap(1, 7) / 4);
			(~tempo * 8).wait;
		}) }).play;
	},
		
	{	~notify.value("attempt to overwrite [viola loop 2] ?");
		//~vox_echo_pre.set(\in, ~vla_in_b.index);
		~vla_loop3_rec = Synth.new(\rec_loop, [\buf, ~vla_loop2_buf.bufnum, \in, ~vla_in_b.index, \looptime, ~tempo * 2 * 16, \prelevel, 0.0], ~xg);

		~vla_loop2_rec.run(true);
		~vla_loop2_rec.set(\prelevel, 0.0);
		~vla_delay = Synth.new(\echo_buf, [\in, ~vla_in_b.index, \buf, ~vla_echo_buf.bufnum, \time, ~tempo * 4 * 3, \out, 0, \amp, -6.dbamp], ~xg);
	},
	{	~notify.value("release [viola loop 2]");
		~vla_loop2_play.set(\rel, ~tempo * 8.0);
		~vla_loop2_play.set(\gate, 0);
	},
	{
		~notify.value("chordgrains");
		x.value("_chordgrains.scd");
		~vox_del_switch.stop;
	},
	{	
		~notify.value("end");
		~chordgrains_r.stop;
	}, 
	{
		~notify.value("stop everything");		
		
		Routine {
			~vla_delay.free;
			~vla_delay3.free;
			~vox_delay.free;
			~vox_delay2.free;
			~vox_delay3.free;
		}.play;
	}
]).asStream;

/*
~events.reset
*/

~notify = { arg string, color;
	var win, text;
	{
		win = SCWindow.new(nil, SCWindow.screenBounds.insetBy(100));
		if(color.isNil, { color = Color.new(1.0, 1.0.rand, 1.0.rand, 0.5); });
		win.view.background = color; 
		text = SCStaticText(win, win.view.bounds);
		text.font = Font("Andale Mono", 54);
		text.string = string;
		win.front;
		string.postln;
	//	win.refresh;
		AppClock.sched(4.0, {win.close; nil});
	}.defer;
};

~notify.value("save what you can", Color.new(0.1, 0.1, 0.1));

//// loops
x.value("_justloops.scd");

}.play;