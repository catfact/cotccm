// gui
Routine {
	~win = SCWindow.new("___", SCWindow.screenBounds, border:false);
//	~win = SCWindow.new;
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
			$k, 30,
	//			$l, 31,
	//			$;, 32,
	//			$', 33,		
		// 2nd row: freeze toggles
			$q, 34,
			$w, 35,
			$e, 36,
			$r, 37,
			$t, 38,
			$y, 39,
			$u, 40,	
			$i, 41	
		);
		postln(which);
		if(which.notNil, {
			if(which.inRange(1, 8), {
				~snapshot.value(which-1);
			});
			if(which.inRange(13, 20), {
				~crawl_bottom[which-13].startRecording;
				~crawl_bottom_alpha[which-13] = 1.0;	
			});
			if(which.inRange(23, 30), {
				~crawl_top[which-23].startRecording;	
				~crawl_top_alpha[which-23] = 1.0;
			});
			if(which.inRange(34, 41), {
				~freezetaps[which-34].tap;
			});
		});
	};
	
//============= key up
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
			$k, 30,
	//			$l, 31,
	//			$;, 32,
	//			$', 33,		
		// 2nd row: freeze toggles
			$q, 34,
			$w, 35,
			$e, 36,
			$r, 37,
			$t, 38,
			$y, 39,
			$u, 40,	
			$i, 41	
		);
		postln(which);
		if(which.notNil, {
			if(which.inRange(34, 41), {
				~freezetaps[which-34].tap;
				~amplag[which-34] = ~freezetaps[which-34].time;
				if (~amp[which-34] < 0.0001, {~amp[which-34] = -4.dbamp}, {~amp[which-34] = 0.0});
				~freezer_s.set(\amplag, ~amplag);
				~freezer_s.set(\amp, ~amp);
			});
			if(which.inRange(1, 8), {
//				~snapshot.value(which-1);
				
			});
			if(which.inRange(13, 20), {
				var dur = ~crawl_bottom[which-13].stopRecording;
				~crawl_bottom_alpha_delta[which-13] = -0.9 / dur;
			});
			if(which.inRange(23, 30), {
				var dur = ~crawl_top[which-23].stopRecording;				~crawl_top_alpha_delta[which-23] = -0.9 / dur;
			});
		});
	};
	
	~crawl_bottom_alpha = Array.fill(8, {0.0});
	~crawl_top_alpha = Array.fill(8, {0.0});
	
	~crawl_bottom_alpha_delta = Array.fill(8, {0.0});
	~crawl_top_alpha_delta = Array.fill(8, {0.0});
	
	
	~win.drawHook = {
		~crawl_bottom_alpha.do({ arg alpha, i;
			Pen.color = Color.blue(1.0, alpha);
			Pen.addRect(Rect(i*(~win.bounds.width - 600 / (~crawl_bottom_alpha.size - 1)), ~win.bounds.height - 600, 600, 600));
			Pen.perform(\fill);
		});
		
		~crawl_top_alpha.do({ arg alpha, i;
			Pen.color = Color.blue(1.0, alpha);
			Pen.addRect(Rect(i*(~win.bounds.width - 600 / (~crawl_top_alpha.size - 1)), 0, 600, 600));
			Pen.perform(\fill);
		});
		~amp.do({ arg amp, i;
			Pen.color = Color.red(0.5, amp*0.5);
			Pen.addRect(Rect(i*(~win.bounds.width - 100 / (~amp.size - 1)), ~win.bounds.height*0.5 - 50, 100, 100));
			Pen.perform(\fill);
		});
		(""++Date.localtime++"").drawCenteredIn(Rect(0, 0, 200, 40), Font("Arial", 19), Color.white);
	};
	
	~refresh = Routine {inf.do({
		~crawl_bottom_alpha.do({ arg alpha, i;
			~crawl_bottom_alpha[i] = (~crawl_bottom_alpha[i] + (~crawl_bottom_alpha_delta[i]* 0.5));
			if (~crawl_bottom_alpha[i] < 0.0, {
				~crawl_bottom_alpha[i] = 0.0;
				~crawl_bottom_alpha_delta[i] = 0.0;
			});
		});
		~crawl_top_alpha.do({ arg alpha, i;
			~crawl_top_alpha[i] = (~crawl_top_alpha[i] + (~crawl_top_alpha_delta[i]* 0.5));
			if (~crawl_top_alpha[i] < 0.0, {
				~crawl_top_alpha[i] = 0.0;
				~crawl_top_alpha_delta[i] = 0.0;
			});
			
		});
		~win.refresh;
		0.5.wait;
	}); }.play(AppClock);
	
	~win.onClose = { ~refresh.stop; };
	
	~win.view.background = Color.black;
	
//	~win.fullScreen;

	~win.front;
}.play(AppClock);