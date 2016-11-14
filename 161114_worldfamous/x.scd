x = { |f| this.executeFile(PathName(Document.current.path).pathOnly ++ f); };

x.value("grains.scd");
x.value("monome.scd");


/*
~grstartrec.value;
~grstoprec.value;


~grsyn.d
*/

