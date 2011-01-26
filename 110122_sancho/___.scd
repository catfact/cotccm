~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

x.value("midi_init.scd");
x.value("___gran_mpk.scd");
x.value("churchkey.scd");

/*
x.value("churchkey_stop.scd");

x.value("_liedown.scd");


*/