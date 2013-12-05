s.prepareForRecord;
s.record;
s.stopRecording;

~norm_buf.plot;

~vla_del_out_s.run(true);
~vla_del_out_s.run(false);

~bufbass.set(\lpfhz, 57.midicps);
~bufbass.set(\ringhz, 57.midicps / 2);
~bufbass.set(\ringdecay, 0.019);
~bufbass.set(\envattack, 0.45);
~bufbass.set(\envdecay, 4.0 * 1.2);
~bufbass.set(\amp, -16.dbamp);
~bufbass.set(\rate, 0.5);
~bufsh.set(\amp, -16.dbamp);
//~bufsh.set(\amp, 0.0);
//~bufsh.set(\pulsehz, 1.2 / 11); 
~bufsh.set(\pulsehz, 1.2 / 22); 
~bufsh.set(\envattack, 4.0 * 1.2);
~bufsh.set(\envdecay, 8.0 * 1.2);
~bufsh.set( \hpfhz, 100);
~bufsh.set( \ringhz, 57.midicps * 2);
~bufsh.set( \ringdecay, 0.01);


~bufsh.run(false);
~bufsh.run(true);




~vla_delt = 15.216253995895;
~vla_delt / (7 * 3)


~bufsh2= Synth.new(\buf_ringz_dist_hpf_env, [
	\buf, ~norm_buf.bufnum,
	\pulsehz, 1.2 / 44.0, 
	\hpfhz, 57.midicps,
	\ringhz, 69.midicps,
	\rate, 1.0,
	\startpos, 4.0,
	\ringdecay, 0.01,
	\envattack, 2.0 * 1.2,
	\envdecay, 2.0 * 1.2,
	\out, ~rhythm_out_b.index,
	\amp, -30.dbamp
], ~rhythm_g);
//		~bufsh.set(\amp, -44.dbamp);



~rhythm_g
~bufbass.run(false);
~bufbass.run(true);

~beet_r.stop;
~beet_r.play;


60 / 50


60 / 120
60 / 240


60 / bpm = 1.2
bpm * 1.2 = 60
bpm = 60 / 1.2
60 / 1.2

~sine = { SinOsc.ar(57.midicps).dup * -22.dbamp }.play;
~sine.free;

~rec_norm_s.free;

~vla_del_grain1.free;
~vla_del_grain2.free;
~vla_del_grain3.free;
~vla_del_grain4.free;
~vla_del_grain5.free;
~vla_del_grain6.free;




~io = {
	Out.ar(0, SoundIn.ar(1).dup)
}.play;


~io.free;
