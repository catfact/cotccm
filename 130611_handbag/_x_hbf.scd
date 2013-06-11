~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.local;
s.options.numAudioBusChannels = 512;
s.options.numAudioBusChannels.postln;

c = CfAudioContext.new(s, 2, { Routine {

	x.value("_defs.scd");

	s.sync;

	x.value("monome.scd");

	x.value("analysis.scd");

	x.value("hzseq.scd");

	x.value("frz.scd");
	x.value("frz_ctl.scd");

	x.value("bleec.scd");	

	//	x.value("pm.scd");
	//	x.value("pm_ctl.scd"); // map monome to oscs

	x.value("fltswp.scd"); 
	x.value("fltswp_ctl.scd"); 

	x.value("voch.scd");
	s.sync;

	

	//	x.value("spurs.scd");

	/*	
~swps
		////////////////////////
		////////////

	 	x.value("fltl.scd");

		///////////////
		////////////
	*/



	/*
		x.value("ctl.scd");
		w.fullScreen;
	*/

	/*
	q = { WhiteNoise.ar.dup * -24.dbamp }.play;
	q.free;
	*/

}.play; });


/*


	z = { SoundIn.ar(0).dup }.play;
	z.run(false);
*/



//// pitch notes
