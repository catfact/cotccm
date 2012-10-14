x.value("grains.scd");

/*
~bbuf.plot;
*/

x.value("voxdel.scd");

S.RECORD;
s.record

s.stopRecording

~siner[0].stop;
~siner[1].stop;
~siner[2].stop;
~siner[3].stop;
~siner[4].stop;

~gr[0].gr_s.set(\amp, 0);
~gr[1].gr_s.set(\amp, 0);
~gr[2].gr_s.set(\amp, 0);
~gr[3].gr_s.set(\amp, 0);

