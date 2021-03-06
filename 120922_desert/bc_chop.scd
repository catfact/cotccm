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
	~amp = 0.25;

	/*
	~chops = Array.fill(1024, { nil });

	~evs = Array.fill(1024, { Event.with(
		\pos->~pos,
		\amp->~amp,
		\atk->~atk,
		\sus->~sus,
		\rel->~rel,
		\rate->~rate,
		\hz->~hz,
		\rq->~rq,
		\tw->~tw
	)});
	*/

	//	~chops = List.new;
	~chopr = Array.newClear(256);
	~chopev = Array.newClear(256);
	~crchop = { arg i;
		if(~chopr[i].isPlaying, { ~chopr[i].stop; });
		~chopev[i] = Event.with(
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
		
		~chopr[i] =	Routine{ inf.do {
			//	ev.postln;
			Synth.new(\rlpfbuf, [
				\buf, ~bbuf.bufnum,
				\pos, 44100 * ~chopev[i].pos,
				\amp, ~chopev[i].amp,
				\atk, ~chopev[i].atk,
				\sus, ~chopev[i].sus,
				\rel, ~chopev[i].rel,
				\rate, ~chopev[i].rate, 
				\hz, ~chopev[i].hz, 
				\rq, ~chopev[i].rq, 
				//					\out, c.out_b.index
				\out, 0
				//			], target:c.xg );
			], target:s );
			//ev.tw.wait;
			 ~chopev[i].tw.wait;
		} }.play;
	};
	
	
}.play;