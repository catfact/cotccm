/*
~wobs[0].set(\wob_rate, 1/128);
~wobs[1].set(\wob_rate, 15/2048);
~wobs[2].set(\wob_rate, 1.25/256);
~wobs[3].set(\wob_rate, 17/4096);
*/

Routine {

	~wob_mul_s = { arg x=1.0, t=8.0; Out.kr(~wob_rate_mul_bus, Ramp.kr(x, t)); }.play(~ig);
	~wob_amp_s = { arg x=1.0, t=8.0; Out.kr(~wob_amp_mix_bus, Ramp.kr(x, t)); }.play(~ig);
	~wob_lpf_s = { arg x=0.0, t=8.0; Out.kr(~wob_lpf_mix_bus, Ramp.kr(x, t)); }.play(~ig);

	s.sync;

	~wob_lpf_s.set(\x, 0.5);
	~wob_amp_s.set(\x, 0.5);

	64.wait;

	~wob_mul_s.set(\t, 256.0);
	~wob_mul_s.set(\x, 1/4);


}.play;