g = CfGridRaw.new;

// 2 big buttons
~quad_on = [
	{ 
		g.led_map(0, 0, Int8Array.fill(8, { 0xff }); );
	}, { 
		g.led_map(0x08, 0x00, Int8Array.fill(8, { 0xff }); );
	}
];

~quad_off = [
	{ 
		g.led_map(0, 0, Int8Array.fill(8, { 0x00 }); );
	}, { 
		g.led_map(0x08, 0x00, Int8Array.fill(8, { 0x00 }); );
	}
];


~show_grains = {
	var b = 0x00;
	~grsyn.size.do({|i| b = b | (1<<i) });
	b.asHexString.postln;
	g.led_row(0, 0, b);
};


g.led_intensity(0x3);

// for each quad,
// set of keys held down
~quad_keys = [Set.new, Set.new];

~quad_key_downfunc = [
	{  ~grstartrec.value;},
	{ ~grstopplay.value; }
];

~quad_key_upfunc = [
	{ ~grstoprec.value; },
	{  }
];

g.keyDown = { |x,y|
	var q = x >> 3;
	~quad_keys[x >> 3].add(Point(x,y));
	//	~quad_keys[q].postln;
	if(~quad_keys[q].size ==1 , {
		postln("quad key down " ++ q);
		~quad_key_downfunc[q].value;
		~quad_on[q].value;
	});
	
};

g.keyUp = { |x,y|
	var q = x >> 3;
	~quad_keys[q].remove(Point(x,y));
	//	~quad_keys[q].postln;
	if(~quad_keys[q].isEmpty, {
		postln("quad key up " ++ q); 
		~quad_key_upfunc[q].value;
		~quad_off[q].value;
		~show_grains.value;
	});
};


