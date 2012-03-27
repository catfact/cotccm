~swyc_ok = true;

~vlon = false;
~whichdel = 0;

	~vla_del4.del_s[0].set(\amp, 0.25);
	~vla_del4.del_s[1].set(\amp, 0.25);
	~vla_del4.del_s[2].set(\amp, 0.15);
	~vla_del4.del_s[3].set(\amp, 0.15);
	~vla_del4.del_s[0].set(\fb, 0.025);
	~vla_del4.del_s[1].set(\fb, 0.025);
	~vla_del4.del_s[2].set(\fb, 0.01);
	~vla_del4.del_s[3].set(\fb, 0.01);

~delt = CfTapper.new;
~delt.tap;

m.pressFunctions.add(\driftdrag -> { arg x, y;
	("driftdrag press" ++ x ++ ", " ++ y).postln;
	if ((x==~mbut.x) && (y==~mbut.y), {
		if(~vlon, {
			~vlon = false;
			~vla_in_s.set(\amp, 0.0);
			~delt.tap;
			~vla_del4.del_s[~whichdel].set(\time, ~delt.time);
			~vla_in_s.set(\amplag, ~delt.time * 0.125);
			~whichdel = (~whichdel + 1) % 4;
			~whichfreeze = (~whichfreeze + 1) % 8;
			~setamplag.value(~whichfreeze, ~delt.time);
			~notify.value("DRIFTDRAG : VLA OFFFF");
		}, {
			~vlon = true;
			~vla_in_s.set(\amp, 1.0);
			~notify.value("DRIFTDRAG : VLA ONNNNN");
		});
		/*
		~driftdrag_end.value;
		if(~swyc_ok, {
			x.value("3_savewhatyoucan.scd");
			~gran.do({ arg gr; gr.free; });
			m.pressFunctions.removeAt(\driftdrag);
		});
		*/
	});
});