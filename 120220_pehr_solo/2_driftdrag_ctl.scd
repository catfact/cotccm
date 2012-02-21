~swyc_ok = true;

m.pressFunctions.add(\driftdrag -> { arg x, y;
	("driftdrag " ++ x ++ ", " ++ y).postln;
	if ((x==~mbut.x) && (y==~mbut.y), {
		~driftdrag_end.value;
		if(~swyc_ok, {
			x.value("3_savewhatyoucan.scd");
			~gran.do({ arg gr; gr.free; });
			m.pressFunctions.removeAt(\driftdrag);
		});
	});
});
