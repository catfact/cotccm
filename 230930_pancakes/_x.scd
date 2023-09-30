~dur = 33.333;
~buf = Buffer.alloc(s, ~dur * s.sampleRate);


~noteon = { arg uid, chan, num, val;
	["noteon", uid, chan, num, val].postln;
};


~noteoff = { arg uid, chan, num, vel;
	["noteoff", uid, chan, num, vel].postln;
};

MIDIClient.init;
MIDIIn.connectAll;
MIDIIn.clear;
MIDIIn.addFuncTo(\noteOn, { arg uid, chan, num, vel;
	~noteon.value(uid, chan, num, vel);
});
MIDIIn.addFuncTo(\noteOff, { arg uid, chan, num, vel;
	~noteoff.value(uid, chan, num, vel);
});

~pitch_b = Bus.control(s, 2);
~pitch_s = { Out.kr(~pitch_b, Pitch.kr(SoundIn.ar(\in.kr(0)))) }.play(s);

~pitch_poll_tick = 0.2;
~pitch_poll_fn = {
	var hz = ~pitch_b.get({arg val; val.postln; });
}
~pitch_poll = Routine { inf.do {
	~pitch_poll_fn.value;
	~pitch_poll_tick.wait;
} }.play;