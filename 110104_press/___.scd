/*
Server.killAll;
*/

~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

x.value("_lions.scd");


x.value("midi_init.scd");

x.value("churchkey.scd");
x.value("churchkey_stop.scd");


x.value("_liedown.scd");

x.value("grandel.scd");
x.value("_grun.scd");



