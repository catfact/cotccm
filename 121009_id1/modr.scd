Routine {
	
	SynthDef.new(\sinesaw, {
		arg out=0, amp=0.25,
		hz=220, sine=0.5, saw=0.0625,
		cutoff=2.0, rq=0.5,
		atk=0.125, rel=2.0, gate=1,
		amplag=0.001, hzlag=0.001;
		
		var env, osc;

		amp = Lag.kr(amp, amplag);
		hz = Lag.kr(hz, hzlag);
		
		env = EnvGen.ar(Env.asr(atk, 1.0, rel), gate:gate, doneAction:2) * amp;
		osc = SinOsc.ar(hz, mul:sine, add:Saw.ar(hz, mul:saw));
		
		osc = LPF.ar(osc, cutoff, rq, mul:env);
		Out.ar(out, osc.dup);
	}).send(s);
	
	s.sync;
	
	//~hzl.plot(discrete:true)
	
	~hzi = Array.series(100, 100, 2);
	~oscg = Group.new(s);
	~osc = List.new;
	~nosc = 1.0;

	// function spawns routine for flipping amplitude on a given osc
	~spwampr = {
		arg osci, 
		timebase=0.25,
		a=5, b=4;
		var osc, ascale, alist, hz;

		alist = ~analist.wrapAt(osci);
		alist.postln;

		hz = alist.pitch;
		ascale = alist.amp;
		//		ascale.postln;
				hz.postln;
		//		alist.postln;
		osc= Synth.new(\sinesaw, [
			\amp, 0.0,
			\hz, hz,
			\cutoff, alist.cent ,
			\rq, alist.flat
		], ~oscg);
		
		~nosc = ~nosc + 1;

		Routine {		
			var x, amp;
			amp = 0.0;
			x = 1;
			inf.do({ 
				x = (x * a) % b;
				//				[x, amp].postln;
				if(amp > 0.0, { 
					amp = 0.0 
				}, { amp = 1.0 / ~nosc * ascale; });
				osc.set(\amp, amp);
				osc.set(\amplag, x * timebase / 64);
				(timebase * x).wait;
			});
		}.play;
};


r = List.new;

~nosc = 10;	
	r.add( ~spwampr.value(0, 0.25, 4, 13); );
	r.add( ~spwampr.value(2, 0.25, 4, 14); );

	r.add( ~spwampr.value(30, 0.25, 6, 17); );
	r.add( ~spwampr.value(32, 0.25, 6, 19); );

	r.add( ~spwampr.value(60, 0.25, 9, 19); );
	r.add( ~spwampr.value(64, 0.25, 9, 21); );

	r.add( ~spwampr.value(100, 0.25, 8, 17); );
	r.add( ~spwampr.value(101, 0.25, 8, 19); );

	r.add( ~spwampr.value(220, 0.25, 11, 19); );
	r.add( ~spwampr.value(223, 0.25, 11, 21); );


}.play;

/*
r.do({ arg rt; rt.stop; }); ~oscg.set(\gate, 0); r.clear;
*/