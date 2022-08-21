p = PathName(Document.current.path).pathOnly;
f = { arg name; this.executeFile(p ++ name ++ ".scd") };

f.value("x");
f.value("y");
