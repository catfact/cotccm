q = { WhiteNoise.ar.dup * -30.dbamp }.play;
q.free;

~swp.value(0, 110 * 2/3 * 3, 30);
~swp.value(1, 110 * 2/3 * 4/3, 60);

//~swp.value(30, 32);

~fltg.set(\rq, 0.05);
~flt[1].set(\rq, 0.05);

~fltg.set(\amplag, 10.0);
~fltg.set(\amp, -22.dbamp);


~anapop.value(0.5, 60);


~fltg.set(\amp, 1.0);
~fltg.set(\amp,  0.0);




s.prepareRecording
s.record;
s.stopRecording;

~fltlplrate.post


~voch_s.do({ arg syn; syn.set(\amp, 0.125); });



s.quit;

s.options.numAudioBusChannels = 512;
s.boot;