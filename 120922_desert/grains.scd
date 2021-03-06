~hzl;
Routine {
	~chopr.do({ arg r;  r.stop; });
	/*
	~amp = -16.dbamp;
	~rate = 0.5;
	~pos = 20.0;
	~hzi = 40;
	~hz = ~hzl[~hzi];
	~rq = 0.4;
	~atk = 0.01;
	~rel = 4.0;
	~tw = 12.0;
	~crchop.value(0);
	~hzi = ~hz + 2;
	~hz = ~hzl[~hzi];
	~pos = 22.0;
	~atk = 2.0;
	~crchop.value(1);
	
	8.0.wait;
	
	~pos = 30.0;
	~hzi = ~hz + 2;
	~hz = ~hzl[~hzi];
	~pos = 64.0;
	~atk = 0.1;
	~rel = 4.0;
	~tw = 15;
	~crchop.value(2);

	~hzi = ~hz + 2;
	~hz = ~hzl[~hzi];
	~pos = 32.0;
	~atk = 2.0;
	~crchop.value(3);
	*/

	Routine { 6.do({ arg i;
		~rate = i % 2 + 1;
		~hz = 400 + (i * 2);
		~atk = 0.01 + i;
		~rel = 8 - i;
		~amp = -24.dbamp;
		~pos = 60 + (i * 4);
		~tw = 16 + (i * 2);
		~rq = 0.2;
		~crchop.value(i + 4);
		4.0.wait;
	}); }.play;




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



~gr = Array.newClear(4);
0.1.wait;
Routine { 4.do({ arg i;
	~gr[i] = BusGrainer.new(s, ~bbuf, s, 0);
	0.125.wait;
	~gr[i].grtrig_s.set(\hz, 6 + (i * 2));
	~gr[i].grdur_b.set(4.0 / (6 + (i * 2)));
	~gr[i].grpos_s.set(\hz, 1 / (i + 4) * 1.0 / ~bbuf.duration);
	~gr[i].gr_s.set(\amp, -24.dbamp);
	2.0.wait;
}); }.play;


}.play;