~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

c = CfAudioContext(s, 2, { Routine {
	x.value("_justloops.scd");
	x.value("analysis.scd");
	x.value("_defs.scd");
	x.value("frz.scd");
	//x.value("_frz_ctl.scd");
}.play });

