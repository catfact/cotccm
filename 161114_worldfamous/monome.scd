g = CfGridRaw.new;

// 2 big buttons
~quad0_on = { 
	g.led_map(0, 0, Int8Array.fill(8, { 0xff }); );
};
~quad0_off = { 
	g.led_map(0, 0, Int8Array.fill(8, { 0x00 }); );
};

~quad1_on= { 
	g.led_map(0x08, 0x00, Int8Array.fill(8, { 0xff }); );
};

~quad1_off= { 
	g.led_map(0x08, 0x00, Int8Array.fill(8, { 0x00 }); );
};

/*
~quad0_on.value
~quad0_off.value
~quad1_on.value
~quad1_off.value

*/

~showgrains = {
	var b = 0x00;
	~gsyn.size.do({|i| b = b | (1<<i) });
	g.led_row(0, 0, b);
};

/*
g.keyDown = { |x,y|
	g.led_set(x, y, true);
};

g.keyUp = { |x,y|
	g.led_set(x, y, true);
};

g.led_set(0, 0, true);
g.led_set(0, 0, false);
*/

g.led_intensity(0x3);

// for each quad,
// set of keys held down
~quad_keys = [Set.new, Set.new];

g.keyDown = { |x,y|
	var q = x >> 3;
	~quad_keys[x >> 3].add(Point(x,y));
	
};

g.keyUp = { |x,y|
	var q = x >> 3;
	~quad_keys[q].remove(Point(x,y));
	if(~quad_keys[q].isEmpty, {
		[
			{~grstartrecord.value},
			{}
		][q].value;
	});
};