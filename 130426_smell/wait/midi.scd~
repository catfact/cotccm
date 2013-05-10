//MIDIClient.init;
// MIDIClient.sources.postln;

/*
	NoteOnResponder.removeAll;
	BendResponder.removeAll;
*/

~noteon_post_r = NoteOnResponder({ arg src, chan, num, vel; ["on:",src,chan,num,vel].postln; }, nil, nil, nil, nil);
~noteoff_post_r = NoteOffResponder({ arg src, chan, num, vel; ["off",src,chan,num,vel].postln; }, nil, nil, nil, nil);
~cc_post_r = CCResponder({ arg src, chan, num, val; ["cc",src,chan,num,val].postln; }, nil, nil, nil, nil);
~bend_post_r = BendResponder({ arg src, chan, val; ["bend",src,chan,val].postln; }, nil, nil, nil);

~noteon_metro_r = NoteOnResponder({ |src,chan,note,vel|
	~metro_event.value; 
},
	nil, // any source
	nil, // any channel
	82, // Bb6
	nil // any vel
);

~cc_vlamp_r = CCResponder({ arg src, chan, num, val;
	~vlamp = val.linlin(0, 127, -60, 0).dbamp;
},
	nil,
	nil,
	1,
	nil
);

///////////// echo 1
~noteon_echo1_r =  NoteOnResponder({ |src,chan,note,vel|
		postln("echo 1 on");
	~voch_s[0].set(\feedback, 1.0);
	~voch_s[1].set(\amp, 0.6);
},
	nil, // any source
	nil, // any channel
	83, // B6
	nil // any vel
);

~noteoff_echo1_r =  NoteOffResponder({ |src,chan,note,vel|
	postln("echo 2 off");
	~voch_s[0].set(\feedback, -30.dbamp);
	~voch_s[1].set(\amp, 0.0);
},
	nil, // any source
	nil, // any channel
	83, // B6
	nil // any vel
);

//////
///////// echo 2
~noteon_echo2_r =  NoteOnResponder({ |src,chan,note,vel|
	postln("echo 2 on");
	Routine {
		~voch_s[0].set(\feedback, 1.0);
		~voch_s[1].set(\amp, 0.6);
		~voch_s[2].set(\amplag, 4.0);
		~voch_s[3].set(\amplag, 4.0);
		s.sync;
		~voch_s[2].set(\amp, 1.0);
		~voch_s[3].set(\amp, 1.0);
	}.play;
},
nil, // any source
nil, // any channel
84, // C7
nil // any vel
);

~noteoff_echo2_r =  NoteOffResponder({ |src,chan,note,vel|
	postln("echo 2 off");
Routine {
	~voch_s[0].set(\feedback, -30.dbamp);
	~voch_s[1].set(\amp, 0.0);
	~voch_s[2].set(\amplag, 0.0625);
	~voch_s[3].set(\amplag, 0.0625);
	s.sync;
	~voch_s[2].set(\amp, 0.0);
	~voch_s[3].set(\amp, 0.0);
}.play;
},
nil, // any source
nil, // any channel
84, // C7
nil // any vel
);



/*
~noteon_echo2_r.remove;
~noteoff_echo2_r.remove;
*/