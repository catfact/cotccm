~gui.value("gather pitches", Color.new(0.3, 1.0, 0.1));

~gpitchbus = Bus.control(s, 1);

// histogram dictionary of pitches:
// integer->[float, float,...]
~gpitchgrid = Dictionary.new; 
128.do({|i|~gpitchgrid.add(i->List.new)});


~gpitchduty = 0.25;

~gpitchiter = Task({inf.do({
~gpitchbus.get({arg val;
	if (val < 800, {
		~gpitchgrid[val.cpsmidi.round(1)].add(val);
	});
});
~gpitchduty.wait
})}); // end pitchgathering task

~gpsyn = Synth.new('vPitch_1_1',
[\in, 1, \out, ~gpitchbus.index],
s, 'addToTail');
 
~gpitchiter.play;

SystemClock.sched(120,{
~gpitchiter.stop;
~gui.value("gathered", Color.new(0.3, 0.1, 0.1));
nil});   