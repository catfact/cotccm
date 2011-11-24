///// OSC :
~sine_g.set(\amp, -24.dbamp);
~saw_g.set(\amp, -30.dbamp);
//// VLA PAN :
~vla_l_pan.set(\pan, -0.9;
~vla_r_pan.set(\pan, -0.6);
////// VLA DIST DEL:
~vla_r_del.set(\time, 0.05);
///// VLA DIST EQ:
~vla_r_lpf.set(\hz, 8000);
~vla_r_lpf.run(false);
~vla_r_lpf.run(true);
~vla_r_hishelf.set(\hz, 1000);
~vla_r_hishelf.set(\db, -8.0);
~vla_r_hishelf.set(\rs, 5);