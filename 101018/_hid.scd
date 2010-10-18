

GeneralHID.buildDeviceList;
~hid_dev  = GeneralHID.deviceList;
GeneralHID.postDevices;
		
//~pad = GeneralHID.open( GeneralHID.findBy(1973, 531, 68157440, 257) );
//~pad = GeneralHID.open( GeneralHID.findBy(0x07B5) ); 
~pad = GeneralHID.open( GeneralHID.findBy(1973, 531) );
~pad.debug_( true );
~pad.makeGui;
 
~pad_spec = GeneralHIDSpec.new( ~pad );
~pad_spec.add(\switch, [1, 7]);
~pad_spec.add(\butN, [1, 3]);
~pad_spec.add(\butS, [1, 2]);
~pad_spec.add(\butE, [1, 1]);
~pad_spec.add(\butW, [1, 4]);

~pad_spec.map.postcs;

~pad_spec;

~pad_spec.action_(\switch, {
	arg slot;
	~switch_func.value(slot.value);
});

~pad_spec.action_(\butN, {
	arg slot;
	~butN_func.value(slot.value);
});

~pad_spec.action_(\butS, {
	arg slot;
	~butS_func.value(slot.value);
});

~pad_spec.action_(\butE, {
	arg slot;
	~butE_func.value(slot.value);
});

~pad_spec.action_(\butW, {
	arg slot;
	~butW_func.value(slot.value);
});

GeneralHID.startEventLoop;

~switch_func = { arg val;
	postln("switch " ++ val);
};

~butN_func = { arg val;
	postln("but N " ++ val);
};

~butS_func = { arg val;
	postln("but S " ++ val);
};


~butE_func = { arg val;
	postln("but E " ++ val);
};


~butW_func = { arg val;
	postln("but W " ++ val);
};