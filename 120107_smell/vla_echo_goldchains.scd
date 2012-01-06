Routine {  
	~vla_del_g = Group.new(s);
 	// vox delay output bus 
	~vla_del_b = Bus.audio(s, 1);
	
	// vox delay synths
	~vla_del4 = CfAdcDelay4.new(s, ~vla_del_g);
	
	0.2.wait; 
	
	~vla_del4.del_in_s.set(\in, 1);
	
	0.1.wait;
	
	// sum them all to the same bus
	~vla_del4.del_s.do({arg syn;
		syn.set(\out, ~vla_del_b.index);
		syn.set(\amp, 0.0);
	});
	
	// output that bus to dac channel 0 
	SynthDef.new(\patch, {arg in=0, out=0, level=1;
		Out.ar(out, In.ar(in) * level);
	}).send(s);
	0.01.wait;
	~vla_del_out_s = Synth.new(\patch, [\in, ~vla_del_b.index, \out, 0], ~vla_del_g, \addAfter);
	
	10.wait;
	
	~vla_del4.del_s[0].set(\delaytime, 10.33);
	~vla_del4.del_s[1].set(\delaytime, 20);
	~vla_del4.del_s[2].set(\delaytime, 1.0);
	~vla_del4.del_s[3].set(\delaytime, 3.0);
	~vla_del4.del_s[0].set(\fb, 0.1);
	~vla_del4.del_s[1].set(\fb, 0.1);
	~vla_del4.del_s[2].set(\fb, 0.1);
	~vla_del4.del_s[3].set(\fb, 0.1);
	~vla_del4.del_s[0].set(\hz, 1200);
	~vla_del4.del_s[1].set(\hz, 3000.0);
	~vla_del4.del_s[2].set(\hz, 800.0);
	~vla_del4.del_s[0].set(\amp, 0.2);
	~vla_del4.del_s[1].set(\amp, 0.3);
	~vla_del4.del_s[2].set(\amp, 0.1);
	~vla_del4.del_s[3].set(\amp, 0.05);
}.play;