~savebuf = Buffer.alloc(s, 300 * s.sampleRate, 1);


~savebuf_7 = Buffer.alloc(s, 300 * s.sampleRate, 1);


~savebuf_2 = Buffer.alloc(s, 300 * s.sampleRate, 1);

~echo_buf[2].copyData(~savebuf_2);
~echo_buf[2].copyData(~savebuf_2, srcStartAt:(s.sampleRate * 300));

~savebuf_2.plot;


~echo_buf[6].copyData(~savebuf_7, srcStartAt:(s.sampleRate * 300));

~savebuf.plot;
~savebuf_7.plot;

~which_xy12.postln;



	echo_s.do({ |syn|
		syn.set(\time_lag, 14);
		//		syn.set(\amp, 0.0);
	});


~echo_s[7].get(\time, { |v| v.postln; });

~savebuf.plot;