~cut_move_t = 0.2;
~cut_move_r = Routine { inf.do {
	~cut_move_t.wait;

	if(0.25.coin, {

		n.sendMsg("/set/param/cut/loop_start", 1, 0.2 + 0.1.rand);
		n.sendMsg("/set/param/cut/loop_end", 1, 0.93 + 0.5.rand);
		n.sendMsg("/set/param/cut/rate", 1, [3/2, 5/4, 2, 1].choose);
	});

	if(0.25.coin, {

		n.sendMsg("/set/param/cut/loop_start", 0, 0.43 + 0.1.rand);
		n.sendMsg("/set/param/cut/loop_end", 0, 1.7 + 0.5.rand);
		n.sendMsg("/set/param/cut/rate", 0, [3/2, 5/4, 2, 1].choose);
	});
} }.play;

/*
~cut_move_r.stop;
*/