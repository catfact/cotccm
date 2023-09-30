p = PathName.new(Document.current.path).pathOnly;
x = { |f| var pf = p ++ f; pf.postln; pf.class.postln; this.executeFile(pf); };
x.value("0_audio.scd")

w = Window.new.front;


