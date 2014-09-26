// start
~buffbass.free;
x.value("chop.scd");

// wob
x.value("wob.scd");

// change hz base
~hz_base = ~hz_base * 4/3;


// slow down
~wob_mul_s.set(\t, 256.0);
~wob_mul_s.set(\x, 1/64);

~hz_base = ~hz_base * 3/4 * 4/5;
~hz_base = ~hz_base * 5/4;

// analyze, start sines
x.value("anal.scd");


// grains
x.value("more.scd");
x.value("moremore.scd");



x.value("gui.scd");


// stop chops
~beet_r.stop; ~beet_r2.stop;


//  fade out wobs
~wob_lpf_s.set(\t, 64); ~wob_lpf_s.set(\x, 0.0);
~wob_amp_s.set(\t, 64); ~wob_amp_s.set(\x, 0.0);



// stop sines
~siner.do({ arg rout; rout.stop; });

// re-record grains
~recBuf.value(~bbuf, 0, {});

// fade out grains
~gr.do({ arg gr; gr.gr_s.set(\amp_lag, 256.0); gr.gr_s.set(\amp, 0.0); });
~gr2.do({ arg gr; gr.gr_s.set(\amp_lag, 256.0); gr.gr_s.set(\amp, 0.0); });

~clar_dur = 32;
 ~flat_dur = 32;