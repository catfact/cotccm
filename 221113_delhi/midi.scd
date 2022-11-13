MIDIIn.connectAll;

~pedal_func = [

	// record noise
	{
		arg isOn;
		postln("pedal 1: "++isOn);
		if (isOn, {
			~buf[\noise][\start_rec].value;
		}, {
			~buf[\noise][\stop_rec].value;
		});
	},


	// record tone
	{
		arg isOn;
		postln("pedal 2: "++isOn);
				if (isOn, {
			~buf[\tones][\start_rec].value;
		}, {
			~buf[\tones][\stop_rec].value;
		});


	},

	// dowse
	{
		arg isOn;
		postln("pedal 3: "++isOn);
		if (isOn, {
			~dowse[\grab].value({ arg ev; ev.postln; });
		});
	},
];

~midi_noteon_func = MIDIFunc.noteOn({ arg vel, num;
	//	["noteon", num, vel].postln;
	num.switch(
		60, { ~pedal_func[0].value(true) },
		62, { ~pedal_func[1].value(true) },
		64, { ~pedal_func[2].value(true) }
	);
}, nil, nil);

~midi_noteoff_func = MIDIFunc.noteOff({ arg vel, num;
	num.switch(
		60, { ~pedal_func[0].value(false) },
		62, { ~pedal_func[1].value(false) },
		64, { ~pedal_func[2].value(false) }
	);
}, nil, nil);

