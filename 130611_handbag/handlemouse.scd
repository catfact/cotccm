
w.view.mouseDownAction = {
	arg view, x, y, mod, but, clicks;

	var hz, fhz, nx, ny, rq;

	"mouse down action".postln;

	nx = x/(w.bounds.width);
	ny = y/(w.bounds.height);
	hz = ~analist[ (nx * ~analist.size).floor ].pitch;
	fhz = ~analist[(y/(w.bounds.height) * ~analist.size).floor].cent;

	["SAW : ", hz, fhz].postln;
	
	if(ny > nx,  { rq = nx / ny; }, { rq = ny / nx; });
	Synth.new(\saw_1shot_rez_dist, [
		\hz, hz, \rhz, hz * 3, \rq, rq, \level, -24.dbamp
	]);
	//	~post.value("saw_hz:"++hz++"_fhz:"++fhz++"_rq:"++rq);
	~post.value("saw_rq:"++rq);
	//	w.view.background = Color.new(ny/nx, 0, 0);
	//	w.refresh;
	//	postln("mouse down: " ++ but );
};

/*
w.view.mouseUpAction = {
	arg view, x, y, mod, but, clicks;
	postln("mouse up: " ++ x ++ " , " ++ y );
};
*/
w.view.mouseUpAction = {
	arg view, x, y, mod, but, clicks;
};

w.view.mouseMoveAction = {
	arg view, x, y, mod, but, clicks;
	var hz, fhz, nx, ny, rq;

	postln("mouse move: " ++ x ++ " , " ++ y );

	nx = x/(w.bounds.width);
	ny = y/(w.bounds.height);
	hz = ~analist[ (nx * ~analist.size).floor ].pitch;
	fhz = ~analist[(y/(w.bounds.height) * ~analist.size).floor].cent;
	//	hz = ~hzlist[ (nx * ~hzlist.size).floor ];
	//	fhz = ~hzlist[(y/(w.bounds.height) * ~hzlist.size).floor];

	["SAW : ", hz, fhz].postln;
	
	if(ny > nx,  { rq = nx / ny; }, { rq = ny / nx; });
	Synth.new(\saw_1shot_rez_dist, [
		\hz, hz, \rhz, hz * 3, \rq, rq, \level, -24.dbamp
	]);
	//	~post.value("saw_hz:"++hz++"_fhz:"++fhz++"_rq:"++rq);
	~post.value("saw_rq:"++rq);

};


w.view.mouseOverAction = {
	arg view, x, y, mod, but, clicks;
	postln("mouse over: " ++ x ++ " , " ++ y );
};
