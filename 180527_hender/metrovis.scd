~metrowin = Window.new('metro', Rect(0, 0, 200, 200));
~metrowin.front;

~metror = Routine{ inf.do { 
	
	{ ~metrowin.view.background = Color.green; }.defer;
	AppClock.sched(0.1, { ~metrowin.view.background = Color.black; nil });
	AppClock.sched(0.6, { ~metrowin.view.background = Color.blue; nil });
	AppClock.sched(0.7, { ~metrowin.view.background = Color.black; nil });
	
	1.2.wait;
} };

~metror.play;