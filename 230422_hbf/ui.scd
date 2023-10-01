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
	z.pb[0].pb.set(\attack, 2);
	z.pb[0].pb.set(\release, 2);
	z.pb[0].pb.set(\sustain, z.cap[0].dur - (2+2));
	z.pb[0].pb.set(\lpf, 4000);

	z.pb[1].pb.set(\gate, 1);
	z.pb[1].pb.set(\rate, 1/3);
	z.pb[1].pb.set(\pos, 1);
	z.pb[1].pb.set(\attack, 2);
	z.pb[1].pb.set(\release, 2);
	z.pb[1].pb.set(\sustain, z.cap[0].dur - (2+2));
	z.pb[1].pb.set(\lpf, 4000);
};

~play_high_cluster = {
	z.pb[0].pb.set(\gate, 1);
	z.pb[0].pb.set(\rate, 1/3);
	z.pb[0].pb.set(\pos, -1);
	z.pb[0].pb.set(\attack, 2);
	z.pb[0].pb.set(\release, 2);
	z.pb[0].pb.set(\sustain, z.cap[0].dur - (2+2));

	z.pb[1].pb.set(\gate, 1);
	z.pb[1].pb.set(\rate, 1/3);
	z.pb[1].pb.set(\pos, 1);
	z.pb[1].pb.set(\attack, 2);
	z.pb[1].pb.set(\release, 2);
	z.pb[1].pb.set(\sustain, z.cap[0].dur - (2+2));

};

/*
~start_cap.value;
~stop_cap.value.postln;

~play_low_pair.value;

z.cap[0].buf.plot;
*/