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
		~pitch_b.get({ arg v;
			~hz_base[x] = v;
			postln(["set hz base", v]);
		});
	});

}, ~prefix++'/grid/key');


/*
~frz_key.free;

~hz_base.postln;

~frBuf[0].plot;
cbac*/