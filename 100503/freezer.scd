//----- vars
s = Server.internal;

s.boot;
s.waitForBoot { Routine {

	~in_b = Bus.audio(s, 1);
	~in_s = { Out.ar(~in_b.index, SoundIn.ar(0);); }.play(s);
	~freezer = Freezer9.new(s, ~in_b.index, 0, ~in_s, \addAfter);
			
	m = CfMonome.new;
	
	0.1.wait;
	
	m.press = { arg x, y;
		if ((x < 3) && (y < 3), { 
			var which = y + (x*3);
			if (~freezer.voiceflags[which], {
				~freezer.stop_note(which);
				m.led(x, y, 0);
			}, {
				~freezer.start_note(which);
				m.led(x, y, 1);
			});
		}, {
			m.led(x, y, 1);
		});
	};
	
		
	m.lift = { arg x, y;
		if ((x < 3) && (y < 3), { 
			var which = y + (x*3);
			if (~freezer.voiceflags[which], {
				~freezer.continue_stopping(which);
			}, {
				~freezer.continue_starting(which);
			});
		}, {
			m.led(x, y, 0);
		});
	};
	
	8.do({|i|m.ledRow(i, 0);});
	
	
}.play; }
