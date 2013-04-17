/// TEMPERANCE
///  loop -> shift -> var dist

~lblen = 20.0;
~jlb = Buffer.alloc(s, s.sampleRate * ~lblen);

~jlrs =  Synth.new(\justloop_rec, [\buf, ~jlb.bufnum, prelevel:1.0, \in, 0]);	
~jlrs.free;

~jlb.plot;

~jlbus = Bus.audio(s, 1);

~jlps = Synth.new(\justloop_play, [\buf, ~jlb.bufnum, \looptime, 10.0, \rate, 0.25, \level, -12.dbamp, \out, 0]);



/////////////////////////////////////////////
//////////////////////////////////////////////
/// shaper test
b = Buffer.alloc(s, 512, 1, { |buf| buf.chebyMsg([1,0,1,1,0,1])});

b.plot;


SynthDef.new(\sineshape, { arg buf, out=0, amp=0.5, hz=220, shape=0.0, shapelag=2.0;
	var osc;
	shape = Lag.kr(shape, shapelag);
	osc = SinOsc.ar(hz);
	osc = ((1.0 - shape)*osc) + (shape*Shaper.ar(buf, osc));
	Out.ar(out, (osc * amp).dup);
}).send(s);

x = Synth.new(\sineshape, [\buf, b.bufnum]);

x.set(\shapelag, 4.0);
x.set(\shape, 0.5);
x.set(\shape, 1.0);

r = Routine { inf.do { arg i;
	x.set(\shapelag, (0.0625 * (((i+1) % 3))));
	x.set(\shape, (0.125 * ((((i+1)*7) % 5))));
	wait(0.25 * ((i % 2) + 1));
} }.play;


x.set(\hz, 110);
// different spectrum:
// 

cheby(amplitudes, normalize, asWavetable, clearFirst)
// chebyMsg(amplitudes, normalize, asWavetable, clearFirst)
b.

///////////////////////////////////////////
////////////////////////////////////////////