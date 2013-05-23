~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.local;

c = CfAudioContext.new(s, 2, { Routine {

	x.value("_defs.scd");

	s.sync;

	x.value("monome.scd");
	x.value("analysis.scd");
	x.value("hzseq.scd");

	x.value("frz.scd");
	x.value("frz_ctl.scd");

	x.value("bleec.scd");	

	x.value("pm.scd");
	x.value("pm_ctl.scd"); // map monome to oscs

	x.value("voch.scd");
	0.1.wait;
	x.value("voch_ctl.scd");
	x.value("spurs.scd");

	/*
		x.value("ctl.scd");
		w.fullScreen;
	*/

	


}.play; });


/*


	z = { SoundIn.ar(0).dup }.play;
	z.run(false);
*/



//// pitch notes
