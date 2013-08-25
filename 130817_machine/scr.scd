~echo_s[0].set(\time_lag, 3);
~echo_s[0].set(\fb, 1.0);
~echo_s[0].set(\time, 300);
~echo_s[0].set(\amp, 0.5);

~echo_s[1].set(\time_lag, 2);
~echo_s[1].set(\fb, 0.7);
~echo_s[1].set(\time, 20);

~echo_s[2].set(\time_lag, 30);
~echo_s[2].set(\fb, 0.5);
~echo_s[2].set(\time, 0.5);

~echo_s[3].set(\time_lag, 10);
~echo_s[3].set(\fb, 0.9);
~echo_s[3].set(\time, 0.125);




~echo_s.do({ arg syn; 
	syn.set(\amp_lag, 5);
	//		syn.set(\amp, 0.1);
 });

~echo_s.do({ arg syn; syn.run(true); });


~echo_s.do({ arg syn; syn.set(\amp, 0.125);  });

~echo_s[0].run(true);




~echo_s[0].set(\time_lag, 30);
~echo_s[1].set(\time_lag, 30);
~echo_s[2].set(\time_lag, 30);
~echo_s[3].set(\time_lag, 30);
~echo_s[4].set(\time_lag, 30);
~echo_s[5].set(\time_lag, 30);
~echo_s[6].set(\time_lag, 30);
~echo_s[7].set(\time_lag, 30);