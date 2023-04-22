s = Server.default;
s.options.numInputBusChannels = 2;

// ~start_record = {
// 	Routine {
// 		s.prepareForRecord(Platform.userHomeDir
// 			++ "/Desktop/elements-recordings/capture-"
// 		++ Date.getDate.stamp++".wav");
// 		s.sync;
// 		s.record;
// 	}.play;
// };
//
// ~stop_record = {
// 	s.stopRecording;
// };

s.waitForBoot { Routine {
	postln("init defs");

	ZHbfCap.initDefs;
	ZHbfPb.initDefs;

	z = ();
	z.ncap = 2;
	z.npb = 6;
	z.cap = Array.fill(z.ncap, { ZHbfCap.new; });
	s.sync;
	z.pb = Array.with(
		ZHbfPb.new(z.cap[0].buf),
		ZHbfPb.new(z.cap[0].buf),
		ZHbfPb.new(z.cap[1].buf),
		ZHbfPb.new(z.cap[1].buf),
		ZHbfPb.new(z.cap[1].buf),
		ZHbfPb.new(z.cap[1].buf),
	);

}.play };