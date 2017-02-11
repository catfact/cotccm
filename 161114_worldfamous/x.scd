
x = { |f| this.executeFile(PathName(Document.current.path).pathOnly ++ f); };

x.value("_defs.scd");
x.value("grains.scd");
x.value("monome.scd");
x.value("analysis.scd");

/*
x.value("refresh.scd");
x.value("cluster.scd");
x.value("form_sort.scd");
x.value("gouge_beets.scd");
*/

/*
~grstartrec.value;
~grstoprec.value;

~grsyn.wrapAt(-2).set(\rate, 0.25);

~grsyn.last.set(\rate, 0.5);
~grsyn.last.set(\rate, 0.25);

~grsyn.last.set(\amp, 1.5);
*/


/*
	~grbuf[0].copyData(~norm_buf, numSamples:24 * s.sampleRate);
	~norm_buf.normalize;
*/