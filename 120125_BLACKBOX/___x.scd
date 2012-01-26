~basepath = Document.current.dir ++"/";
 x = { |p| this.executeFile(~basepath++p); };
 
~xt = 0;
~xtthresh = 4.0;
 
 ~xevents = Pseq([
 	{ 
	 	~xnotify.value("AGONISTS");
	 	s = Server.local;
		s.waitForBoot {
	 		Routine {
		 		x.value("defs.scd");
			 	s.sync;
			 	x.value("_agonists.scd");
		 	}.play;
		};
	 },
 	{ 
	 	~xnotify.value("AGONISTS 1");
	 	~agonists_1.value(32.0);
	 	
	 },
 	{ 
	 	~xnotify.value("AGONISTS 2");
	 	~agonists_2.value(32.0);
	 	
	 },
 	{ 
	 	~xnotify.value("AGONISTS 3");
	 	~agonists_3.value(32.0);
	 	
	 },
 	{ 
	 	~xnotify.value("AGONISTS CHOP");
	 	x.value("_agonists_chop.scd");	 	
	 }
 ]).asStream; 
 
 ~xw = SCWindow.new("XXXXXXXXXXXXXX", Rect(0, 0, 500, 500)); //SCWindow.screenBounds);
 
 ~xw.view.background = Color.white;
 ~xtxt = SCStaticText(~xw, ~xw.view.bounds);
 ~xtxt.font = Font("Andale Mono", 56);
 
 ~xw.view.keyDownAction = { arg view, char;
	if(char == $ , {
		if ((SystemClock.seconds - ~xt) > ~xtthresh, {
			~xevents.next.value;
			~xt = SystemClock.seconds;
		});
	});
};
 
 ~xnotify = { |txt| { ~xtxt.string = txt; ~xw.refresh; }.defer; };
 
 /*
~clock_w = SCWindow.new("clock", Rect(300, 600, 300, 80));
~clock_t = SCStaticText(~clock_w, ~clock_w.view.bounds);
~clock_t.setProperty(\font, Font(\Monaco, 60));
~clock_r = Routine{ inf.do({ arg i;
	{ ~clock_t.string = "" ++ (i / 60).floor ++ "." ++ i; }.defer;
	1.0.wait;
}) }.play;
~clock_w.front;
*/

~xw.front; 