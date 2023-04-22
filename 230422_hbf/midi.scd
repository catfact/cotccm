
MIDIIn.connectAll;

/// user or subclass should redefine these!
~midi_handler = Dictionary.newFrom([
	\noteon, { arg ... args; (["noteon"] ++ args).postln; },
	\noteoff, { arg ... args; (["noteoff"] ++ args).postln; },
	\cc, { arg ... args; (["cc"] ++ args).postln; },
	\pitchbend, { arg ... args; (["pitchbend"] ++ args).postln; },
]);

~midifunc = Dictionary.newFrom([
	\noteon, MIDIFunc.noteOn({ arg ...args; ~midi_handler[\noteon].value(args)}, nil),
	\noteoff, MIDIFunc.noteOff({ arg ...args; ~midi_handler[\noteoff].value(args)}, nil),
	\cc, MIDIFunc.cc({ arg ...args; ~midi_handler[\cc].value(args)}, nil),
	\pitchbend, MIDIFunc.bend({ arg ...args; ~midi_handler[\pitchbend].value(args)}, nil),
]);