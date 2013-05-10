
Routine {  ~jl_start_record.value(0); (~beet_t * 32).wait; ~jl_stop_record.value(0); ~jl_play.value(0) }.play;
Routine {  ~jl_start_record.value(1); (~beet_t * 24).wait; ~jl_stop_record.value(1); ~jl_play.value(1)}.play;
Routine {  ~jl_start_record.value(2); (~beet_t * 40).wait; ~jl_stop_record.value(2); ~jl_play.value(2) }.play;
Routine {  ~jl_start_record.value(3); (~beet_t * 42).wait; ~jl_stop_record.value(3); ~jl_play.value(3)}.play;

/*

~jl_clear.value(0);
~jl_clear.value(1);
~jl_clear.value(2);
~jl_clear.value(3);


*/

/*
~frBuf.do({ arg buf; buf.normalize; });

t = 60 / 80;

~bufbass = Synth.new(\buf_ringz_lpf_env, [
	\buf, ~frBuf[0].bufnum,
	\pulsehz, 1.0 / t * 0.25
	\lpfhz, 55.midicps,
	\ringhz, 43.midicps,
	\rate, 0.25,mat
	\ringdecay, 0.007,
	\out, 0.index,
	\amp, 0.dbamp
], c.xg);
~bufbass.set(\amp, -12.dbamp);

*/
//~frBuf[0].plot;