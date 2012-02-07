

s = Server.default.waitForBoot { Routine {
	~r_buf = Buffer.alloc(s, s.sampleRate * 2.0, 1);
	~ch_buf = Buffer.alloc(s, s.sampleRate * 2.0, 1);
	
	s.sync;
	
	// continuous loop record
	~r_s = { RecordBuf.ar(
		HPF.ar(SoundIn.ar(0), 100), ~r_buf.bufnum, loop:1);
		Out.ar(0, 0);
	}.play;

	// grain synth
	~ch_s = SynthDef.new(\chopy, {
		arg buf=0, gate=0, level=1.0,
		rate=1.0, trate = 12.0, tdust=1.0, dur=0.25, posrate=0.35,
		atk=0.001, rel=1.3, curve=4.0;
		var amp, out, trig, pos;
		trig = LFPulse.kr(trate) + (Dust.kr(trate) * tdust);
		amp = EnvGen.ar(Env.asr(atk, 1, rel, curve), gate:gate, doneAction:0);
		pos = LFNoise1.kr(posrate).abs * 0.8 + 0.1;
		out = BufGrain.ar(trig, dur, buf, rate, pos);
		Out.ar(0, out * amp * level);
	}).play(s, [\buf, ~ch_buf.bufnum]);
	
	s.sync;
	
	~chs = Array.fill(26, {arg j; 
		Synth.new(\chopy, [\buf, ~r_buf.bufnum, \rate, ~geowrap.value(j, 4.0) * 0.5, \atk, 0.001, \rel, 0.001, \gate, 0, \level, 0.35]);
	});

}.play; };

~ch_start = {
	~r_buf.copyData(~ch_buf);
	~ch_s.set(\gate, 1);
};

~ch_stop = {
	~ch_s.set(\gate, 0);
};

~geowrap = { arg in, wrapfactor=2.0;
    var wrapped, wrapit;
    wrapped = 1.0;
    wrapit = { arg v;
        if (v < wrapfactor, {
            wrapped = v;
        }, {
            if ( v < 1.0, {
                v = v * wrapfactor;
                wrapit.value(v);
            }, {
                v = v / wrapfactor;
                wrapit.value(v);
            });
        });
    };
    wrapit.value(in);    
    wrapped
};    



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
	
	if (wha.notNil,{
		wha.postln;
		~chs[wha].set(\gate, 1);	
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
	wha.postln;
	if(char == $ , {
		~ch_stop.value;
	});
	if (wha.notNil,{
		wha.postln;
		~chs[wha].set(\gate, 0);	
	});
	
};

~xw.front;