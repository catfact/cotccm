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

x.value("handlekey.scd");
x.value("handlemouse.scd");
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