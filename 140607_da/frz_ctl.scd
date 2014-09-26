~frz_key = OSCdef.newMatching('frz_key', { arg msg, time, addr, rec;
	var x, y, z;
	x=msg[1];
	y=msg[2];
	z=msg[3];
	[x, y, z].postln;
	/// bottom row: record
	if(y == 7, {
		~frz_rec.value(x, z > 0);
		~led.value(x, y, 1 - z);
	});
	/// 2nd row: store pitches for filters
	if(y == 6, {
		~led.value(x, y, z);
		~frz_hz.value;
	});

}, ~prefix++'/grid/key');

~frz_hz = { arg v;
	~pitch_b.get({ arg v;
		~hz_base[x] = v;
		postln(["set hz base", v]);
	});
};


/*
~frz_key.free;


~frBuf[0].plot;
cbac*/

/*

~frz_rec.value(0, true);
~frz_rec.value(1, true);
~frz_rec.value(2, true);
~frz_rec.value(3, true);
~frz_rec.value(4, true);
~frz_rec.value(5, true);
~frz_rec.value(5, true);
~frz_rec.value(6, true);
~frz_rec.value(7, true);

~frz_hz.value

~frz_rec.value(0, false);
~frz_rec.value(1, false);
~frz_rec.value(2, false);
~frz_rec.value(3, false);
~frz_rec.value(4, false);
~frz_rec.value(5, false);
~frz_rec.value(6, false);
~frz_rec.value(7, false);

~frz_hz.value(0);
~frz_hz.value(1);
~frz_hz.value(2);
~frz_hz.value(3);
~frz_hz.value(4);
~frz_hz.value(5);
~frz_hz.value(6);
~frz_hz.value(7);
*/