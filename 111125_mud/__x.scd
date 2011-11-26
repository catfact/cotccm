~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.local;
~ctx = CfAudioContext.new(s, 2, { 
	Routine {
		x.value("freeze.scd");
		x.value("crawl.scd");
		s.sync;
		x.value("_canvas.scd");
		0.1.wait;
		x.value("_40h.scd");
		0.1.wait;
		x.value("_keys.scd");
	}.play;
});