w = Window.new;
w.view.background = Color.black;

w.view.keyDownAction = { 
	arg v, ch;
	~handleKey.value(ch, 1);
};

w.view.keyUpAction = { 
	arg v, ch;
	~handleKey.value(ch, 0);
};

w.view.mouseDownAction = {
	arg view, x, y, mod, but, clicks;

	var hz, fhz, nx, ny, rq;
	nx = x/(w.bounds.width);
	ny = y/(w.bounds.height);
	hz = ~hzlist[ (nx * ~hzlist.size).floor ];
	fhz = ~hzlist[(y/(w.bounds.height) * ~hzlist.size).floor];
	if(ny > nx,  { rq = nx / ny; }, { rq = ny / nx; });
	Synth.new(\saw_1shot_rez_dist, [
		\hz, hz, \rhz, hz * 3, \rq, rq, \level, -12.dbamp
	]);
	//	~post.value("saw_hz:"++hz++"_fhz:"++fhz++"_rq:"++rq);
	~post.value("saw_rq:"++rq);
	//	w.view.background = Color.new(ny/nx, 0, 0);
	//	w.refresh;
	//	postln("mouse down: " ++ but );
};

w.view.mouseUpAction = {
	arg view, x, y, mod, but, clicks;
};

w.view.mouseMoveAction = {
	arg view, x, y, mod, but, clicks;
	//	postln("mouse move: " ++ x ++ " , " ++ y );
};


w.view.mouseOverAction = {
	arg view, x, y, mod, but, clicks;
	//	postln("mouse over: " ++ x ++ " , " ++ y );
};


x.value("handlekey.scd");
//x.value("handlemouse.scd");
x.value("viz.scd");

w.acceptsMouseOver = true;
w.front;
/*
w.fullScreen;
w.close;
*/

/*
~buthzi = Pseq([0, 1], inf).asStream;
~buthzp = Pseq([\hz1, \hz2, \hz3 ], inf).asStream;
~but_func[2] = {
	"aarh".postln;
	~sethz.value(~buthzi.next, ~buthzp.next, 1);
};
*/