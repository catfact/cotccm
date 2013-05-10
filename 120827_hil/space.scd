~jl_start_record.value(0);
~jl_stop_record.value(0);

~jl_play_s[0].set(\rate, 0.5);
~jl_play_s[0].set(\rate, -8/9);
~jl_play_s[0].set(\level, 1.0);
~jl_play_s[0].set(\shift_ratio, 14/8);
~jl_play_s[0].set(\shift_amplag, 60.0);
~jl_play_s[0].set(\shift_amp, 0.0);
~jl_play_s[0].set(\level, 1.0);

~jl_start_record.value(1);
~jl_stop_record.value(1);

~jl_play_s[1].set(\rate, 1/3);
~jl_play_s[1].set(\shift_ratio, 2.0);
~jl_play_s[1].set(\shift_amplag, 60.0);
~jl_play_s[1].set(\shift_amp, 1.0);
~jl_play_s[1].set(\level, 1.0);


~jl_start_record.value(2);
~jl_stop_record.value(2);

~jl_play_s[2].set(\rate, 4/10);
~jl_play_s[2].set(\shift_ratio, 6);
~jl_play_s[2].set(\shift_amplag, 60.0);
~jl_play_s[2].set(\shift_amp, 1.0);
~jl_play_s[2].set(\level, 1.3);

~jl_clear.value(1);

~setcol.value(Color.new(0.5, 0.0, 0.0), 100, 0.01, 0.5); 
~setcol.value(Color., 100, 0.05, 0.5); 


~jl_play_s[0].free;

~jl_clear.value(0);




~jl_start_record.value(3);
~jl_stop_record.value(3);


~jl_play_s[3].set(\level, -12.dbamp);
~jl_play_s[3].set(\rate, -1/8);

~jl_start_record.value(4);
~jl_stop_record.value(4);

~jl_play_s[4].set(\level, -28.dbamp);
~jl_play_s[4].set(\rate, -1/3);

~jl_play_s[0].set(\rel, 60.0);
~jl_play_s[1].set(\rel, 60.0);
~jl_play_s[0].set(\gate, 0);
~jl_play_s[1].set(\gate, 0);

~jl_clear.value(0);
~jl_clear.value(1);

~jl_start_record.value(0);
~jl_start_record.value(1);

~jl_start_record.value(5);
~jl_start_record.value(6);
~jl_start_record.value(7);

~jl_stop_record.value(5);
~jl_stop_record.value(6);
~jl_stop_record.value(7);


~jl_play_s[5].set(\level, -18.dbamp);
~jl_play_s[6].set(\level, -18.dbamp);
~jl_play_s[7].set(\level, -8.dbamp);



~jl_play_s[6].set(\rate, 5/8);
~jl_play_s[7].set(\rate, -1/4);
~jl_play_s[7].set(\shift_ratio, 3);
~jl_play_s[7].set(\shift_amplag, 100.0);
~jl_play_s[7].set(\shift_amp, 1.0);


~jl_bufs[6].plot

~cf = 0;

~col2 = Color.black;

~qr.stop;

~qr = Routine { inf.do {

	if(~cf==0, {
		if(0.08.coin, {
			~cf = 1;
			{
				v.layers[0].color = ~col2;
				v.window.refresh;
			}.defer;
		});
	}, {
		{
			~cf = 0;
			v.layers[0].color = ~col;
			v.window.refresh;
		}.defer;
	});
	0.1.wait;
} }.play;