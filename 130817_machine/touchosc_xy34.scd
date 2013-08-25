//~touchosc_port = 9000;
NetAddr.langPort.postln;
OSCFunc.trace(true);
OSCFunc.trace(false);


~which_xy34 = 2;

~touchosc_radio_xy34 = Array.fill(8, { |i|
	OSCFunc( {
		~set_xy34.value(i);
	}, '/3/multitoggle1/' ++ (i+1).asSymbol ++ '/1');

});


~set_xy34 = { |i| 
	postln(" set echo focus: " ++ i);
	~which_xy34 = i;
};

/*
~touchosc_xy3 = OSCFunc( {
	|msg, time, addr, recvPort|
	var hz, res;
	hz = msg[1].linlin(0, 1, 10, 120).midicps;
	res = msg[2].linlin(0, 1, 0.001, 0.6);
	postln("setting [hz, res] of echo " ++ ~which_xy34 ++ " : " ++ [hz, res]);
	~echo_s[~which_xy34].set(\svf_hz, hz);
	~echo_s[~which_xy34].set(\svf_res, res);
}, '/3/xy3');
//~touchosc_xy1.free;
*/

~touchosc_xy4 = OSCFunc( {
	|msg, t, addr, recvPort|
	var time, time_lag;
	time = msg[1].linlin(0, 1, 0, 300);
	time_lag = msg[2].linlin(0, 1, 0, 100);
	postln("setting [time, time_lag] of echo " ++ ~which_xy34 ++ " : " ++ [time, time_lag]);
	~echo_s[~which_xy34].set(\time, time);
	~echo_s[~which_xy34].set(\time_lag, time_lag);
}, '/3/xy4');

//~touchosc_xy4.free;