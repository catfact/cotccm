// gui
 Routine {
	~monome = Cf40h.new(host:"127.0.0.1", port:8080, prefix:'/box');
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
				~amp[col] = 0.dbamp;
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
	});
	
	~monome.press = {};
	~monome.lift = {};
	~monome.pressFunctions.removeAt('default');
	~monome.liftFunctions.removeAt('default');	
}.play(AppClock);