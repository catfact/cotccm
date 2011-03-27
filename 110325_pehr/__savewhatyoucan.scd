~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };
~topdoc = Document.current;
{ ~topdoc.background_(Color.white); }.defer;


s = Server.default;
s.options.memSize = 8192 * 64;
s.boot;
s.waitForBoot { Routine {
	
// synthdefs
x.value("_defs.scd");
// hid
{ x.value("_hid.scd"); }.defer;


s.sync;

////// buffers
~vla_loop1_buf = Buffer.alloc(s, s.sampleRate * 300.0, 1, completionMessage: { });
~vla_grain1_buf = Buffer.alloc(s, s.sampleRate * 120.0, 1, completionMessage: { });
~vla_loop2_buf = Buffer.alloc(s, s.sampleRate * 120.0, 1, completionMessage: { });

~vox_echo1_buf = Buffer.alloc(s, s.sampleRate * 60.0, 1, completionMessage: { });
~vox_echo2_buf = Buffer.alloc(s, s.sampleRate * 60.0, 1, completionMessage: { });
~vla_echo_buf = Buffer.alloc(s, s.sampleRate * 60.0, 1, completionMessage: { });

////// groups
~ig = Group.new(s);
~xg = Group.after(~ig);
~og = Group.after(~xg);

////// busses, i/o
~vla_in_b = Bus.audio(s, 1);
~vla_adc = Synth.new(\adc, [\in, 1, \out, ~vla_in_b.index], ~ig);
~vox_in_b = Bus.audio(s, 1);
~vox_adc = Synth.new(\adc, [\in, 0, \out, ~vox_in_b.index], ~ig);

////// MIDI from akai mpkmini
// flag for start/stop
~vla_loop_clear = true;

~post_cc = CCResponder({
	arg src, chan, num, val;
	[src, chan, num, val].postln;
}, nil, nil, nil);


// timer
~event_tap = CfTapper.new;
~event_tap.tap;

// record/play/stop switch
/*
~pad_r = CCResponder({
	arg src, chan, num, val;
	~pad_tap.tap;
	~events.next.value(val, ~pad_tap.time);
}, nil, nil, 9); // top row, left pad of mpkMini
*/

//????
0.1.wait;

~switch_func = { arg val;
	if( val>0, {
		~topdoc.background_(Color.new(1.0, 0.5, 0.5));
		~event_tap.tap;
		~events.next.value(val, ~event_tap.time);
	}, {
		~topdoc.background_(Color.white);
	});
};


~events = Pseq([

	//// part 1
	
	{	
		~vla_loop1_rec = Synth.new(\rec_loop, [\buf, ~vla_loop1_buf.bufnum, \in, ~vla_in_b.index], ~xg);
		~notify.value("recording [viola loop 1]");
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
		~notify.value("play [viola grain 1]");
		~vla_loop1_play.set(\rel, 4.0);
		~vla_loop1_play.set(\gate, 0);
		~vla_grain1_rec.run(false);
		~vla_grain1_play = Group.new;
		5.do({ arg i;
			Synth.new(\chopgrain, [
				\buf, ~vla_grain1_buf.bufnum,
				\rate, 2**(i),
				\choprate, 1.0 / (time / 16) * (i+1),
				\posrate, 1/(i+3),
				\rel, 8.0 + i,
				\atk, 4.0,
				\level, (i * -2).dbamp * -4.dbamp
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
		~notify.value("PART 2 [vox echo]");
	},
	{
		~vla_loop2_rec = Synth.new(\rec_loop, [\buf, ~vla_loop2_buf.bufnum, \in, ~vla_in_b.index, \looptime, ~tempo * 4 * 9, \prelevel, 1.0], ~xg);
		~notify.value("recording [viola loop 2]", Color.red);
	},
	{	arg val, time;
		~vla_loop2_play = Synth.new(\play_loop, [\buf, ~vla_loop2_buf.bufnum, \looptime, ~tempo * 4 * 16], ~xg);
		~notify.value("playback [viola loop 2]", Color.green);
	},
	{
		~notify.value("stop recording [viola loop 2]", Color.grey);
		~vla_loop2_rec.run(false); 
		~vox_echo_pre = Synth.new(\cmpcho, [\in, ~vox_in_b.index, \out, ~vox_in_b.index, \time, ~tempo /3, \maxtime, ~tempo, \amp, 0.7], ~ig, \addAfter);
		~vox_echo_out = Synth.new(\cmpcho, [\in, ~vox_in_b.index, \out, 0, \time, ~tempo /3, \maxtime, ~tempo, \amp, 0.7], ~ig, \addAfter);
		
		~vox_delay2 = Synth.new(\echo_buf, [\in, ~vox_in_b.index, \buf, ~vox_echo2_buf.bufnum, \time, ~tempo * 4 * 3, \out, 0, \amp, -6.dbamp], ~xg);
		~vox_delay.set(\amp, -8.dbamp);
		~vox_del_switch = Routine({ inf.do({
			arg i;
			~vox_delay.set(\time, ~tempo * ((i+1) * 4).wrap(1, 7) / 4);
			(~tempo * 8).wait;
		}) }).play;
	},
		
	{	~notify.value("attempt to overwrite [viola loop 2] ?");
		//~vox_echo_pre.set(\in, ~vla_in_b.index);
		//~vla_loop2_rec.run(true);
		//~vla_loop2_rec.set(\prelevel, 0.0);
		~vla_delay = Synth.new(\echo_buf, [\in, ~vla_in_b.index, \buf, ~vla_echo_buf.bufnum, \time, ~tempo * 4 * 3, \out, 0, \amp, -6.dbamp], ~xg);
	},
	{	~notify.value("release [viola loop 2]");
		~vla_loop2_play.set(\rel, ~tempo * 8.0);
		~vla_loop2_play.set(\gate, 0);
	},
	{
		x.value("_chordgrains.scd");
		~vox_del_switch.stop;
	},
	{	
		~chordgrains_r.stop;
	}
]).asStream;

/*
~events.reset
*/

~notify = { arg string, color;
	var win, text;
	{
		win = SCWindow.new(nil, Rect(0, 0, 800, 180));
		if(color.isNil, { color = Color.new(1.0, 1.0.rand, 1.0.rand, 0.5); });
		win.view.background = color; 
		text = SCStaticText(win, win.view.bounds);
		text.font = Font("Andale Mono", 54);
		text.string = string;
		win.front;
		string.postln;
	//	win.refresh;
		AppClock.sched(1.5, {win.close; nil});
	}.defer;
};

~notify.value("save what you can", Color.new(0.1, 0.1, 0.1));

//// loops
x.value("_justloops.scd");

}.play; }; // waitforboot