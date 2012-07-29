Routine {
	
~voxdelbuf = Buffer.alloc(s, s.sampleRate * 16.0);
s.sync;
~voxdel_s = Synth.new(\bufdelay_fb, [\in, c.in_b, \out, c.in_b, \buf, ~voxdelbuf.bufnum, \feedback, -12.dbamp, \delaytime, 0.5], c.ig, \addToTail);

~vox_out_s = Synth.new( \pan, [\in, c.in_b, \out, c.out_b], c.og, \addToHead);

~voxdel_r = Routine {inf.do { arg i;
	~voxdel_s.set(\delaytimelag, ((((i * 3) % 4) + 1) / 512));
	~voxdel_s.set(\delaytime, ((((i * 6) % 9) + 1) * 0.125));
	(((i * 3) % 4) * 0.25).wait;
} }.play;

~voxcl_b = Bus.audio(s, 1);
~voxcl_out = Synth.new(\pan, [\in, ~voxcl_b, \out, c.out_b], c.og);

~voxcl_recstate = 0;
~voxcl_playstate = 0;

~but_func[0] = { arg state;
	if (state, {
		postln("voxcl press");
		if(~voxcl_recstate == 0, {
			// start recording
			Routine {
				~gr_rec[0].set(\trig, 0);
				0.001.wait;
				~gr_rec[0].set(\trig, 1);
				~gr_rec[0].set(\run, 1);
				~voxcl_start = SystemClock.seconds;
				~voxcl_recstate = 1;
			}.play;
		});
		if(~voxcl_recstate == 1, {
			// stop recording
			~gr_rec[0].set(\trig, 0);
			~gr_rec[0].set(\run, 0);	
			~voxcl_dur = SystemClock.seconds - ~voxcl_start;
			~voxcl_recstate = 0;
			// start playing
			~voxcl_play.value;
		});
	});
};

~voxclr = Routine {
	var wait, pos, atk, rel, dur, tog, baserate;
	inf.do({ arg i;
		j = (i* 2) % 32;
		i = (i* 3) % 32;
		wait = if((i%5 ==0) || (j%5 ==0) , {0.125}, {0.25});
		pos = (((j * 2) % 32) * ~voxcl_dur * 0.0625).wrap(0, ~voxcl_dur);
		pos = (pos + (((i * 3) % 32) * ~voxcl_dur * 0.0625)).wrap(0, ~voxcl_dur);
		atk = 0.0625;
		dur = ((i * 4) % 9) + 1 * 0.125;
		rel = 0.25 + (0.125 * ((i * 5) % 3));
		tog = ((i + j) % 5 + 1) / 2.0;
		baserate = if(i > 30, {3.0}, { if((i % 6) == 0, {2.0}, {1} )} );
		[wait, pos, dur, baserate].postln;
		{ PlayBuf.ar(1, ~grbuf[0].bufnum, 
				rate:Lag.ar(ToggleFF.ar(LFPulse.ar(tog)) * 2 - 1, 1 / 32.0) * baserate,
				startPos:pos
			) * EnvGen.ar(Env.linen(atk, dur, rel), doneAction:2)
		}.play(c.xg, ~voxcl_b);
						
//		wait = ((((i*9) % 5) + 1) * 0.0625);
//		wait.postln;
		wait.wait;
	});
};

~voxcl_play = {
	if (~voxcl_playstate == 0, {
		~voxcl_playstate = 1;
		~voxclr.play;
	});
};

}.play;