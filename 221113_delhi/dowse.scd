Routine {
	var inb = ~vla_b.index;

	var t0;
	var d = ();

	// pitch_b = Bus.control(s, 2);
	// cent_b = Bus.control(s, 1);
	// flat_b = Bus.control(s, 1);
	d.bus = Bus.control(s, 5);

	t0 = SystemClock.seconds;

	d.syn = {
		var input, pitch, cent, flat;
		input = In.ar(inb);
		pitch = Pitch.kr(input, clar:1);
		cent = SpecCentroid.kr(input);
		flat = SpecFlatness.kr(input);
		Out.kr(d.bus.index, pitch);
		Out.kr(d.bus.index + 2, cent);
		Out.kr(d.bus.index + 3, flat);
		Out.kr(d.bus.index + 4, Amplitude.kr(input));
	}.play(~xg);

	s.sync;

	d.data = List.new;

	d.grab = {
		arg callback;
		var now = SystemClock.seconds;
		var dur = now - t0;
		var n = d.data.size;

		var ev = (
			pitch:nil,
			clar:nil,
			cent:nil,
			flat:nil,
			amp:nil,
			dur:nil,
		);

		t0 = now;

		d.bus.getn(5, {
			arg vals;
			ev.pitch = vals[0];
			ev.clar = vals[1];
			ev.cent = vals[2];
			ev.flat = vals[3];
			ev.amp = vals[4];

			if (n > 0, {
				d.data[n-1].dur = dur;
			});

			d.data.add(ev);

			"wtf! callback?".postln;
			callback.postln;

//			if (callback.notNil, {
				callback.value(ev);
//			});

		});
		nil
	};

	~dowse = d;

	postln("done initializing dowser");
	c.unhang;
}.play;