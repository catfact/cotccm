
//---- recxord
~tw[0].record(0).set(\median, 12);
~tw[1].record(1).set(\median, 12);

~tracks.add(~tw[0].play.set(\ratio, 0.5, \rate, 0.125, \out, ~dum_b.index).set(\ampscale, 1.0).moveToTail(~trackg));

~tracks.add(~tw[0].play.set(\ratio, 0.5 * 6/5, \rate, 0.12, \out,  ~dum_b.index).set(\ampscale, 1.0).moveToTail(~trackg));

~tracks.add(~tw[0].play.set(\ratio, 0.25, \rate, 0.135, \out,  ~dum_b.index).moveToTail(~trackg));
~tracks.add(~tw[0].play.set(\ratio, 0.25 * 3/2, \rate, 0.15, \out,  ~dum_b.index).moveToTail(~trackg));


~tracks.add(~tw[1].play.set(\ratio, 0.25, \rate, 0.25, \out,  ~dum_b.index).moveToTail(~trackg));
~tracks.add(~tw[1].play.set(\ratio, 0.5, \rate, 0.3, \out,  ~dum_b.index).moveToTail(~trackg));


~tracks.add(~tw[0].play.set(\ratio, 1.0, \rate, 0.15, \out,  ~dum_b.index).set(\ratio, 0.5 * 6/5).moveToTail(~trackg));

~tracks.add(~tw[0].play.set(\ratio, 1.0, \rate, 0.16, \out,  ~dum_b.index).set(\ampscale, 0.25).moveToTail(~trackg));

~tracks.do({arg s, i; s.set(\out, i % 2, \ampscale, 1.0, \amp, 0.125); });

~domod.value(~tracks[0]);
~domod.value(~tracks[1]);

~domod.value(~tracks[2]);
~domod.value(~tracks[3], pan: 0.5, a: 3.79);
~domod.value(~tracks[2], pan: 0.75, a: 3.76, hz:3.0);
~domod.value(~tracks[4]);
~domod.value(~tracks[5]);


~modg.set(\hz, 0.2);

~tracks.do({ arg syn; syn.set(\amp, 0.0); });