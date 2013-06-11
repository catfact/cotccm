q = { WhiteNoise.ar.dup * -30.dbamp }.play;
q.free;

~swp.value(110 * 2/3 * 64, 160);
~swp.value(30, 32);

~flt.set(\rq, 0.03);
~flt.set(\rq, 0.05);

~flt.set(\amp, -60.dbamp);
~flt.set(\amplag, 60.0);
~flt.set(\amp, 1.0);
~flt.set(\amp,  0.0);


s.prepareRecording
s.record;
s.stopRecording;

~fltlplrate.post



s.quit;

s.options.numAudioBusChannels = 512;
s.boot;