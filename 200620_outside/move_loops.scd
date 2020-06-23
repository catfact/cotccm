
~inc_pos = { arg i, inc;
	~tremloop.loop_data[i].pos = (~tremloop.loop_data[i].pos + inc)
	.wrap(0, ~tremloop.buflen - ~tremloop.loop_data[i].dur);
	[i, ~tremloop.loop_data[i].pos].postln;
};


~move_loops_f = {
	8.do { arg i;
		if (0.25.coin, { ~inc_pos.value(i, 0.2.rand); });
	}
};

~move_loops_t = 2;
~move_loops_r = Routine { inf.do {
	~move_loops_f.value;
	~move_loops_t.wait;
} }.play;
	