~notify.value("GOLD CHAINS");
x.value("_grandel.scd");

~goldchains_events = Pseq([
	// add vla delay
	{
	 	~notify.value("vla delay");
	 	x.value("vla_echo_goldchains.scd");
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
