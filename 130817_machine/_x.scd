
~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.local;
s.options.numAudioBusChannels = 512;
s.options.numAudioBusChannels.postln;

c = CfAudioContext.new(s, 2, { Routine {

	x.value("_defs.scd");

	s.sync;

	x.value("monome.scd");
	x.value("monome_ctl.scd");

	x.value("analysis.scd");

	x.value("echo.scd");
	x.value("echo_set.scd");

	x.value("touchosc_patch.scd");
	x.value("touchosc_xy12.scd");
	x.value("touchosc_xy34.scd");



}.play; });


NetAddr.langPort.postln;
thisProcess.openUDPPort(57120);
thisProcess.openUDPPort(57121);