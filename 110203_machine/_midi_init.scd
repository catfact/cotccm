MIDIClient.init(3, 3);
3.do({|i| MIDIIn.connect(i, MIDIClient.sources.at(i)) });

~cc_poster = CCResponder({ |src,chan,num,value|
	[src,chan,num,value].postln;
	},
	nil, // any source
	nil, // any channel
	nil, // any CC number
	nil // any value
);
