~analist.collect({ arg list; list.pitch; }).postln;
g = Group.new(s);
z = { arg i;
	g.set(\gate, 0);
	~analist[i].pitch.postln;
	//				x = Synth.new(\sinesaw, [\hz, h * ~base, \atk:1.0], g);
	x = Synth.new(\sinesaw, [\hz, ~analist[i].pitch, \atk:0.125, \rel:0.5], g);
};

i = 0;
z.value(i); i = i+1;


r = Routine{  inf.do{ 
	z.value(~analist.size.rand);
	0.125.wait;
} }.play;

r.stop;

g.set(\gate, 0);