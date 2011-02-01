s = Server.local;
s.boot;

SynthDef.new(\mapOsc_cubic, {
	arg buf, out=0, level=0.25,
		atk=0.001, rel=0.1, gate=0,
		a=3.4,
		doneAction=0,
		lpf_hz= 3000,
		hz=44100;
		
	var x, y, duty, env, output, slewslope;
	var superfast, latchpulse;	

	x = Dbufrd(buf);
	x = (a*x*x*x) + ((1.0-a)*x);
	y = Dbufwr(x, buf);
//	superfast = Duty.ar(SampleDur.ir, 0, y);
	superfast = Duty.ar(1.0 / hz, 0, y);
	
	output = superfast;
	output = LPF.ar(superfast, lpf_hz);

	env = EnvGen.ar(Env.asr(atk, 1.0, rel), gate:gate, doneAction:doneAction);

	Out.ar(out, (env * output * level).dup);	
}).send(s);

b = Buffer.alloc(s, 1);
x = Synth.new(\mapOsc_cubic, [\buf, b.bufnum, \gate, 1], s);

a = 3.7999;
x.set(\a, a);

v = 0.77;
b.set(0, v);


////// routine to scrub the nonlinearity param
~scrub_a_step = 2e-7;
~scrub_a_dt = 0.08;

~scrub_a = Routine { inf.do({
	a = (a + ~scrub_a_step).min(3.9999);
	x.set(\a, a);
	a.postln;
	~scrub_a_dt.wait;
}) };

~scrubbing_a = false;

w = SCWindow.new;

w.view.keyDownAction = {arg view, c, m, u, k;
	var scrubval = nil;
	// postln("down: " ++ [c, m, u, k]);
	scrubval = c.switch(
		$a, { 2e-3 },
		$z, { -2e-3 },
		$s, { 1e-3 },
		$x, { -1e-3 },
		$d, { 2e-4 },
		$c, { -2e-4 },
		$f, { 1e-4 },
		$v, { -1e-4 },
		$g, { 2e-5 },
		$b, { -2e-5 },
		$h, { 1e-5 },
		$n, { -1e-5 },
		$j, { 2e-6 },
		$m, { -2e-6 },
		$k, { 1e-6 },
		$,, { -1e-6 },
		$l, { 2e-7 },
		$., { -2e-7 },
		$;, { 1e-7 },
		$/, { -1e-7 }
	);
	
	if(c == $ , {v = 1.0.rand; b.set(0, v);});
	
	if(scrubval.notNil, { ~scrub_a_step = scrubval; });
	if(~scrubbing_a, {}, { ~scrubbing_a = true; ~scrub_a.reset.play; });
};


w.view.keyUpAction = {arg view, c, m, u, k;
	// postln("up: " ++ [c, m, u, k]);
	/*
	if (c == $a ||
		c == $z ||
		c == $s ||
		c == $x ||
		c == $d ||
		c == $c ||
		c == $f ||
		c == $v ||
		c == $g ||
		c == $b ||
		c == $h ||
		c == $n ||
		c == $j ||
		c == $m ||
		c == $k ||
		c == $, ||
		c == $l ||
		c == $. ||
		c == $; ||
		c == $/, {
			*/
			~scrub_a.stop;
			~scrubbing_a = false;
//	});
};

w.front;

x.set(\lpf_hz, 1000);

