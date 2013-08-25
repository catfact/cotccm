//~touchosc_port = 9000;
NetAddr.langPort.postln;
OSCFunc.trace(true);
OSCFunc.trace(false);


~which_xy12 = 2;

~touchosc_radio_xy12 = Array.fill(8, { |i|
	OSCFunc( {
		~set_xy12.value(i);
	}, '/1/multitoggle1/' ++ (i+1).asSymbol ++ '/1');

});


~set_xy12 = { |i| 
	postln(" set echo focus: " ++ i);
	~which_xy12 = i;
};

~touchosc_xy1 = OSCFunc( {
	|msg, time, addr, recvPort|
	var hz, res;
	hz = msg[1].linlin(0, 1, 10, 120).midicps;
	res = msg[2].linlin(0, 1, 0.001, 0.6);
	postln("setting [hz, res] of echo " ++ ~which_xy12 ++ " : " ++ [hz, res]);
	~echo_s[~which_xy12].set(\svf_hz, hz);
	~echo_s[~which_xy12].set(\svf_res, res);
}, '/1/xy1');
//~touchosc_xy1.free;


~touchosc_xy2 = OSCFunc( {
	|msg, time, addr, recvPort|
	var fb, svf_mix;
	fb = msg[1];
	svf_mix = msg[2];
	postln("setting [fb, svf_mix] of echo " ++ ~which_xy12 ++ " : " ++ [fb, svf_mix]);
	~echo_s[~which_xy12].set(\fb, fb);
	~echo_s[~which_xy12].set(\svf_mix, svf_mix);
}, '/1/xy2');

//~touchosc_xy2.free;
