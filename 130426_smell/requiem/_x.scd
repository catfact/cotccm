~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

Routine {
	x.value("midi.scd");
	s.sync;
	x.value("events.scd");
	s.sync;
	x.value("voch.scd");
	0.5.wait;
	x.value("voch_ctl.scd");
	s.sync;
}.play;

/*
~voch_buf[0].duration
*/