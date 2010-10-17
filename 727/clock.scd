w = SCWindow.new("", Rect(700, 700, 700, 700));
w.front;

f = SCStaticText(w, Rect(0, 0, 700, 700));
f.font = Font("Monaco", 170);

~clockmins = -1;


~clock_r = Routine { inf.do({
	{f.string = ~clockmins.asString}.defer;
	~clockmins = ~clockmins + 1;
	60.wait;
}) }.play;