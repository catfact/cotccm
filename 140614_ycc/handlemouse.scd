
w.view.mouseDownAction = {
	arg view, x, y, mod, but, clicks;

	var hz, fhz, nx, ny, rq, clar, ev;

	"mouse down action".postln;
	//	but.postln;

	nx = x/(w.bounds.width);
	ny = y/(w.bounds.height);
	//a	~analist.postln;
	ev = ~analist[ (nx * ~analist.size).floor ];
	ev.postln;
	hz = ev.pitch;
	fhz = ev.cent;
	clar = ev.clar;
	//	clar.postln;
	//	fhz = ~analist[(y/(w.bounds.height) * ~analist.size).floor];

	["SAW : ", hz, fhz].postln;
	
	if(ny > nx,  { rq = nx / ny; }, { rq = ny / nx; });
	if(but == 0, {
		Synth.new(\saw_1shot_rez_dist, [
			\hz, hz, \rhz, fhz, \rq, rq, \level, -24.dbamp
		]);
	}, {
		Synth.new(\sine_1shot, [
			\hz, hz, \rhz, fhz, \rq, rq, \level, -30.dbamp
		]);
		Synth.new(\noise_1shot_rez, [
			\hz, hz, \rhz, hz, \rq, (1.0 - clar).max(0.08), \level, (1.0 - clar)* -12.dbamp
		]);


	});
	~post.value("saw_hz:"++hz);//++"_fhz:"++fhz++"_rq:"++rq);
	~post.value("saw_fhz:"++fhz);//++"_fhz:"++fhz++"_rq:"++rq);
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

w.view.mouseMoveAction = w.view.mouseDownAction; 
/*
{
	arg view, x, y, mod, but, clicks;
	var hz, fhz, nx, ny, rq;

	postln("mouse move: " ++ x ++ " , " ++ y );

	nx = x/(w.bounds.width);
	ny = y/(w.bounds.height);
	hz = ~analist[ (nx * ~analist.size).floor ];
	fhz = ~analist[(y/(w.bounds.height) * ~analist.size).floor];

	["SAW : ", hz, fhz].postln;
	
	//	if(ny > nx,  { rq = nx / ny; }, { rq = ny / nx; });
	rq = ny;
	Synth.new(\saw_1shot_rez_dist, [
		\hz, hz, \rhz, hz * 3, \rq, rq, \level, -30.dbamp, \pan, nx* 2.0 - 1.0
	]);
~post.value("saw_hz:"++hz); //++"_fhz:"++fhz++"_rq:"++rq);
~post.value("saw_rq:"++rq);

};
*/

w.view.mouseOverAction = {
	arg view, x, y, mod, but, clicks;
	postln("mouse over: " ++ x ++ " , " ++ y );
};
