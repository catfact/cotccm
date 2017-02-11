p = PathName.new(Document.current.path).pathOnly;
x = { |f| this.executeFile(p ++ f); };


x.value("screm_setup.scd");
x.value("trackosc_setup.scd");

