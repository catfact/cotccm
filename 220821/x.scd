Routine {
	s = Server.local;
	s.waitForBoot;

	// vla buf
	b = Buffer.alloc(s, s.sampleRate * 16, 1);
	s.sync;

	SynthDef.new(\rec_1shot, {
		arg buf, in=0, dur=16, pos=0, rec=1, pre=0;
		var sr = SampleRate.ir;
		var env = EnvGen.kr(Env.linen(0, dur, 0), doneAction:2);
		RecordBuf.ar(SoundIn.ar(in), buf, recLevel:rec, preLevel:pre, loop: 0);
	}).send(s);
	s.sync;


	r = { Synth.new(\rec_1shot, [\buf, b.bufnum]) };

	r.value;


	/*
	b.plot;
	*/

	/*
	r.value;
	*/


	SynthDef.new(\play_1shot, { arg out=0, buf, pos=0, rate=1,
		atk=0.1, sus=0, rel=4.0,
		hpf=10, lpf=20000, amp=1.0, pan=0;
		var aenv = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
		var snd = PlayBuf.ar(1, buf, rate, startPos:pos);
		snd = LPF.ar(HPF.ar(snd, hpf), lpf);
		snd = snd * aenv * amp;
		Out.ar(out, Pan2.ar(snd, pan));
	}).send(s);


	//-------------------------------------
	/// MIDI

	// pad numbers
	~pnum = [ 60, 62, 64, 65, 67, 69];
	~prate = Dictionary.newFrom([
		60, [1, 2],
		62, [1, 3/2, 14/8],
		64, [1, 2, 6/5, 4/3],
		65, [1, 3/2, 4/3, 5/4, 15/8],
		67, [1, 3/2, 4/3],
		69, [9/8, 6/5, 4/3, 8/5],
	]);

	~ppos = ~prate.collect({arg x, i; i * 0.25});
	~pridx = ~prate.collect({0});
	~ppan = ~pnum.collect({arg num, i; i.linlin(0, ~pnum.size, -0.8, 0.8)});
	~prnext = {arg num;
		if (~pnum.indexOf(num).notNil, {
			var r = ~prate[num];
			var idx = ~pridx[num];
			idx = (idx+1).wrap(0, r.size-1);
			~pridx[num] = idx;
			r[idx]
		})
	};

	MIDIIn.connectAll;
	MIDIdef.noteOn(\post, { arg... args; args.postln });

	MIDIdef.noteOn(\shot, { arg vel, num;
		var rate = ~prnext.value(num);
		var pos = ~ppos[num];
		var pan = ~ppan[num];
		[rate, pos].postln;
		if (rate.notNil, {
			Synth.new(\play_1shot, [\buf, b.bufnum, \rate, rate, \pos, pos, \pan, pan]);
		});
	});
}.play;
