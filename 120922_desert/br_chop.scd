Routine { 

	SynthDef.new('rlpfbuf', { arg buf, out, amp, atk, rel, sus, rate, pos, hz, rq;
		var ampenv, sig;
		ampenv = EnvGen.ar(Env.linen(atk, sus, rel), 1, doneAction:2);
		//	sig = SinOsc.ar(110).dup;
		sig = PlayBuf.ar(1, buf, rate, startPos:pos);
		sig = RLPF.ar(sig, hz, rq);
		sig = sig * ampenv * amp;
		sig = sig.dup;
		Out.ar(out, sig);
	}).send(s);

	s.sync;

	~pos = 60.0;
	~atk = 0.25;
	~sus = 1.0;
	~rel = 1.0;
	~hz = 400;
	~rate = 0.25;
	~rq = 0.25;
	~tw = 0.5;

	~choplist = List.new;

	~crchop = { var ev; 
		ev = Event.with(
			\r -> Routine{ inf.do {
				//	ev.postln;
				Synth.new(\rlpfbuf, [
					\buf, ~bbuf.bufnum,
					\pos, 44100 * ~pos, //ev.pos,
					\amp, ~amp, //ev.amp,
					\atk, ~atk, //ev.atk,
					\sus, ~sus, //ev.sus,
					\rel, ~rel, //ev.rel,
					\rate, ~rate ,//ev.rate, 
					\hz, ~hz, //ev.hz, 
					\rq, ~rq, //ev.rq, 
					//					\out, c.out_b.index
					\out, 0
				], target:c.xg );
				//ev.tw.wait;
				~tw.wait;
			} }, 
			\pos->~pos,
			\amp->~amp,
			\atk->~atk,
			\sus->~sus,
			\rel->~rel,
			\rate->~rate,
			\hz->~hz,
			\rq->~rq,
			\tw->~tw
		);
		ev.r.play;
		~choplist.add(ev);
	};


}.play;