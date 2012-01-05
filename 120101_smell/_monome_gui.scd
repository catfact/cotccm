// gui
 Routine {
	~monome = Cf40h.new;
	0.1.wait;
	~monome.clear;
	
	~monome.pressFunctions.add('top4'->{
		arg col, row;

		if(row == 0, {
			~snapshot.value(col);
			~monome.led(col, row, 1);
		});
		
		if(row == 1, {
			~freezetaps[col].tap;
		});
		if(row == 2, {
			~crawl_bottom[col].startRecording;	
		});
		if(row == 3, {
			~crawl_top[col].startRecording;
		});
	});
	
	~monome.liftFunctions.add('top4'->{
		arg col, row;
		
		if(row == 0, {
			~monome.led(col, row, 0);
		});
		
		if(row == 1, {
			~freezetaps[col].tap;
			~amplag[col] = ~freezetaps[col].time;
			if (~amp[col] < 0.0001, {
				~amp[col] = -9.dbamp;
				~monome.led(col, row, 1);
			}, {
				~amp[col] = 0.0;
				~monome.led(col, row, 0);
			});
			~amplag.postln;
			~amp.postln;
			~freezer_s.set(\amplag, ~amplag);
			~freezer_s.set(\amp, ~amp);
		});
		
		if(row == 2, {
			var dur = ~crawl_bottom[col].stopRecording;
			~monome.led(col, row, 1);
			AppClock.sched(dur, { ~monome.led(col, row, 0); nil});
		});
		if(row == 3, {
			var dur = ~crawl_top[col].stopRecording;
			~monome.led(col, row, 1);
			AppClock.sched(dur, { ~monome.led(col, row, 0); nil});
		});
		
		// master volume!
		if(row == 4, {
			s.volume_(#[-inf, -32, -24, -12, -9, -8, -6, -2, 0][col]);
			8.do({|i| ~monome.led(i, row, if(i <= col, {1}, {0}) ); });
			
		});
		
		// other effect toggles
		if (row == 5, {
			// liedown toggle
			if(col==0, {
				if(~lie_f, {
					~lie_ft = SystemClock.seconds - ~lie_ft;
					if (~lie_ft > 8.0, {			
						~lie_f = false;
						x.value("__liedown_stop.scd");
						~monome.led(col, row, 0);
					});
				}, {	
					~lie_ft = SystemClock.seconds - ~lie_ft;
					if (~lie_ft > 8.0, {			
						~lie_f = true;
						x.value("__liedown.scd");
						~monome.led(col, row, 1);
					});
				});
			});
		});

	});
	~lie_f = false;
	~lie_ft = SystemClock.seconds;
	
	~monome.press = {};
	~monome.lift = {};
	~monome.pressFunctions.removeAt('default');
	~monome.liftFunctions.removeAt('default');	
	
}.play(AppClock);