x = {arg path; this.executeFile('/Users/e/_svn/cotccm/eyesforears/'++path); }; 

s = Server.local;

s.options.hardwareBufferSize = 128;

s.waitForBoot {

Routine {
// MOTU hardware routing
x.value("_routing.scd");
x.value("_midi.scd");
"routing.\n.".postln;
1.0.wait;

// sample playback
x.value("_sample.scd");
"sample.\n.".postln;

// vla remains...
~vla_remains = CfRemains.new(s);
2.0.wait;
~vla_remains.setinputchannel(~input_map[\fxloop]);
~vla_remains.setamplag(120.0);
~vla_remains.setvoscamp(-16.dbamp);
~vla_remains.amp_thresh = -48.dbamp;
~vla_remains.mintimeunit = 1.5;

"vla remains.\n.".postln;


// key remains...
~key_remains = CfRemains.new(s);
2.0.wait;
~key_remains.setinputchannel(~input_map[\fxloop]);
~key_remains.setamplag(40.0);
~key_remains.setvoscamp(-16.dbamp);
~key_remains.amp_thresh = -48.dbamp;
~key_remains.mintimeunit = 1.5;
~key_remains.in_lpf_s.set(\hzlag, 20.0);
"key remains.\n.".postln;


// vla grains
x.value("__vla_grains_oh.scd");
1.0.wait;

// gui
x.value("_gui.scd");

// remains...

~mirror_0 = Synth.new(\patch_mono, [\in, 0, \out, 8], ~og, \addAfter);
~mirror_1 = Synth.new(\patch_mono, [\in, 1, \out, 8], ~og, \addAfter);

}.play;
};