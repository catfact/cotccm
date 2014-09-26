~grains_amp = -10.dbamp;

Routine {

	SynthDef.new(\krbuspangrain, {
		arg buf=0, out=0, amp=0.25,
		trig_bus = 0,
		pos_bus = 1,
		dur_bus = 2,
		rate_bus = 3,
		pan_bus = 4,
		maxgrains = 64,
		env_buf = -1,
		amplag=4.0;

		var trig, pos, dur,
		rate, pan,
		snd;

		trig = In.kr(trig_bus);
		pos = In.kr(pos_bus);
		dur = In.kr(dur_bus);
		rate = In.kr(rate_bus);
		pan = In.kr(pan_bus);

		amp = Lag.kr(amp, amplag);

		snd = GrainBuf.ar(
			numChannels:2,
			trigger:trig,
			dur:dur,
			sndbuf:buf,
			rate:rate,
			pos:pos,
			interp:2,
			pan:pan,
			envbufnum:env_buf,
			maxGrains:maxgrains,
			mul:amp);

		Out.ar(out, snd);
	}).send(s);

	s.sync;

	SynthDef.new(\krbuspangrain, {
		arg buf=0, out=0, amp=0.25,
		trig_bus = 0,
		pos_bus = 1,
		dur_bus = 2,
		rate_bus = 3,
		pan_bus = 4,
		maxgrains = 64,
		env_buf = -1,
		amplag=4.0;

		var trig, pos, dur,
		rate, pan,
		snd;

		trig = In.kr(trig_bus);
		pos = In.kr(pos_bus);
		dur = In.kr(dur_bus);
		rate = In.kr(rate_bus);
		pan = In.kr(pan_bus);

		amp = Lag.kr(amp, amplag);

		snd = GrainBuf.ar(
			numChannels:2,
			trigger:trig,
			dur:dur,
			sndbuf:buf,
			rate:rate,
			pos:pos,
			interp:2,
			pan:pan,
			envbufnum:env_buf,
			maxGrains:maxgrains,
			mul:amp);

		Out.ar(out, snd);
	}).send(s);
	~gr = Array.newClear(4);
	~grg = Group.new(s);
	0.01.wait;
	Routine { 4.do({ arg i;
		~gr[i] = BusGrainer.new(s, ~bbuf, ~grg, 0);
		0.125.wait;
		~gr[i].grtrig_s.set(\hz, 6 + (i * 2));
		~gr[i].grdur_b.set(4.0 / (6 + (i * 2)));
		~gr[i].grpos_s.set(\hz, 1 / (i + 4) * 1.0 / ~bbuf.duration);
		~gr[i].gr_s.set(\amp, ~grains_amp);
		(8.0 + i).wait;
	}); }.play;



/*
~gr.do({ arg gr; gr.gr_s.set(\amp, -6.dbamp); };);

~bbuf.plot;

	~gr[0].grpos_b.set(14.0);
	~gr[1].grpos_b.set(24.0);
	~gr[2].grpos_b.set(12.0);
	~gr[3].grpos_b.set(4.0);

	/////	//////  i like this ---->>>
~gr.do({ arg gr, i; var rate; rate = ~analist[i].cent / ~analist[i].pitch;  while( {rate > 2.0}, {rate = rate / 2; }); rate.postln; gr.grrate_b.set(rate ); });
	////////////


~gr.do({ arg gr, i; var rate = i + 1; while( {rate > 2.0}, {rate = rate / 2; }); gr.grrate_b.set(rate); });


	~gr.do({ arg gr, i; gr.grtrig_s.set(\hz, 2 + i) });
	~gr2.do({ arg gr, i; gr.grtrig_s.set(\hz, 4 + (i * 0.5)) });

	~grg.set(\amp, 0.0);


*/

}.play;