~basepath = "/home/emb/sc/cotccm/140708_gel_n/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.local;
/*
s.boot;
*/

c = CfAudioContext.new(s, 2, { Routine {

	// input buffer:
	~blen = 220;
	~bbuf = Buffer.alloc(s, s.sampleRate * ~blen, 1);
	/// TEST
	//	~bbuf = Buffer.readChannel(s, "/home/emb/sc/bbbcch.wav", channels:[0]);

	s.sync;
	//	~bbuf.inspect;
	"channels: ".post; ~bbuf.numChannels.postln;
	"length: ".post; ~bbuf.duration.postln;

	//	record:
	~rec = c.recOnce(1, ~bbuf.bufnum);

	// analysis:
	x.value("analysis.scd");

	~bct = SystemClock.seconds;

//	~blen.wait;

	/*
	~bbuf.plot;

	x.value("happens.scd");
	x.value("more.scd");
	x.value("moremore.scd");
	*/
}.play; });