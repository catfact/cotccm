
p = PrimeSpiralSine.new(s);

p.factorList = List[8, 15, 20];
p.atkOff = 8.0;
p.atkScale = 5.0;
p.sustain = 4.0;
p.relOff = 8.0;
p.relScale = 4.0;
p.waitScale = 1.0;
p.wait = 16.0;
p.amp = -3.dbamp;
p.wrapRatio = 4.0;
p.hz0 = 220.0;	

p.play;