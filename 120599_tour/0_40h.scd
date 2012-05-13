m = Cf40h.new;

// divide the 40h into 4 regions
m.press = {};
m.lift = {};
m.pressFunctions.clear;
m.liftFunctions.clear;

m.pressFunctions.add('post'->{arg x, y; postln(["press", x, y]); });
m.liftFunctions.add('post'->{arg x, y; postln(["lift", x, y]); });
