~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };


x.value("___groan.scd");


x.value("midi_init.scd");
x.value("churchkey.scd");

x.value("churchkey_stop.scd");

x.value("_liedown.scd");


