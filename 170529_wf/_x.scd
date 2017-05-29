p = PathName.new(Document.current.path).pathOnly;
x = { |f| this.executeFile(p ++ f); };

x.value("0_audio.scd");
x.value("_sines.scd");
/*
~sine_r.stop;
*/