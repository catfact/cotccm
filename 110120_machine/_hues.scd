~hues = Array.with (
	0x0c0d0d,
	0x0d1215,
	0x202012,
	0x12150b,
	0x0a1415,
	0x1d0b01,
	0x200b01,
	0x102818,
	0x0d2515,
	0x0a1715,
	0x2c1d1b,
	0x202921,
	0x27201d,
	0x1e2820,
	0x152414,
	0xe7d9c2,
	0xa2bbca,
	0x637b92,
	0x748a9f,
	0x7c8daf,
	0xb1c4cb,
	0x9db1bd,
	0x4d6474,
	0x5a717f,
	0x8d9ca5,
	0xa6a8a2,
	0x969088,
	0xa3a7a6,
	0x9ea09e,
	0x9e9d98,
	0x949d9c,
	0x727a7e,
	0x747c7d,
	0x7c8887,
	0x898981,
	0x989b93
);

/*
~colorFromHex = { arg h;
	var c = Color.new255((h & 0xFFFFFF) >> 16, (h & 0x00FFFF) >> 8, (h & 0x0000FF));
};
*/



// try to saturate
/*
~colorFromHex = { arg h;
	var rgb = Array.newClear(3);
	var c;
	rgb[0] = (h & 0xffffff) >> 16;
	rgb[1] = (h & 0x00ffff) >> 8;
	rgb[2] = (h & 0x0000ff);
	rgb = rgb.normalize;
	c = Color.new(r[0], r[1], r[2]);
	c.postln;
	c
};
*/


~colorFromHex = { arg h;
	var c = Color.new255((h & 0xFFFFFF) >> 16, (h & 0x00FFFF) >> 8, (h & 0x0000FF));
	var hsv = c.asHSV;
	hsv[1] = 0.7 + 0.3.rand;
	hsv[2] = 0.7 + 0.3.rand;
	c = Color.hsv(hsv[0], hsv[1], hsv[2], hsv[3]);
//	"whassup color".postln;
	c.postln;
	c
};