~recr = Routine {
	4.wait;
		7.do({ arg i;
			~jl_start_record.value(i);
			//			~row.value(5, 0x80 >> i)
			~row.value(5, 1 << i);
			~post.value(i.asString, Color.red);
			24.wait;
			~jl_stop_record.value(i);
			~row.value(5,0);
			~jl_bufs[i].normalize(0.25);
			~post.value(i.asString, Color.black);
			4.wait;
		});
	4.wait;
	x.value("_chordgrains.scd");
	


}.play;

//~recr.stop;