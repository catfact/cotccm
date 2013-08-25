~echr = [
	[1.25, 1.5],
	[2.0, 1.75],
	[3.0, 1.5],
	[1, 1],
	[0.5, 0.8],
	[0.5, 0.25],
	[0.75, 0.5]
];

~echridx = 0;
~echridxbase = 3;

~sethz = { arg idx, param, val;
	if(val > 0, {
		~pitch_b.get({ arg hz;
			//	hz.postln;
			//			 ~post.value(""++param++"_"++idx++"_"++hz);
			~hz_add.value(hz);
			~pm[idx].set(param, hz)
		});
	});
};

~sethzlag = { arg idx, val;
	var lag;
	lag = if(val > 0, { 2 * (idx + 1) }, { 0.0625 * idx });
	~pm[idx].set(\hz1lag, lag);
	~pm[idx].set(\hz2lag, lag);
	~pm[idx].set(\hz3lag, lag);
};

~setamp = { arg idx, val;
	if(val > 0, { // toggle
		~pm[idx].get(\amp, { arg amp;
			if(amp > 0, {
				~led.value(0, idx, 0);
				//				~post.value("pms_"++idx++"_0");
				~pm[idx].set(\amplag, 6.0 + 1.0.rand);
				~pm[idx].set(\amp, 0.0);
			}, { 
				~led.value(0, idx, 1);
				//				~post.value("pms_"++idx++"_1");
				~pm[idx].set(\amplag, 0.01 + 0.1.rand);
				~pm[idx].set(\amp, -44.dbamp);
			});
		});
	});
};

~setpm12 = { arg idx, val, lag;
	~pm[idx].set(\pm12lag, lag + 0.06.rand;);
	~pm[idx].set(\pm12, val * 0.8);
};

~setpm23 = { arg idx, val, lag;
	if(val < 0.1, { lag = 0.06; });
	~pm[idx].set(\pm23lag, lag + 0.06.rand;);
	~pm[idx].set(\pm23, val * 0.8);
};

~setpm31 = { arg idx, val, lag;
	if(val > 0, { lag = 0.06; });
	~pm[idx].set(\pm31lag, lag + 0.06.rand;);
	~pm[idx].set(\pm31, val * 0.8);
};


~setvochamp = { arg val;
	~post.value("vdin_"++val);
	~vinp.set(\amp, val);
};

~setvochdel = { arg idx; 
	//	postln("vohcdel" ++ idx);
	var txt = [ "" , "" ];
	var v;
	Routine {
		if(idx > 0, {
			~voch1.get(\delaytime, { arg val;
				v = val * ~vochdelr;
				~post.value("vd1_" ++ v);
				~voch1.set(\delaytime, v);
			});
			~voch2.get(\delaytime, { arg val;
				v = val * ~vochdelr;
				~post.value("vd2_" ++ v);
				~voch2.set(\delaytime, v);
			});
		}, {
			~voch1.get(\delaytime, { arg val;
				v = val / ~vochdelr;
				~post.value("vd1_ " ++ v);
				~voch1.set(\delaytime, v);
			});
			~voch2.get(\delaytime, { arg val;
				v = val / ~vochdelr;
				~post.value("vd2_ " ++ v);
				~voch2.set(\delaytime, v);
			});
		});
		s.sync;
		//		~post.value(txt);
	}.play;
};


~setvochshift = { arg dir;
var v; 

~echridx = (~echridx + dir).wrap(0, ~echr.size - 1);

v = ~echr[~echridx][0];
~voch1.set(\shift, v);
~post.value("vs1_"++v);
v = ~echr[~echridx][1];
~voch2.set(\shift, v);
~post.value("vs2_"++v);
};

~resetvochshift = { 
//~voch1.set(\shift, 1.0);
//~voch2.set(\shift, 1.0);
~post.value("vs 1.0");
};

/*
~pm_key = OSCdef.newMatching('pm_key', { arg msg, time, addr, rec;
	var x, y, val;

	x=msg[1];
	y=msg[2];
	val=msg[3];
	
	if(y < ~npm, {
		x.switch(
			0, { ~setamp.value( y, val); },
			1, { ~sethz.value(y, \hz1, val);  ~led.value(x, y, val); },
			2, { ~sethz.value(y, \hz2, val);  ~led.value(x, y, val); },
			3, { ~sethz.value(y, \hz3, val);  ~led.value(x, y, val); },
			4, { ~setpm12.value(y, val, 8.0); ~led.value(x, y, val); },
			5, { ~setpm23.value(y, val, 8.0); ~led.value(x, y, val); },
			6, { ~setpm31.value(y, val, 8.0); ~led.value(x, y, val); },
		);
	});
}, ~prefix++'/grid/key');
*/


	
//	~pm_key.free;

~handleKey= { arg ch, val;
[ch, val].postln;
ch.switch(
	$1, { ~sethz.value(0, \hz1, val); },
	$2, { ~sethz.value(1, \hz1, val); },
	$3, { ~sethz.value(2, \hz1, val); },
	$4, { ~sethz.value(3, \hz1, val); },

	//	$5, { ~sethzlag.value(0, val); },
	//	$6, { ~sethzlag.value(1, val); },
	//	$7, { ~sethzlag.value(2, val); },
	//	$8, { ~sethzlag.value(3, val); },



	$q, { ~sethz.value(0, \hz2, val); },
	$w, { ~sethz.value(1, \hz2, val); },
	$e, { ~sethz.value(2, \hz2, val); },
	$r, { ~sethz.value(3, \hz2, val); },

	$a, { ~sethz.value(0, \hz3, val); },
	$s, { ~sethz.value(1, \hz3, val); },
	$d, { ~sethz.value(2, \hz3, val); },
	$f, { ~sethz.value(3, \hz3, val); },

	$z, { ~setamp.value(0, val); },
	$x, { ~setamp.value(1, val); },
	$c, { ~setamp.value(2, val); },
	$v, { ~setamp.value(3, val); },

	$t, { ~setpm12.value(0, val, 6.0 ); },
	$y, { ~setpm12.value(1, val, 7.0 ); },
	$u, { ~setpm12.value(2, val, 8.0 ); },
	$i, { ~setpm12.value(3, val, 9.0 ); },

	$g, { ~setpm23.value(0, val, 4 ); },
	$h, { ~setpm23.value(1, val, 5 ); },
	$j, { ~setpm23.value(2, val, 6 ); },
	$k, { ~setpm23.value(3, val, 7 ); },

	$b, { ~setpm31.value(0, val, 5.1 + 0.7.rand ); },
	$n, { ~setpm31.value(1, val, 6.1 + 0.7.rand ); },
	$m, { ~setpm31.value(2, val, 7.1 + 0.7.rand ); },
	$,, { ~setpm31.value(3, val, 8.1 + 0.7.rand ); },

	$-, { ~setvochamp.value(0.0); },
	$=, { ~setvochamp.value(1.0); },
	
	$[, { if(val > 0, { ~setvochshift.value(-1); }); },
	$], { if(val > 0, { ~setvochshift.value(1); }); },

	$;, { if(val > 0, { ~setvochdel.value(0); }); },
	$', { if(val > 0, { ~setvochdel.value(1); }); },

	$\\, { if(val > 0, { 4.do({ arg i; ~resetvochshift.value; }); }); },

	//	$ , { if(val>0, { ~lrec_tog.value}); }
	//	$ , { if(val>0, { ~lrec_tog.value}); }
	$ , { if(val > 0, { ~setgrains.value; } ); },
	$`, { if(val > 0, { ~anapop.value(~ar, ~at); } ); }

	//	$\\, { if(val > 0, { 4.do({ arg i; ~setamp.value(i, 0); }); }); }
); };

