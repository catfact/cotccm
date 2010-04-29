w = SCWindow("_", Rect(407, 4, 865, 752));
w.front;

z = SCWindow(" ", Rect(0, 0, 100, 100));
z.front;
z.view.background = Color.white;
~zbox = SCTextField(z, Rect(0, 0, 100, 100));
~zbox.setProperty(\font, Font("Arial", 72));

~col = Array.with(Color.white, Color.white);

w.drawHook = {
	Pen.fillColor = ~col[0];
	Pen.fillRect(Rect(0, 0, w.bounds.width * 0.5, w.bounds.height));
	Pen.fillColor = ~col[1];
	Pen.fillRect(Rect(w.bounds.width * 0.5, 0, w.bounds.width * 0.5, w.bounds.height));
};

~fadeup = { arg which, num;
	Routine {
		if(which ==0, {~zbox.string = num; });
		100.do ({ arg i;
			var val = 1.0 - (i * 0.01);
			~col[which] = Color.new(val, val, val);
			w.refresh;
			0.1.wait;
		});
		~col[which] = Color.white;
		w.refresh;
	}.play(AppClock);
};

~tellme = {
	var win, rout;
	
	win = SCWindow("", Rect(0, 0, 600, 600));
	win.drawHook = {
		Pen.fillColor = Color.new(1.0.rand, 1.0.rand, 1.0.rand);
		Pen.fillRect(w.bounds);
	};
	win.front;
	rout = Task({ 200.do({
		{ win.refresh; }.defer;
		0.02.wait;
	})}).play;
	
	AppClock.sched(4.0, {
		rout.stop;
		win.close;
		nil
	});
};
			
