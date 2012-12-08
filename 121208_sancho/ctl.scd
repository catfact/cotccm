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
x.value("handlemouse.scd");

w.acceptsMouseOver = true;
w.front
/*
w.fullScreen;
w.close;
*/

