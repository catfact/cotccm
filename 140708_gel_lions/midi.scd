MIDIClient.init;

MIDIClient.sources.do({ arg src, num; 
	MIDIIn.connect(num, src);
	postln("source " ++ num ++ " ; " ++ src);
});


~noteon_post_r = NoteOnResponder({ |src, ch, num, vel|
	postln(" note on  : " ++ num);
});


~noteoff_post_r = NoteOffResponder({ |src, ch, num, vel|
	postln(" note off : " ++ num);
});



