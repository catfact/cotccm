~grains = List.new;


	~grrecord = { arg buf=0;
		~rec_s = Synth.new(\record_adc, [\in, 0, \buf, ~grbuflist[buf].bufnum, \loop, 0, \doneAction, 2]);
	};
	

	


Routine { 4.do({ arg i;
	~grains.add(BusGrainer.new(s, ~grbuflist[0]));
	(i * 4 + 8).wait;
}) };

~grains.add(BusGrainer.new(s, ~buf));

~grains[0].grtrig_s.set(\hz, 4.25);
~grains[1].grtrig_s.set(\hz, 8);
~grains[2].grtrig_s.set(\hz, 4 * 6/5);
~grains[3].grtrig_s.set(\hz, 8 * 2/3);