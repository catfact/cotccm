

GeneralHID.buildDeviceList;
~hid_dev  = GeneralHID.deviceList;
GeneralHID.postDevices;
		
~pad = GeneralHID.open( GeneralHID.findBy(1973, 531, 68157440, 257) );
~pad.debug_( true );
 
~pad_spec = GeneralHIDSpec.new( ~pad );
~pad_spec.add(\switch, [1, 7]);

~pad_spec.map.postcs;

~pad_spec;

~pad_spec.action_(\switch, { arg slot; postln("poo " ++ slot.value); });

GeneralHID.startEventLoop;

