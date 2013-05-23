~pm_key.free;

~fltlplonamp = -16.dbamp;
~fltlpl_key = OSCdef.newMatching('pm_key', { arg msg, time, addr, rec;
	var x, y, val;

	x=msg[1];
	y=msg[2];
	val=msg[3];
	
	if((y < 5) && (val == 1), {
		~fltlpl[x][y].get(\amp, {
			arg val;
			if (val < -60.dbamp, {	
				~fltlpl[x][y].set(\amp, ~fltlplonamp);
				~led.value(x, y, 1);
			}, {
				~fltlpl[x][y].set(\amp, 0.0);
				~led.value(x, y, 0);
			});
		});
	});
}, ~prefix++'/grid/key');


/*
~fltlpl_key.free;
*/