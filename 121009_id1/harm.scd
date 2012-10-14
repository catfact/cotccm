SynthDef.new(\sinesaw, {
	arg out=0, amp=0.25,
	hz=220, sine=0.5, saw=0.25,
	cutoff=2.0, rq=0.5,
	atk=0.125, rel=2.0, gate=1;
	var env, osc;
	env = EnvGen.ar(Env.asr(atk, 1.0, rel), gate:gate, doneAction:2) * amp;
	osc = SinOsc.ar(hz, mul:sine, add:Saw.ar(hz, mul:saw));
	
	osc = LPF.ar(osc, hz*cutoff, rq, mul:env);
	Out.ar(out, osc.dup);
}).send(s);


~hr = Routine{
	var h=0, base=110;


		g.set(\gate, 0);
		//				x = Synth.new(\sinesaw, [\hz, h * ~base, \atk:1.0], g);
		x = Synth.new(\sinesaw, [\hz, , \atk:1.0], g);

};
	

	/*
~hr.next
~hnext.value;

	g.set(\gate, 0);
	*/




r = FuncStream{ var x=0;
	inf.do({ 
		x = x + 1;
		x.postln;
	});
};

r.next;
r.stop;



