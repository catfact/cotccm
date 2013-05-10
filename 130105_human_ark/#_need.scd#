Routine {

~vla_longdel_amp_line.free;
~vox_delt_line.free;
~vox_fb_line.free;

s.sync;

~vla_longdel_amp_line = { Out.kr(~vla_delamp_b.index, Line.kr(1.0, 0.8, 4); ) }.play(s);
	//~vla_longdel.get(\delaytime, { |val| val.postln; });
~vla_longdel.set(\delaytime, 0.0);
~vox_delt_line = { Out.kr(~vox_delt_b.index, Line.kr(0.5, 0.15, 4.0); ) }.play(s); 
~vox_fb_line = { Out.kr(~vox_fb_b.index, Line.kr(0.85, 0.6, 4); ) }.play(s ); 

}.play;