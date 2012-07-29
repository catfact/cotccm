 ~basepath = "/Users/e/scm/cotccm/120728_humanresources/";
 x = { |p| this.executeFile(~basepath++p); };

s = Server.default;
 
~grbuflen = 60.0;
~ngrbuf = 4;

 
Routine {
	x.value("arduino.scd");

	c = CfAudioContext.new(s, 2, { 
		Routine {
			// buffers
			~grbuf = c.allocBufs(~ngrbuf, ~grbuflen);
			s.sync;
			// grain synths and control busses
			~gr = ~grbuf.collect({ arg bf; 
				BusGrainer.new(s, bf, c.xg, c.out_b);
			});
			// record synths
			~gr_rec = ~grbuf.collect({ arg bf; 
				Synth.new(\rec, [\in, c.in_b, \buf, bf], c.ig, \addAfter);
			});
			// analysis...
			~freq_b = Bus.control(s);
			~hasfreq_b = Bus.control(s);
			~amp_b = Bus.control(s);
			~centroid_b = Bus.control(s);
			~flatness_b = Bus.control(s);
			Synth.new(\pitch, [\in, c.in_b, \outFreq, ~freq_b, \ooutHasFreq, ~hasfreq_b], c.ig, \addAfter);
			Synth.new(\amp, [\in, c.in_b, \out, ~amp_b ], c.ig, \addAfter);
			Synth.new(\centroid, [\in, c.in_b, \out, ~centroid_b], c.ig, \addAfter);
			Synth.new(\flatness, [\in, c.in_b, \out, ~flatness_b], c.ig, \addAfter);
			
		}.play;	
		
	});
}.play;
