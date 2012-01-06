
Routine {  
	~vox_del_g = Group.new(s);
 	// vox delay output bus 
	~vox_del_b = Bus.audio(s, 1);
	
	// vox delay synths
	~vox_del4 = CfAdcDelay4.new(s, ~vox_del_g);
	
	0.2.wait; 
	
	~vox_del4.del_in_s.set(\in, 0);
	
	0.1.wait;
	
	// sum them all to the same bus
	~vox_del4.del_s.do({arg syn;
		syn.set(\out, ~vox_del_b.index);
		syn.set(\amp, 0.0);
	});
	
	// output that bus to dac channel 0 
	SynthDef.new(\patch, {arg in=0, out=0, level=1;
		Out.ar(out, In.ar(in) * level);
	}).send(s);
	0.01.wait;
	~vox_del_out_s = Synth.new(\patch, [\in, ~vox_del_b.index, \out, 0], ~vox_del_g, \addAfter);
	
	1.25.wait;
	
	~vox_del4.del_s[0].set(\delaytime, 0.125);
	~vox_del4.del_s[1].set(\delaytime, 0.25);
	~vox_del4.del_s[2].set(\delaytime, 0.5);
	~vox_del4.del_s[3].set(\delaytime, 0.625);
	~vox_del4.del_s[0].set(\fb, 0.1);
	~vox_del4.del_s[1].set(\fb, 0.1);
	~vox_del4.del_s[2].set(\fb, 0.1);
	~vox_del4.del_s[3].set(\fb, 0.1);
	~vox_del4.del_s[0].set(\hz, 1200);
	~vox_del4.del_s[1].set(\hz, 3000.0);
	~vox_del4.del_s[2].set(\hz, 800.0);
	~vox_del4.del_s[0].set(\amp, 0.0);
	~vox_del4.del_s[1].set(\amp, 0.2);
	~vox_del4.del_s[2].set(\amp, 0.3);
	~vox_del4.del_s[3].set(\amp, 0.05);
}.play;