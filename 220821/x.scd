Routine {
	s = Server.local;
	s.waitForBoot;

	// vla buf
	b = Buffer.alloc(s, s.sampleRate * 16, 1);
	s.sync;

	// r = {
	// 	{
	// 		arg dur=16, pos=0;
	// 		var sr = SampleRate.ir;
	// 		BufWr.ar(SoundIn.ar(0), b.bufnum, Line.ar(pos*sr, (pos+dur)*sr, dur, doneAction:2), 0);
	// 	}.play(s);
	// }.value;

	r = {
		{
			arg dur=16, pos=0;
			var sr = SampleRate.ir;
			RecordBuf.ar(SoundIn.ar(0), b.bufnum, loop: 0, doneAction:2);
			Silent.ar
		}.play(s);
	};
	r.value;


	/*
	b.plot;
	*/

	/*
	r.value;
	*/


	SynthDef.new(\shot, { arg out=0, buf, pos=0, rate=1,
		atk=0.1, sus=0, rel=4.0,
		hpf=10, lpf=20000, amp=1.0, pan=0;
		var aenv = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
		var snd = PlayBuf.ar(1, buf, rate, startPos:pos);
		snd = LPF.ar(HPF.ar(snd, hpf), lpf);
		snd = snd * aenv * amp;
		Out.ar(out, Pan2.ar(snd, pan));
	}).send(s);

Synth.new(\shot, [\buf, b.bufnum

	//-------------------------------------
	/// MIDI

	// pad numbers
	~pnum = [ 60, 62, 64, 65, 67, 69];
	~prate = Dictionary.newFrom([
		60, [1, 6/4, 3/2, 2],
		62, [1, 3/2, 14/8],
		64, [1, 2, 6/5, 4/3],
		65, [1, 3/2, 4/3, 5/4, 18/8, 2, 15/8],
		67, [1, 6/4, 3/2, 4/3],
		69, [9/8, 6/4, 4/3, 8/5],
	]);

	~ppos = ~prate.collect({0.0});
	~pridx = ~prate.collect({0});
		~ppan = ~pnum.collect({aarg num, i; i.linlin(0, ~pnum.size, -0.8, 0.8)});
	~prnext = {arg num;
		if (~pnum.indexOf(num).notNil, {
			var r = ~prate[num];
			var idx = ~pridx[num];
			idx = (idx+1).wrap(0, r.size);
			~pridx[num] = idx;
			r[idx]
		})
	};

	MIDIIn.connectAll;
	MIDIdef.noteOn(\post, { arg... args; args.postln });

	MIDIdef.noteOn(\shot, { arg vel, num;
		var rate = ~prnext.value(num);
		var pos = ~ppos[num];
			[rate, pos].postln;
		if (rate.notNil, {
			Synth.new(\shot, [\buf, b.bufnum, \rate, rate, \pos, pos]);
		});
	});
}.play;
