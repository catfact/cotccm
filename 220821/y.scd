// assume `x` also runs (for synthdefs)

Server.default.waitForBoot {
	// vocal loop
	c = Buffer.alloc(s, s.sampleRate * 10, 1);

	~pre = 1;
	q = { Synth.new(\rec_1shot, [\buf, c.bufnum, \pre, ~pre, \in, 1]) };


	/*
	q.value;
	*/

	/*
	b.plot
	c.plot
	*/


	w = 13.0;
	~hpf = 200;
	~lpf = 18000;

	~wr = [1, 2, 3, 12/5];

	/*
	~wr = ~wr * 5/4 / 4;
	~wr = ~wr * 5/4;

	*/

	~amp = 0.5;

	p = Routine { inf.do {
		~wr.size.do({ arg i;
			var pan = 0.4.rand2;
			var rate = ~wr[i] * (2 ** ((1/48).rand2));
			var pos = 0.5.rand;
			var syn = Synth.new(\play_1shot, [
				\buf, c.bufnum, \rate, rate, \pos, pos, \pan, pan, \amp, ~amp,
				\hpf, ~hpf,
				\lpf, ~lpf
			]);
			syn.postln;
			(w/8).rand.wait;
		});
		(w + (w/4).rand).wait;
	} };

	/*

	p.play;
	*/


	/*
	p.stop;
	*/
}