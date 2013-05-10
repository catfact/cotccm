//MIDIClient.init;
// MIDIClient.sources.postln;

/*
	NoteOnResponder.removeAll;
	BendResponder.removeAll;
CCResponder.removeAll;
*/

~section = 0;
~pedal_section_r = CCResponder({ arg src, chan, num, val;
			[val, ~section, ~wasinrange].postln;

		if(val == 127, {			
			if(~section == 0, {
				~section = 1;
				~fuckd_on.value();
				~del_off.value();
			}, {
				~section = 0;
				~fuckd_off.value();
				~del_on.value();
			});
		});
},
	nil,
	nil,
	11,
	nil
);


/*
~cc_section_r.remove; 
~pedal_section_r.remove; 
*/