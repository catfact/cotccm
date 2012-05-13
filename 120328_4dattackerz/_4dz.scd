//////// audio

s = Server.local;
c = CfAudioContext.new(s, 2, {
	// patchthrough synths
	~ps = c.in_s.collect({ arg ins, i;
		Synth.new(\pan, [
			\in, c.in_b.index + i, 
			\out, c.out_b.index + i, 
			\amplagup, 0.001,
			\amplagdown, 0.1,
		], c.xg);
	});
	
	// buffers
	b = c.allocBufs(2);
	// delays
	~db= Bus.audio(s, 1);
	~dout = Synth.new(\pan, [\in, ~db.index, \out, c.out_b.index], c.og, \addBefore);
	~ds = b.collect({ arg buf, i;
	//	buf.bufnum.postln;
		Synth.new(\bufdelay_fb, [
			\in, c.in_b.index + i, 
			\out, ~db.index,
			\buf, buf.bufnum,
			\amp, 0.0
		], c.xg);
	});
});


//////// logic

t = [0.0, 0.0];



//////// ui

 ~xw = SCWindow.new("XXXXXXXXXXXXXX", Rect(0, 0, 500, 500)); //SCWindow.screenBounds);
 
 ~xw.view.background = Color.white;
 ~xtxt = SCStaticText(~xw, ~xw.view.bounds);
 ~xtxt.font = Font("Andale Mono", 56);
 
 ~xw.view.keyDownAction = { arg view, char, mod, uni, key;
	 var wha;	 
	 ~xw.view.background = Color.white;

	if(char == $ , {
		~ch_start.value;
	});
	wha = char.switch(
		$q, {0},
		$w, {1},
		$e, {2},
		$r, {3},
		$t, {4},
		$y, {5},
		$u, {6},
		$i, {7},
		$o, {8},
		$p, {9},
		$a, {10},
		$s, {11},
		$d, {12},
		$f, {13},
		$g, {14},
		$h, {15},
		$j, {16},
		$k, {17},
		$l, {18},
		$z, {19},
		$x, {20},
		$c, {21},
		$v, {22},
		$b, {23},
		$n, {24},
		$m, {25}
	);
	
	if (wha.notNil, {
		if (wha<2, {
			~ps[wha].set(\amp, 0.0);
		});	
		if((wha>1) && (wha < 4), {
			postln("HEYDOWN " ++ wha);
//			postln(SystemClock.seconds - t[wha-2]);
			~ds[wha-2].set(\delaytime, SystemClock.seconds - t[wha-2]);
			~ds[wha-2].set(\amp, 1.0);
		});
	});
	
 };

 ~xw.view.keyUpAction = { arg view, char;
	var wha;		 
 	~xw.view.background = Color.black;

	wha = char.switch(
		$q, {0},
		$w, {1},
		$e, {2},
		$r, {3},
		$t, {4},
		$y, {5},
		$u, {6},
		$i, {7},
		$o, {8},
		$p, {9},
		$a, {10},
		$s, {11},
		$d, {12},
		$f, {13},
		$g, {14},
		$h, {15},
		$j, {16},
		$k, {17},
		$l, {18},
		$z, {19},
		$x, {20},
		$c, {21},
		$v, {22},
		$b, {23},
		$n, {24},
		$m, {25}
	);
	
	if (wha.notNil, {
		if (wha<2, {
			~ps[wha].set(\amp, 1.0);
			t[wha] = SystemClock.seconds;
		});	
		if((wha>1) && (wha < 4), {
			postln("HEYUP " ++ wha);
			~ds[wha-2].set(\amp, 0.0);
		});
	});
};

~xw.front;