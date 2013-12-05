~serialoscAddr = NetAddr.new("localhost", 12002);
//~serialoscAddr = NetAddr.new("localhost", 11094);
~monomeAddr = NetAddr.new("localhost", 0);
~prefix = '/monome';

Routine {
	var c = Condition.new(false);
	/// store led values so we can arbitrarily layer/mask them
	var leds    = Array.fill(8, { Array.fill(8, {0}) });
	var ledmask = Array.fill(8, { Array.fill(8, {0}) });
	var led_update; // private update function

	OSCdef.newMatching(\monomeDiscover, { arg msg, time, addr, recPort;
		"discover: ".post; 
		msg.postln;
		~monomeAddr.port = msg[3];
		c.test = true; c.signal;
	}, '/serialosc/device',  ~serialoscAddr);
			
	~serialoscAddr.sendMsg('/serialosc/list', '127.0.0.1', NetAddr.langPort);

	c.wait; c.test=false;
	postln("hi");

	~led = { arg x, y, val;
		leds[x][y] = val;
		led_update.value(x, y);
		//		~monomeAddr.sendBundle(0.0, [~prefix++'/grid/led/set', x, y, val ]);
	};

	~row = { arg y, v;
		~monomeAddr.sendBundle(0.0, [~prefix++'/grid/led/row', 0, y, v]);
	};

	~ledmask = { arg x, y, val;
		ledmask[x][y] = val;
		led_update.value(x, y);
	};

	led_update = { arg x, y;
		~monomeAddr.sendBundle(0.0, [~prefix++'/grid/led/set', x, y, leds[x][y] | ledmask[x][y] ]);
	};

	/// enable tilt
	~monomeAddr.sendBundle(0.0, [~prefix++'/tilt/set', 0, 1 ]);
	~monomeAddr.sendBundle(0.0, [~prefix++'/tilt/set', 1, 1 ]);

	
		// a little startup dance
	Routine {
		var x = Array.series(8, 0, 1).scramble;
		var y = Array.series(8, 0, 1).scramble;
		var z;
		z = 0;
		2.do({
			z = (z + 1) % 2;
			x.do({ arg i;
				y.do({ arg j;
					~led.value(i, j, z);
					(1/32).wait;
				});
			});
		});
	}.play;


}.play;