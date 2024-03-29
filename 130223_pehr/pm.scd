Routine {

SynthDef.new(\pm3, { 
	arg out=0, amp=0.25, amplag=1.0,
	hz1=220, hz2=330, hz3=110,
	// shape1=0, shape2=0, shape3=0,
	pm12=0, pm23=0, pm31=0,
	pm12del=0, pm23del=0, pm31del=0,
	amp1=1, amp2=1, amp3=1,
	amp1lag=1.0, amp2lag=2.0, amp3lag=3.0,
	hz1lag=0, hz2lag=0, hz3lag=0,
	pm12lag=0, pm23lag=0, pm31lag=0;

	var osc1, osc2, osc3;

	amp = Lag.kr(amp, amplag);

	hz1 = Lag.kr(hz1, hz1lag);
	hz2 = Lag.kr(hz2, hz2lag);
	hz3 = Lag.kr(hz3, hz3lag);

	amp1 = Lag.kr(amp1, amp1lag);
	amp2 = Lag.kr(amp2, amp2lag);
	amp3 = Lag.kr(amp3, amp3lag);
	
	pm12 = Lag.kr(pm12, pm12lag);
	pm23 = Lag.kr(pm23, pm23lag);
	pm31 = Lag.kr(pm31, pm31lag);

	osc1 = SinOsc.ar(hz1, DelayL.ar(LocalIn.ar(1) * pm31 * pi, 1.0, pm31del));
	osc2 = SinOsc.ar(hz2, DelayL.ar(osc1 * pm12 * pi, 1.0, pm12del));
	osc3 = SinOsc.ar(hz3, DelayL.ar(osc2 * pm23 * pi, 1.0, pm23del));
	LocalOut.ar(osc3);

	Out.ar(0, Mix.ar([osc1 * amp1, osc2 * amp2, osc3 * amp3]) * amp);
	
}).send(s);


s.sync;

x = Synth.new(\pm3, [\amplag, 4.0], s);
x.set(\pm12, 0.5);
x.set(\amp, 1.0);


t = TempoClock.new(120);

t.sched(0, { 

	~pm12r = Routine { inf.do { arg i;
		var w;
		var pm;
		1
		pm = (0.0625 * ( ( i * 17) % 8)).wrap(0, 0.8);
		
		x.set(\pm12, pm);
		
		w = 0.125 * (( i * 13) % 4);

		w.wait;
	} }.play;
	
	nil;
});



t.sched(16, { 
	

	~pm23r = Routine { inf.do { arg i;
		var w;
		var pm;
		
		pm = (0.125 * ( ( i * 13) % 6)).wrap(0, 0.8);
		
		x.set(\pm23, pm);
		
		w = (0.0625 * (( i * 13) % 4)).wrap(0.125, 0.25);

		w.wait;
	} }.play;
	
	nil;
});




t.sched(46, { 	
	~pm31r = Routine { inf.do { arg i;
		var w;
		var pm;
		
		pm = (0.125 * ( ( i * 18) % 7)).wrap(0, 0.8);
		
		x.set(\pm31, pm);
		
		w = (0.0625 * (( i * 17) % 8)).wrap(0.125, 0.25);

		w.wait;
	} }.play;
	
	nil;
});


x.set(\pm12lag, 1 / 64);
x.set(\pm31del, 0.001);
x.set(\hz2, 220 * 5/4);


/////////////////////////////
/////////////////////////////

16.wait;

y = Synth.new(\pm3, [\amplag, 4.0, \hz1, 110], s);

t.sched(0, { 

	~ypm12r = Routine { inf.do { arg i;
		var w;
		var pm;
		
		pm = (0.0625 * ( ( i * 17) % 8)).wrap(0, 0.8);
		
		y.set(\pm12, pm);
		
		w = 0.125 * (( i * 13) % 4) * 6;

		w.wait;
	} }.play;
	
	nil;
});

t.sched(16, { 
	
	~ypm23r = Routine { inf.do { arg i;
		var w;
		var pm;
		
		pm = (0.125 * ( ( i * 13) % 6)).wrap(0, 0.8);
		
		y.set(\pm23, pm);
		
		w = (0.0625 * (( i * 13) % 4)).wrap(0.125, 0.25) * 6;

		w.wait;
	} }.play;
	
	nil;
});

t.sched(46, { 	
	~ypm31r = Routine { inf.do { arg i;
		var w;
		var pm;
		
		pm = (0.125 * ( ( i * 18) % 7)).wrap(0, 0.8);
		
		y.set(\pm31, pm);
		
		w = (0.0625 * (( i * 17) % 8)).wrap(0.125, 0.25) * 8;

		w.wait;
	} }.play;
	
	nil;
});

t.sched(0, { 	
	~yhz2r = Routine { inf.do { arg i;
		var w;
		var hz2;
		
		hz2 = (0.125 * ( ( i * 18) % 7)).wrap(0.25, 4.0);
		hz2 = hz2 * 6/5 * 110;
		
		y.set(\hz2, hz2);
		
		w = (0.0625 * (( i * 17) % 8)).wrap(0.125, 0.25) * 8;

		w.wait;
	} }.play;
	
	nil;
});

}.play;




~scale = [1, 9/8, 5/4, 6/5, 4/3, 3/2, 8/5, 10/6, 16/9];

t.sched(24, {
	~xhz1r = Routine { inf.do { arg i;
		var hz = ((i * 19) % 14).wrap(0, ~scale.size);
		hz = ~scale[hz] * 220;
		x.set(\hz1lag, ((i * 16) % 4) * 0.25 + 0.125);
		x.set(\hz1, hz);
		
		(((i * 25) % 14) + 6).wait;
		x.set(\hz1, hz);
	}}.play;
	nil
});


t.sched(24, {
	~yhz1r = Routine { inf.do { arg i;
		var hz = ((i * 29) % 4).wrap(0, ~scale.size);
		hz = ~scale[hz] * 220;
		y.set(\hz1lag, ((i * 26) % 24) * 0.25 + 0.125);
		y.set(\hz1, hz);
		
		((((i * 25) % 14) + 6)).wrap(1, 4).wait;
		y.set(\hz1, hz);
	}}.play;
	nil
});


/*
~xhz1r.stop;
*/

x.set(\amplag, 16.0);
y.set(\amplag, 16.0);

~ampr = Routine { inf.do {
	x.set(\amp, [0, 0.5].choose);
	y.set(\amp, [0, 0.5].choose);
	(16 + 16.rand).wait;
} }.play;