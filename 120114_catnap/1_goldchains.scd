~notify.value("GOLD CHAINS");
x.value("_grandel.scd");

~goldchains_events = Pseq([
	// add vla delay
	{
	 	~notify.value("vla delay");
	 	x.value("vla_echo_goldchains.scd");
	},
	
	// start del timer
	{
	 	~notify.value("start del timer");
	 	~vla_del_t = SystemClock.seconds;
	},
	// stop del timer
	{
	 	~notify.value("stop del timer");
	 	~vla_del_t = SystemClock.seconds - ~vla_del_t;
		~vla_del4.del_s[0].set(\delaytime, ~vla_del_t);
		~vla_del4.del_s[1].set(\delaytime, ~vla_del_t * 2.0);
	},
	// add grains
	{
	 	~notify.value("add grains");
	 	~gran_out_s[2].set(\amplag, 20).set(\amp, 0.25);
	 	~gran_out_s[3].set(\amplag, 20).set(\amp, 0.25);
	 	~gran_out_s[4].set(\amplag, 20).set(\amp, 0.25);
	 	~gran_out_s[5].set(\amplag, 20).set(\amp, 0.25);
	 	~gran_out_s[6].set(\amplag, 20).set(\amp, 0.25);
	},
	// add all grains
	{
	 	~notify.value("all grains");
	 	~gran_out_s.do({ arg gro, i;
		 	gro.set(\amplag, 20 - i);
		 	gro.set(\amp, 0.25);
	 	});
	},
	// fade out grains, stop delay
	{
	 	~notify.value("stop grains/delay");
	 	~gran_out_s.do({ arg gro, i;
		 	gro.set(\amplag, 20 - i);
		 	gro.set(\amp, 0.0);
	 	});
	 	x.value("vla_echo_goldchains_stop.scd");
	},
	{
		if(~driftdrag_ok, {
		x.value("2_driftdrag.scd");
		x.value("2_driftdrag_ctl.scd");
	});
	}
]).asStream;
