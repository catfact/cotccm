// 1/8th speed position
~grainposrate = 0.125;

SynthDef.new(\krbuspangrain, {
	arg buf=0, out=0, amp=1.0,
		trig_bus = 0,
		pos_bus = 1,
		dur_bus = 2,
		rate_bus = 3,
		pan_bus = 4,
		maxgrains = 64,
		env_buf = -1;

	var trig, pos, dur,
		rate, pan,
		snd;
	
	trig = In.kr(trig_bus);
	pos = In.kr(pos_bus);
	dur = In.kr(dur_bus);
	rate = In.kr(rate_bus); 
	pan = In.kr(pan_bus);
	
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
}).store;
	
~grtrig_b = Bus.control(s, 1);
~grpos_b = Bus.control(s, 1);
~grdur_b = Bus.control(s, 1);
~grrate_b = Bus.control(s, 1);
~grpan_b = Bus.control(s, 1);

~gr_s = Synth.new(\krbuspangrain, [
	\out, 0,
	\buf, ~buf.bufnum,
	\trig_bus, ~grtrig_b.index,
	\pos_bus, ~grpos_b.index,
	\dur_bus, ~grdur_b.index,
	\rate_bus, ~grrate_b.index,
	\pan_bus, ~grpan_b.index
], s);


// test: impulse for trig
~grtrig_s = SynthDef.new(\krbusgraintrigpulse, {
	arg out=0, hz=8.0;
	Out.kr(out, Impulse.kr(hz));
}).play(~gr_s, [\out, ~grtrig_b.index], \addBefore);

// test: sawtooth for pos
~grpos_s = SynthDef.new(\krbusgrainpossaw, {
	arg out=0, hz=0.01, iphase=0;
	Out.kr(out, LFSaw.kr(hz, iphase, 0.5, 0.5));
}).play(~gr_s, [\out, ~grpos_b.index, \hz, ~grainposrate * 1.0 / ~buflen], \addBefore);

~grdur_b.set(0.5);
~grrate_b.set(1.0);
~grpan_b.set(0.0);

~grainposrate = 0.1;
~grpos_s.set(\hz, ~grainposrate * 1.0 / ~buflen);

~grtrig_s.set(\hz, 4.0);

/*
~grtrig_s.run(false);
~gr_s.free;
~gr_s.trace
*/