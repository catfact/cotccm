~start_cap = { arg i=0;
	z.cap[i].start;
};

~stop_cap = { arg i=0;
	z.cap[i].stop;
	/*
	z.cap
	*/
};

~play_low_pair = {
	z.pb[0].pb.set(\gate, 1);
	z.pb[0].pb.set(\rate, 1/3);
	z.pb[0].pb.set(\pos, -1);

	z.pb[1].pb.set(\gate, 1);
	z.pb[1].pb.set(\rate, 1/3);
	z.pb[1].pb.set(\pos, 1);
};

~play_hiigh_cluster = {
};

/*
~start_cap.value;
~stop_cap.value.postln;
z.cap[0].buf.plot;
*/