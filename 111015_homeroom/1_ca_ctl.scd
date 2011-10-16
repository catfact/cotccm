~driftdrag_ok = true;

~quads[3].toggle = false;
~quads[3].quadState = 0;
~quads[3].onAction = {
	var quadIdx = 3;
	postln("quad on " ++ quadIdx);
	4.do({ arg i;
		4.do({ arg j;
			m.led(i + (4 * (quadIdx % 2)), j + (4 * (quadIdx / 2).floor), 1);
		});
	});	
	~doGrain.value(0, 0.5, 2000, 2.0);
};

~quads[1].toggle = false;
~quads[1].quadState = 0;
~quads[1].onAction = {
	var quadIdx = 1;
	postln("quad on " ++ quadIdx);
	4.do({ arg i;
		4.do({ arg j;
			m.led(i + (4 * (quadIdx % 2)), j + (4 * (quadIdx / 2).floor), 1);
		});
	});	
	~doGrain.value(1, 0.25, 800, 2.0);
};

~quads[0].toggle = false;
~quads[0].quadState = 0;
~quads[0].onAction = {
	~vla_del_s.free;
	if(~driftdrag_ok, {
		x.value("2_driftdrag.scd");
		x.value("2_driftdrag_ctl.scd");
	});
}