~sethz = { arg idx, param, val;
	if(val > 0, {
		~pitch_b.get({ arg hz;
			hz.postln;
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
				~pm[idx].set(\amplag, 6.0 + 1.0.rand);
				~pm[idx].set(\amp, 0.0);
			}, { 
				~pm[idx].set(\amplag, 0.01 + 0.1.rand);
				~pm[idx].set(\amp, 0.2);
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
	~vinp.set(\amp, val);
};

~setvochdel = { arg idx; 
	//	postln("vohcdel" ++ idx);
	if(idx > 0, {
		~voch1.get(\delaytime, { arg val;
			~voch1.set(\delaytime, val * ~vochdelr);
		});
		~voch2.get(\delaytime, { arg val;
			~voch2.set(\delaytime, val * ~vochdelr);
		});
	}, {
		~voch1.get(\delaytime, { arg val;
			~voch1.set(\delaytime, val / ~vochdelr);
		});
		~voch2.get(\delaytime, { arg val;
			~voch2.set(\delaytime, val / ~vochdelr);
		});
	});
};


~setvochshift = { arg idx; 
	if(idx > 0, {
		~voch1.get(\shift, { arg val;
			postln("voch1shift: " ++ val);
			~voch1.set(\shift, val * ~vochr1);
		});
		~voch2.get(\shift, { arg val;
			postln("voch2shift: " ++ val);
			~voch2.set(\shift, val * ~vochr2);
		});
	}, {
		~voch1.get(\shift, { arg val;
			postln("voch1shift: " ++ val);
			~voch1.set(\shift, val / ~vochr1);
		});
		~voch2.get(\shift, { arg val;
			postln("voch2shift: " ++ val);
			~voch2.set(\shift, val / ~vochr2);
		});
	});
};

~handleKey= { arg ch, val;
	ch.postln;
	ch.switch(
		$1, { ~sethz.value(0, \hz1, val); },
		$2, { ~sethz.value(1, \hz1, val); },
		$3, { ~sethz.value(2, \hz1, val); },
		$4, { ~sethz.value(3, \hz1, val); },

		$5, { ~sethzlag.value(0, val); },
		$6, { ~sethzlag.value(1, val); },
		$7, { ~sethzlag.value(2, val); },
		$8, { ~sethzlag.value(3, val); },

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
		
		$[, { ~setvochshift.value(0); },
		$], { ~setvochshift.value(1); },

		$;, { ~setvochdel.value(0); },
		$', { ~setvochdel.value(1); },

		$\\, { 4.do({ arg i; ~setamp.value(i, 0); }); }
			
	);
};

