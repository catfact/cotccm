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
			if(col < 4, {
				~wlidxbits[col] = 1 - (~wlidxbits[col]);
				~wlidxbits.postln;
				~wlidx = ~sumbits.value(~wlidxbits).min(~weights_l.size - 1);
				~canvas.layers[0].model.weights_l = ~weights_l[~wlidx];
				~wlidx.postln;
				~monome.led(col, row, ~wlidxbits[col]);
			}, {
				~wridxbits[col-4] = 1 - (~wridxbits[col-4]);
								~wridxbits.postln;
				~wridx = ~sumbits.value(~wridxbits).min(~weights_r.size - 1);
				~canvas.layers[0].model.weights_r = ~weights_r[~wridx];
				~monome.led(col, row, ~wridxbits[col-4]);
				~wridx.postln;
			});
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