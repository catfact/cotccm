x = { |f| this.executeFile(PathName(Document.current.path).pathOnly ++ f); };

x.value("grains.scd");
x.value("monome.scd");


/*
~grstartrec.value;
~grstoprec.value;

~grsyn.wrapAt(-2).set(\rate, 0.25);

~grsyn.last.set(\rate, 0.5);
~grsyn.last.set(\rate, 0.25);

~grsyn.last.set(\amp, 1.5);
*/
