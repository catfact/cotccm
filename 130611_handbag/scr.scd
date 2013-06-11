q = { WhiteNoise.ar.dup * -30.dbamp }.play;
q.free;

~fltg.set(\amplag, 10.0);
~fltg.set(\amp, -22.dbamp);

~swp.value(0, 110 * 2/3 * 3, 60);
~swp.value(1, 110 * 2/3 * 4/3, 120);
//~swp.value(30, 32);

~fltg.set(\rq, 0.03);
~flt[1].set(\rq, 0.04);

~voch_s.do({ arg syn; syn.set(\amp, 0.825); });
~voch_s[0].set(\delaytime, 0.2);

~fltg.set(\amp, -40.dbamp);

~ar = 0.25;
~at = 60.0;
~anapop.value(0.5, 60);

~fltrin = 1;

~beet_rbase = 1/16;
~beet_rbase = 1/4;

~fltg.set(\amp, 1.0);
~fltg.set(\amp,  0.0);


~maxio = 1.0;
~minio = 0.5;



s.prepareRecording
s.record;
s.stopRecording;

~fltlplrate.post


~voch_s.do({ arg syn; syn.set(\amp, 0.825); });



s.quit;

s.options.numAudioBusChannels = 512;
s.boot;

~fltr_buf.plot;