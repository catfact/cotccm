
SynthDef.new(\chopgrain, {
	arg buf, out=0, level=1.0,
	rate=1.0, choprate=1.0, posrate=0.25,
	atk=1.0, rel=1.0, gate=1, pan=0.0,
	minframes=0, maxframes=44100;
	
	var ampenv, pos, trig, phase, read,
	sr, frames, ratescale, framediff;
	
	sr = SampleRate.ir;
	frames = BufFrames.kr(buf);
	ratescale = BufRateScale.kr(buf);
	framediff = maxframes - minframes;
	
	ampenv = EnvGen.ar(Env.asr(atk, 1.0, rel), gate:gate, doneAction:2);
	
	trig = Impulse.ar(choprate);
	
	pos = LFSaw.kr(posrate / framediff * sr, 0, framediff, minframes).wrap(minframes, maxframes - (sr / choprate));
	read = PlayBuf.ar(1, buf, rate, trig, pos, loop:1);
	
	Out.ar(out, Pan2.ar(read * ampenv * level, pan));
}).send(s);

~vlgr_r.stop;

~vlgr.do({ arg gr;
	gr.gr1.set(\amplag, 120.0);
	gr.gr1.set(\amp, 0); 
	gr.gr2.set(\amplag, 120.0);
	gr.gr2.set(\amp, 0); 
});


~dgr_ratios = [
	[ 9/8, 9/16, 9/8, 9/16, 9/16 ],
	[ 16/15, 16/30 			],
	[ 15/16, 15/32			],
	[ 3/4, 3/2, 3/8			], 
	[ 9/8, 9/16, 18/8			],
	[ 16/15,	32/15 			],
	[ 15/16, 15/32			],
	[ 3/4, 3/8				]
]; 


~dgr = ~vlgr_buf.collect({arg buf, i;
	~dgr_ratios[i].collect({ arg rat, j;
		Synth.new(\chopgrain, [
			\buf, buf.bufnum,
			\choprate, 2.0 + (i * 0.125) + (j * 0.125),
			\posrate, 0.125 + (i * 0.0625) + (j * 0.0625),
			\atk, 20.0 + (3.0 * (i+j)),
			\rel, 60.0 - (2.0 * (i+j)),
			\rate, rat,
			\level, 0.5
		]);
	});
});


~dgr_ratios = [
	[ 9/8, 9/16, 9/8, 9/16, 9/16 ],
	[ 16/15, 16/30 			],
	[ 15/16, 15/32			],
	[ 3/4, 3/2, 3/8			], 
	[ 9/8, 9/16, 18/8			],
	[ 16/15,	32/15 			],
	[ 15/16, 15/32			],
	[ 3/4, 3/8				]
]; 

/*

~dgr.do({ arg grs; grs.do({ arg gr; gr.free; }); });

~dgr.do({ arg grs, i; grs.do({ arg gr, j; gr.set(\rate, ~dgr_ratios[i][j]); }); });


~dgr.do({ arg grs; grs.postln; });
*/

~spch_freezebase = 3.5;
~spch_freezemod = 2.0;
~spch_tbase = 6.25;
~spch_rats = [1.0, 1.0, 1.25, 2.0, 2.0, 1.5, ];
~spch_s.set(\time, 4.5);


Routine {
	240.wait;	
	~spch_stretch_r.stop;
	~spch_time_r.stop;
	~spch_freeze_r.stop;
	~spch_s.free;
	~dgr.do({ arg grs, i; grs.do({ arg gr, j; gr.set(\gate, 0); }); });
}