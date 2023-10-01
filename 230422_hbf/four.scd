Routine {
	p = Synth.new(\play_inf_resf, [\buf, z.cap[1].buf.bufnum, \sustain, z.cap[0].dur - (2+2)]);

	s.sync;
	p.set(\gate, 1);
	p.set(\rate, 4/3);
	p.set(\pos, -0.9);

	q = Synth.new(\play_inf_resf, [\buf, z.cap[1].buf.bufnum, \sustain, z.cap[0].dur - (2+2)]);
	s.sync;
	q.set(\rate, 3/2);
	q.set(\gate, 1);
	q.set(\pos, 0.9);

	p.set(\fcBase, 800);
	p.set(\resBlend, 0.8);
	p.set(\centroidFcAmount, 1);
	p.set(\bwr, 0.24);

	q.set(\fcBase, 800);
	q.set(\resBlend, 0.8);
	q.set(\centroidFcAmount, 1);
	q.set(\bwr, 0.24);

	~pr = Routine { inf.do {
		var rate = [6/5, 16/9].choose;
		if (0.25.coin, { rate = rate * -1; });
		postln("prate: " ++ rate);
		p.set(\rate, rate);
		(z.cap[1].dur * (0.25 + 0.25.rand)).wait;
	} }.play;

	~qr = Routine { inf.do {
		var rate =  [4/3, 8/5].choose;
		if (0.25.coin, { rate = rate * -1; });
		postln("qrate: " ++ rate);
		q.set(\rate, rate);
		(z.cap[1].dur * (0.25 + 0.25.rand)).wait;
	} }.play;

}.play;
