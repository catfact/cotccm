//~basepath = "/home/emb/sc/cotccm/130309_smell/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.local;

c = CfAudioContext.new(s, 2, { Routine {
	

	x.value("_justloops.scd");

		4.wait;

	x.value("_recordcycle.scd");

}.play; });



~notify = { arg string, color;
	/*
	var win, text;
	{
		win = Window.new(nil, Rect(0, 0, 500, 500));
		if(color.isNil, { color = Color.new(1.0, 1.0.rand, 1.0.rand, 0.5); });
		win.view.background = color; 
		text = StaticText(win, win.view.bounds);
		text.font = Font("Andale Mono", 200);
		text.string = string;
		win.front;
		string.postln;
	//	win.refresh;
		AppClock.sched(4.0, {win.close; nil});
	}.defer;
	*/
	~post.value(string);
};