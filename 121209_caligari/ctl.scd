~sethz = { arg idx, param;
	~pitch_b.get({ arg hz;
		hz.postln;
		~pm[idx].set(param, hz) });
};

~setamp = { arg idx, param;
	~amp_b.get({ arg amp; 
		amp.postln;
		~pm[idx].set(\amp, amp) });
};

~setpm12 = { arg idx, param;
	~flat_b.get({ arg flat; 
		flat.postln;
		~pm[idx].set(\pm12, flat) });
};

~pmup = { arg idx, lag;
	~pm[idx].set(\pm12lag, lag + 0.06.rand;);
	~pm[idx].set(\pm23lag, lag + 0.07.rand;);
	~pm[idx].set(\pm31lag, lag + 0.8.rand;);
	~pm[idx].set(\pm12, 0.6 + 1.rand);
	//	~pm[idx].set(\pm23, 0.6 + 1.rand);
	//	~pm[idx].set(\pm31, 0.6 + 1.rand);
};

~pmdn = { arg idx, lag;
	~pm[idx].set(\pm12lag, lag + 0.04.rand;);
	~pm[idx].set(\pm23lag, lag + 0.06.rand;);
	~pm[idx].set(\pm31lag, lag + 0.5.rand;);
	~pm[idx].set(\pm12, 0.0);
	~pm[idx].set(\pm23, 0.0);
	~pm[idx].set(\pm31, 0.0);
};

~voch_amp = { arg val;
	~vinp.set(\amp, val);
};

w = Window.new;
w.view.background = Color.black;

w.view.keyDownAction = { 
	arg v, ch;
	~handleKey.value(ch, 1);
};

w.view.keyUpAction = { 
	arg v, ch;
	~handleKey.value(ch, 0);
};

~handleKey= { arg ch, val;
	//	ch.postln;
	ch.switch(
		$1, { ~sethz.value(0, \hz1); },
		$2, { ~sethz.value(1, \hz1); },
		$3, { ~sethz.value(2, \hz1); },
		$4, { ~sethz.value(3, \hz1); },

		$q, { ~sethz.value(0, \hz2); },
		$w, { ~sethz.value(1, \hz2); },
		$e, { ~sethz.value(2, \hz2); },
		$r, { ~sethz.value(3, \hz2); },

		$a, { ~sethz.value(0, \hz3); },
		$s, { ~sethz.value(1, \hz3); },
		$d, { ~sethz.value(2, \hz3); },
		$f, { ~sethz.value(3, \hz3); },

		$z, { ~setamp.value(0); },
		$x, { ~setamp.value(1); },
		$c, { ~setamp.value(2); },
		$v, { ~setamp.value(3); },

		$k, { ~pmdn.value(0, 0.1625 ); },
		$l, { ~pmdn.value(1, 0.1625 ); },
		$;, { ~pmdn.value(2, 0.1625 ); },
		$', { ~pmdn.value(3, 0.1625 ); },

		$m, { ~pmup.value(0, 0.1 + 0.7.rand ); },
		$,, { ~pmup.value(1, 0.1 + 0.7.rand ); },
		$., { ~pmup.value(2, 0.1 + 0.7.rand ); },
		$/, { ~pmup.value(3, 0.1 + 0.7.rand ); },

		$-, { ~voch_amp.value(0.0); },
		$=, { ~voch_amp.value(1.0); }
	);
};




w.front;
/*
w.fullScreen;
*/