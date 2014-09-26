
s = Server.local;
/*
s.boot;
*/

c = CfAudioContext.new(s, 2, { Routine {

	// input buffer:
	~blen = 128;
	~bbuf = Buffer.alloc(s, s.sampleRate * ~blen, 1);
	/// TEST
	//	~bbuf = Buffer.readChannel(s, "/home/emb/sc/bbbcch.wav", channels:[0]);

	s.sync;


	// analysis:
	x.value("analysis.scd");

	~recBuf.value(~bbuf, 0, {

		x.value("happens.scd");
	});


}.play; });