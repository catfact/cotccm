Routine {

	~ndel = 3;
	~vdellen = 32.0;
	~voxdelbuf = Array.fill(~ndel, { Buffer.alloc(s, s.sampleRate * ~vdellen); });

	s.sync;
	~voxdel_s = Array.fill(~ndel, { arg i;
		Synth.new(\bufdelay_fb, [
			\in, c.in_b.index, 
			\out, c.out_b, 
			\buf, ~voxdelbuf[i].bufnum, 
			\feedback, -12.dbamp, 
			\delaytime, 0.5
		], c.ig, \addToTail)
	});

	~voxdel_s.do({ arg del; del.set(\feedback, 0.25); });

	//~vox_out_s = Synth.new( \pan, [\in, c.in_b, \out, c.out_b], c.og, \addToHead);

	~voxdelbase = [0.125, 4.0, 8.0];

	~voxdel_r = Routine { var time, lag; 
		inf.do ({ arg i; 
			~ndel.do({ arg j;
				lag = ((i * 3) % 4) / 512;
				time = ( ( (i * 6) % 4) + 1) * ~voxdelbase[j];
				time = time.wrap(0, ~vdellen);
				~voxdel_s[j].set(\delaytimelag, lag);
				~voxdel_s[j].set(\delaytime, time);
				(((i * 3) % 4)).wait;
			});
		});
	}.play;

}.play;