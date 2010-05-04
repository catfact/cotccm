

s = Server.internal.boot;

m = CfMonome.new;

m.press = { arg x, y;
	m.led(x, y, 1);	
	if (x < 4 && y < 4, { 
		~start_freeze.value(y + (x * 4));
	});
};

	
m.lift = { arg x, y;
	// m.led(x, y, 0);	
	if (x < 4 && y < 4, { 
		~continue_freeze.value(y + (x * 4));
	});
};

m.led(0, 0, 1);
m.led(0, 0, 0);