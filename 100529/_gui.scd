// gui
Routine {
	~win = SCWindow.new;
	~win.view.keyDownAction = {
		arg view, char, unicode, keycode; 
		var which = nil;
		which = char.switch(
		// top row: fft freeze
	//			$~, 0,
			$1, 1,
			$2, 2,
			$3, 3,
			$4, 4,
			$5, 5,
			$6, 6,
			$7, 7,
			$8, 8,
	//			$9, 9,
	//			$10, 10,
	//			$-, 11,
	//			$=, 12
		// bottom row: crawls
			$z, 13, 
			$x, 14, 
			$c, 15, 
			$v, 16, 
			$b, 17, 
			$n, 18, 
			$m, 19, 
			$,, 20,
	//			$., 21, 
	//			$., 22,
		// 2nd-to-bottom row: low crawls
			$a, 23,
			$s, 24,
			$d, 25,
			$f, 26,
			$g, 27,
			$h, 28,
			$j, 29,
			$k, 30
	//			$l, 31,
	//			$;, 32,
	//			$', 33,		
		);
		postln(which);
		if(which.notNil, {
			if(which.inRange(13, 20), {
				~crawls_bottom[which-13].startRecording;	
			});
			if(which.inRange(23, 30), {
				~crawls_top[which-23].startRecording;	
			});
			
			//~snapshot.value(which);
		});
	};
	~win.view.keyUpAction = {
		arg view, char, unicode, keycode; 
		var which = nil;
		which = char.switch(
		// top row: fft freeze
	//			$~, 0,
			$1, 1,
			$2, 2,
			$3, 3,
			$4, 4,
			$5, 5,
			$6, 6,
			$7, 7,
			$8, 8,
	//			$9, 9,
	//			$10, 10,
	//			$-, 11,
	//			$=, 12
		// bottom row: crawls
			$z, 13, 
			$x, 14, 
			$c, 15, 
			$v, 16, 
			$b, 17, 
			$n, 18, 
			$m, 19, 
			$,, 20,
	//			$., 21, 
	//			$., 22,
		// 2nd-to-bottom row: low crawls
			$a, 23,
			$s, 24,
			$d, 25,
			$f, 26,
			$g, 27,
			$h, 28,
			$j, 29,
			$k, 30
	//			$l, 31,
	//			$;, 32,
	//			$', 33,		
		);
		postln(which);
		if(which.notNil, {
			if(which.inRange(13, 20), {
				~crawls_bottom[which-13].stopRecording;	
			});
			if(which.inRange(23, 30), {
				~crawls_top[which-23].stopRecording;	
			});
			//~snapshot.value(which);
		});
	};
	
	~win.front;
}.play(AppClock);