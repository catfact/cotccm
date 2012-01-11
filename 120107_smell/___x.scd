~basepath = Document.current.dir ++"/";
 x = { |p| this.executeFile(~basepath++p); };
 
~xt = 0;
~xtthresh = 4.0;
 
 ~xevents = Pseq([
	//========== GOLD CHAINS
 	{ 
	 	~xnotify.value("GOLD CHAINS");
	 	x.value("_grandel.scd");
	 },
	// add vla delay
	{
	 	~xnotify.value("vla delay");
	 	x.value("vla_echo_goldchains.scd");
	},
	// add grains
	{
	 	~xnotify.value("add grains");
	 	~gran_out_s[2].set(\amplag, 20).set(\amp, 0.25);
	 	~gran_out_s[3].set(\amplag, 20).set(\amp, 0.25);
	 	~gran_out_s[4].set(\amplag, 20).set(\amp, 0.25);
	 	~gran_out_s[5].set(\amplag, 20).set(\amp, 0.25);
	 	~gran_out_s[6].set(\amplag, 20).set(\amp, 0.25);
	},
	// add all grains
	{
	 	~xnotify.value("all grains");
	 	~gran_out_s.do({ arg gro, i;
		 	gro.set(\amplag, 20 - i);
		 	gro.set(\amp, 0.25);
	 	});
	},
	// fade out grains, stop delay
	{
	 	~xnotify.value("stop grains/delay");
	 	~gran_out_s.do({ arg gro, i;
		 	gro.set(\amplag, 20 - i);
		 	gro.set(\amp, 0.0);
	 	});
	 	x.value("vla_echo_goldchains_stop.scd");
	},
	
	//============ LIONS
	{
		~xnotify.value("THE LIONS");
		x.value("__lions.scd");
	},
	
	{ 
		~xnotify.value("lions fadeout");
		~vla_del_g.set(\amplag, 4.0 * 1.2);
		~vla_del.set(\amp, 0.0);
		~rhythm_g.set(\amplag, 2.0 * 1.2);
		~rhythm_g.set(\amp,  0.0);
	},

	
	//=========== CHURCH KEY
	{
		~xnotify.value("CHURCH KEY");
		x.value("__churchkey.scd");
	}, 
	{
		~xnotify.value("churchkey rec A");
		~churchkey_func_a.value;
	},
	{
		~xnotify.value("churchkey play B");
		~churchkey_func_b.value;
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
 
~clock_w = SCWindow.new("clock", Rect(300, 600, 300, 80));
~clock_t = SCStaticText(~clock_w, ~clock_w.view.bounds);
~clock_t.setProperty(\font, Font(\Monaco, 60));
~clock_r = Routine{ inf.do({ arg i;
	{ ~clock_t.string = "" ++ (i / 60).floor ++ "." ++ i; }.defer;
	1.0.wait;
}) }.play;
~clock_w.front;

~xw.front; 