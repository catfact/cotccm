~frz_rec.value(0, true);
~frz_rec.value(0, false);
~frz_rec.value(1, true);
~frz_rec.value(1, false);
~frz_rec.value(2, true);
~frz_rec.value(2, false);
~frz_rec.value(3, true);
~frz_rec.value(4, false);


////
Routine {  ~jl_start_record.value(0); (~beet_t * 32).wait; ~jl_stop_record.value(0); }.play;
Routine {  ~jl_start_record.value(1); (~beet_t * 24).wait; ~jl_stop_record.value(1); }.play;

~jl_play.value(0);
~jl_play.value(1);

~jl_bufs[0].normalize;

~jl_taps[0].time;

