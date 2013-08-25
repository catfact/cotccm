~fltpckpair = Array.newClear(~nf);


~flt_key = OSCdef.newMatching('pm_key', { arg msg, time, addr, rec;
	var x, y, val;

	x=msg[1];
	y=msg[2];
	val=msg[3];
	
	if(y < ~npm, {
		x.switch(
			0, { ~setamp.value( y, val); },
			1, { ~sethz.value(y, \hz1, val);  ~led.value(x, y, val); },
			2, { ~sethz.value(y, \hz2, val);  ~led.value(x, y, val); },
			3, { ~sethz.value(y, \hz3, val);  ~led.value(x, y, val); },
			4, { ~setpm12.value(y, val, 8.0); ~led.value(x, y, val); },
			5, { ~setpm23.value(y, val, 8.0); ~led.value(x, y, val); },
			6, { ~setpm31.value(y, val, 8.0); ~led.value(x, y, val); },
		);
	});
}, ~prefix++'/grid/key');