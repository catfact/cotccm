~swyc_ok = false;

Routine {

	// synthdefs
	x.value("_defs.scd");
	s.sync;

	//// background loop engine
	x.value("_justloops.scd");

	s.sync;

	////// buffers
	~vla_grain1_buf = Buffer.alloc(s, s.sampleRate * 120.0, 1, completionMessage: { });
	~vla_loop1_buf = Buffer.alloc(s, s.sampleRate * 300.0, 1, completionMessage: { });
	~vla_loop2_buf = Buffer.alloc(s, s.sampleRate * 120.0, 1, completionMessage: { });
	~vla_chord1_buf = Buffer.alloc(s, s.sampleRate * 32, 1, completionMessage: { });
	~vla_chord2_buf = Buffer.alloc(s, s.sampleRate * 32, 1, completionMessage: { });

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

	// timers
	~event_tap = CfTapper.new;
	~event_tap.tap;

	~do_next_event = {
		~event_tap.tap;
		if (~event_tap.time > 1.0, {
			~events.adv(1, ~event_tap.time);
		});
	};

	s.sync;

	x.value("_events.scd");

	~notify.value("save what you can", Color.new(0.1, 0.1, 0.1));

	//// loops
	x.value("_justloops.scd");

}.play;