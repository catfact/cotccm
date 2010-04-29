w = SCWindow("_", Rect(407, 4, 865, 752));
w.front;

~col = Color.white;

w.drawHook = {
	Pen.fillColor = ~col;
	Pen.fillRect(Rect(0, 0, w.bounds.width, w.bounds.height));
};

~fadeup = {
	Routine {
		100.do ({ arg i;
			var val = 1.0 - (i * 0.01);
			~col = Color.new(val, val, val);
			w.refresh;
			0.1.wait;
		});
		~col = Color.white;
		w.refresh;
	}.play(AppClock);
};
		