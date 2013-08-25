~echo_set_time = { arg i, t;
	postln("\setting echo " ++ i ++ " time : " ++ t);
	//	Routine {
	~echo_s[i].set(\time, t);
		// }.play;
};

~echo_set_amp = { arg i, v;
	postln("\setting echo " ++ i ++ " amp : " ++ v);
	~echo_s[i].set(\amp, v);
};