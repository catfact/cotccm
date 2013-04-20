
~voch_t = Array.fill(~nvoch, { SystemClock.seconds });
~voch_state = Array.fill(~nvoch, { false }); // states

~voch_key = OSCdef.newMatching('voch_key', { arg msg, time, addr, rec;
	var x, y, val;
	var t;

	x=msg[1];
	y=msg[2];
	val=msg[3];
	
	if(y == 4, {

		if(val > 0, {
			~voch_t[x] = SystemClock.seconds;

		}, {
			t = SystemClock.seconds - ~voch_t[x];
			t.postln;
			~voch_s[x].set(\amplag, t);

			if(~voch_state[x], {

				~voch_s[x].set(\amp, 0.0);
				~led.value(x, y, 0);
				~voch_state[x] = false;

			}, {
				~voch_s[x].set(\amp, -12.dbamp);
				~voch_s[x].set(\delaytime, t);
				~led.value(x, y, 1);
				~voch_state[x] = true;
			});

		});

	});
}, ~prefix++'/grid/key');


/*
~voch_key.free;
~voch_state

~voch_s
~hzlist
~voch_buf
~nvoch
*/