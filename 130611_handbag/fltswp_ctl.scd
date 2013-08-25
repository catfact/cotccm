~flt_rec_key = OSCdef.newMatching('fltswp_key', { arg msg, time, addr, rec;
	var x, y, val;
	var t;

	x=msg[1];
	y=msg[2];
	val=msg[3];
	
	if( y == 5, {
		if(val > 0, {	
			if (x % 2 > 0, {
				~fltrin = 1;
			}, { ~fltrin = 0;
			});
			~flt_recstart.value;
			~led.value(x, y, 1);
		}, {
			~flt_recstop.value(x);
			~led.value(x, y, 0);
		});
	});	
}, ~prefix++'/grid/key');


/*
~flt_rec_key.remove;
~fltrin
*/