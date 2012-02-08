
//// pressed events
~events = Pseq([
	{ Routine {
		
		~notify.value("grain 0");
		~grrecord.value(0);
		~grplay.value(0);
		
		60.wait;
		
		"hzshift".postln;
		
		~grainlist[0].do({arg grainer, i;
			var num, denom, hz;
			num = 4+i;
			denom = 4 + ((i*5) % 3);
			hz = 4 * num / denom;
			[num, denom, hz].postln;
			grainer.grtrig_s.set(\hz, hz);
		});
		
		~grainlist[0].do({ arg grainer; grainer.grdur_b.set(1.5); });
		~grainlist[0].do({ arg grainer; grainer.gr_s.set(\amp, 0.25); });
		
	}.play; },
	
	{ Routine {
		~grrecord.value(1);
		~grplay.value(1);
		~notify.value("grain 1");

				
		60.wait;
		
		~grainlist[1].do({arg grainer, i;
			var num, denom, hz;
			num = 4+i;
			denom = 5 + (((i+1)*5) % 3);
			hz = 4 * num / denom;
			[num, denom, hz].postln;
			grainer.grtrig_s.set(\hz, hz);
		});	
		~grainlist[1].do({ arg grainer; grainer.grdur_b.set(1.5); });
		~grainlist[1].do({ arg grainer; grainer.gr_s.set(\amp, 0.25); });	}.play; },
	
	{ Routine {
		~notify.value("grain 2");
		~grrecord.value(2);
		~grplay.value(2);
		
		60.wait;
		"hzshift".postln;
		
		~grainlist[2].do({arg grainer, i;
			var num, denom, hz;
			num = 6-i;
			denom = 7 + (((i+2)*3) % 4);
			hz = 8 * num / denom;
			[num, denom, hz].postln;
			grainer.grtrig_s.set(\hz, hz);
		});
		~grainlist[2].do({ arg grainer; grainer.grdur_b.set(1.5); });
		~grainlist[2].do({ arg grainer; grainer.gr_s.set(\amp, 0.25); });
	}.play; },
	
	{ Routine {
		~notify.value("grain 3");
		~grrecord.value(3, 1);
		~grplay.value(3);
		
		60.wait;
		
		"hzshift".postln;
		~grainlist[3].do({arg grainer, i;
			var num, denom, hz;
			num = 1;
			denom = (i%2) + 1;
			hz = 8 * num / denom + 0.01.rand2;
			[num, denom, hz].postln;
			grainer.grtrig_s.set(\hz, hz);
		});
		
		~grainlist[3].do({ arg grainer; grainer.grdur_b.set(1.5); });
		~grainlist[3].do({ arg grainer; grainer.gr_s.set(\amp, 0.25); });
	}.play; },
	
	{ Routine {
		~notify.value("grain 4");
		~grrecord.value(4, 1);
		~grplay.value(4);
		
		60.wait;
		
		~grainlist[4].do({arg grainer, i;
			var num, denom, hz;
			num = 1;
			denom = (i%2) + 1;
			hz = 8 * num / denom + 0.01.rand2;
			[num, denom, hz].postln;
			grainer.grtrig_s.set(\hz, hz);
		});
		"hzshift".postln;
		
		~grainlist[4].do({ arg grainer; grainer.grdur_b.set(1.5); });
		~grainlist[4].do({ arg grainer; grainer.gr_s.set(\amp, 0.25); });
	}.play; },
	
	{ Routine {
		~notify.value("grain 5");
		
		~grrecord.value(5, 1);
		~grplay.value(5);
		
		60.wait;
		
		~grainlist[5].do({arg grainer, i;
			var num, denom, hz;
			num = 1;
			denom = (i%2) + 1;
			hz = 8 * num / denom + 0.01.rand2;
			[num, denom, hz].postln;
			grainer.grtrig_s.set(\hz, hz);
		});
		"hzshift".postln;
		
		~grainlist[5].do({ arg grainer; grainer.grdur_b.set(1.5); });
		~grainlist[5].do({ arg grainer; grainer.gr_s.set(\amp, 0.25); });
		
//		(10 * 60).wait;	
	}.play },
	/*
	{
		~grglitch_r.play;
		~notify.value("grglch");
		
	},
	*/
	{
		~freezers_r.play;
		~notify.value("freezers");
	}, {
		~tones_r.play;
		~notify.value("tones");
	}
		
]).asStream;



~freezers_r = Routine {
	8.do({arg i;
		~snapshot.value(i);
		15.0.wait;
	});
	
	32.do({ arg i;
		~hz_store.value;
		8.0.wait;
	});	
	~amp = Array.fill(8, {-6.dbamp});
	~freezer_s.set(\amp, ~amp);
	~grains_out_r.play;
};

~tones_r = Routine {
	~hz_play.value;
	~amplag = Array.fill(8, {120.0});
	~amp = Array.fill(8, {0.0});
	~freezer_s.set(\amplag, ~amplag);	
	~freezer_s.set(\amp, ~amp);
};

~grains_out_r = Routine {
	~grainlist.do({ arg list, i;
		list.do({ arg grainer, j;
			grainer.gr_s.set(\amp, -20.dbamp);
			1.0.wait;
		});
	});
};

~grains_gone_r = Routine {
	~grainlist.do({ arg list, i;
		list.do({ arg grainer, j;
			grainer.gr_s.set(\amp, 0.0);
			1.0.wait;
		});
	});
};