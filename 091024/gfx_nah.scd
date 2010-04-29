w = SCWindow("_", Rect(0, 0, 640, 480));
w.front;

~col = Array.newClear(4);

~pollbusses = {
	~ezv_amp_b.get({ arg amp;
		~col[0] = Color.new(amp, 0.0, 0.0);
		
	});
	~ezv_centroid_b.get({ arg freq;
		var val;
		val = (((freq.cpsmidi) - 24) / 96.0).min(1.0).max(0.0);
		~col[1] = Color.new(val, val, val);
	});
	~vla_amp_b.get({ arg amp;
		~col[2] = Color.new(0.0, 0.0, amp);
	});
	~vla_centroid_b.get({ arg freq;
		var val;
		val = (((freq.cpsmidi) - 24) / 96.0).min(1.0).max(0.0);
		~col[3] = Color.new(0, val, 0);
	});
};	

w.drawHook = {
	Pen.fillColor = ~col[0];
	Pen.fillRect(Rect(0, 0, w.bounds.width * 0.5, w.bounds.height * 0.5));
	Pen.fillColor = ~col[1];
	Pen.fillRect(Rect( w.bounds.width * 0.5, 0, w.bounds.width * 0.5, w.bounds.height * 0.5));
	Pen.fillColor = ~col[2];
	Pen.fillRect(Rect(0, w.bounds.height * 0.5, w.bounds.width * 0.5, w.bounds.height * 0.5));
	Pen.fillColor = ~col[3];
	Pen.fillRect(Rect( w.bounds.width * 0.5,  w.bounds.height * 0.5, w.bounds.width * 0.5, w.bounds.height * 0.5));
};

~gfxwait = 0.1;
~gfx = Task({inf.do({
	~pollbusses.value;
	{w.refresh }.fork(AppClock);
	~gfxwait.wait;
})});

~gfx.play;