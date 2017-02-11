x = Blerf.new;
x.x = 5
x.x

s


c = CubOsc.new(s);
~syn = c.play(0, s)

c.hz = 500;
c.buf.plot

c.x = 0.9;
c.a = 3.8;
~syn.free;


Vocoder
VocodeBand

~csyn.set(\out, ~mod_b.index);