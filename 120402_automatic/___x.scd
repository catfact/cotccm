~basepath = Document.current.dir ++"/";
 x = { |p| this.executeFile(~basepath++p); };
 
Routine {

	x.value("0_40h.scd");
	x.value("0_audio.scd");
	~mbut = Point(1, 1);	 
	4.wait;
	x.value("vla_echo_goldchains.scd");
	4.wait;
	x.value("2_driftdrag.scd");
	x.value("2_driftdrag_ctl.scd");
}.play;



~clock_w = SCWindow.new("clock", Rect(300, 600, 300, 80));
~clock_t = SCStaticText(~clock_w, ~clock_w.view.bounds);
~clock_t.setProperty(\font, Font(\Monaco, 60));
~clock_r = Routine{ inf.do({ arg i;
	{ ~clock_t.string = "" ++ (i / 60).floor ++ "." ++ i; }.defer;
	1.0.wait;
}) }.play;
~clock_w.front;


~notify = { arg string, color;
	var win, text;
	{
		win = SCWindow.new(nil, SCWindow.screenBounds.insetBy(100));
		if(color.isNil, { color = Color.new(1.0, 1.0.rand, 1.0.rand, 0.5); });
		win.view.background = color; 
		text = SCStaticText(win, win.view.bounds);
		text.font = Font("Andale Mono", 54);
		text.string = string;
		win.front;
		string.postln;
	//	win.refresh;
		AppClock.sched(4.0, {win.close; nil});
	}.defer;
};