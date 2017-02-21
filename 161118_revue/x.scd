x = { |f| this.executeFile(PathName(Document.current.path).pathOnly ++ f); };

Routine { 

	x.value("0_audio.scd");
	x.value("monome.scd");

	2.wait;
	
	x.value("3_savewhatyoucan.scd");


	{ 

		~clock_w = Window.new("clock", Rect(300, 600, 300, 80));
		~clock_t = StaticText(~clock_w, ~clock_w.view.bounds);
		~clock_t.setProperty(\font, Font(\Monaco, 60));
		~clock_r = Routine{ inf.do({ arg i;
			{ ~clock_t.string = "" ++ (i / 60).floor ++ "." ++ i; }.defer;
			1.0.wait;
		}) }.play;
		~clock_w.front;

		~notify = { arg string, color;
			var win, text;
			{
				win = Window.new(nil, Window.screenBounds.insetBy(100));
				if(color.isNil, { color = Color.new(1.0, 1.0.rand, 1.0.rand, 0.5); });
				win.view.background = color; 
				text = StaticText(win, win.view.bounds);
				text.font = Font("Andale Mono", 54);
				text.string = string;
				win.front;
				string.postln;
				//	win.refresh;
				AppClock.sched(4.0, {win.close; nil});
			}.defer;
		};
	}.defer;

}.play;