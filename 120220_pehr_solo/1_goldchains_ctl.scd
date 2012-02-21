~driftdrag_ok = true;

/*
~quads[0].toggle = false;
~quads[0].quadState = 0;
~quads[0].onAction = {
	~goldchains_events.next.value;
}
*/

// single switch
m.pressFunctions.add(\goldchains -> { arg x, y;
	("goldchains " ++ x ++ ", " ++ y).postln;
	if ((x==~mbut.x) && (y==~mbut.y), {
		~goldchains_events.next.value;
	});
});