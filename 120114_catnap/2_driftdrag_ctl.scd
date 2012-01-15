~swyc_ok = true;

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
	// ~vla_grainbuf_1.zero;
	// ~vla_grainbuf_2.zero;
	// ~vla_grainbuf_3.zero;
};

~quads[2].toggle = false;
~quads[2].quadState = 0;
~quads[2].onAction = {
	var quadIdx = 3;
	postln("quad on " ++ quadIdx);
	4.do({ arg i;
		4.do({ arg j;
			m.led(i + (4 * (quadIdx % 2)), j + (4 * (quadIdx / 2).floor), 1);
		});
	});	
	~driftdrag_end.value;
	if(~swyc_ok, {
		x.value("3_savewhatyoucan.scd");
	});
};
