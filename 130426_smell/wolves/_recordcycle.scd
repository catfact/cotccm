Routine {
		8.do({ arg i;
			~jl_start_record.value(i);
			//			~row.value(5, 0x80 >> i)
			//			~row.value(5, 1 << x);
			//			~notify.value(i.asString, Color.red);
			16.wait;
			~jl_stop_record.value(i);
			~row.value(5,0);
			~jl_bufs[i].normalize(0.25);
			~notify.value(i.asString, Color.black);
			4.wait;
		});

		8.do({ arg i;
			~jl_start_record.value(i);
	
			//			~row.value(5, 1 << i);

			~notify.value(i.asString, Color.red);
			16.wait;
			~jl_stop_record.value(i);
			~row.value(5,0);
			~jl_bufs[i].normalize(0.25);
			~notify.value(i.asString, Color.black);
			4.wait;
		});
	


}.play;