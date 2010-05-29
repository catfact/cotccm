CCResponder.removeAll;
NoteOnResponder.removeAll;
NoteOffResponder.removeAll;
BendResponder.removeAll;
TouchResponder.removeAll;

~pedal_func = {arg val; postln("pedal :" ++ val); };
~bend_func = {arg val; postln("bend :" ++ val); };
~mod_func = {arg val; postln("mod :" ++ val); };
~noteon_func = {arg num, vel; postln("noteon :" ++ num ++ " , " ++ vel); };
~noteoff_func = {arg num, vel; postln("noteoff :" ++ num ++ " , " ++ vel); };

~pedal_r = CCResponder({arg src, chan, num, val; ~pedal_func.value(val); }, nil, nil, 64);
~bend_r = BendResponder({arg src, chan, val; ~bend_func.value(val); });
~mod_r = CCResponder({arg src, chan, num, val; ~mod_func.value(val); }, nil, nil, 1);
~noteon_r = NoteOnResponder({arg src, chan, num, vel; ~noteon_func.value(num, vel); }, nil, nil);
~noteoff_r = NoteOffResponder({arg src, chan, num, vel; ~noteoff_func.value(num, vel); }, nil, nil);

~pedal_func = { arg val;
	if (val > 0, {
		postln("vla remains on");
		~vla_remains.setamp(-8.dbamp);
	}, {
		postln("vla remains off");
		~vla_remains.setamp(0.0);
	});
};

~noteon_count = 0;
~noteon_last = 37;
~noteon_func = { arg num, vel;
	if (~noteon_count > 9, {
		~noteon_count = 0;
		~key_remains.echo_s[~key_remains.whichecho].set(\freq, num.midicps * 0.5);
		~key_remains.in_lpf_s.set(\hz, ~noteon_last.midicps);
		~noteon_last = num;
	});
};


~bend_func = { arg val;
	if (val == 8192, {
		postln("key remains off");
		~key_remains.setamp(0.0);
	}, {
		~key_remains.setamp(-8.dbamp);
		postln("key remains on");
	});
};