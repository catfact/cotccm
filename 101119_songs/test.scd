s = Server.internal;

s.waitForBoot {
	x = { Out.ar(0, SinOsc.ar([220, 222]) * (-12.dbamp)) }.play(s);
}

/*
x.free;
*/