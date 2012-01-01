~grenvbuflist = List.new;
~numbufs.do({
	~grenvbuflist.add( Buffer.alloc(s, 2048, 1); );
});

// 	copyData { arg buf, dstStartAt = 0, srcStartAt = 0, numSamples = -1;

~grglitch = {arg num, pos;
	~grbuflist[num].copyData(~grenvbuflist[num], 0, pos);
	~grenvbuflist[num].normalize;
	~grainlist[num].do({ arg grainer;
		grainer.gr_s.set(\env_buf, ~grenvbuflist[num].bufnum);
	});
};

~grunglitch = {arg num;
	~grainlist[num].do({ arg grainer;
		grainer.gr_s.set(\env_buf, -1);
	});
};

~grglicth_r = Routine { (60 * 6).do({ arg i;
	var list;
	list = ~grainlist.size.rand;

	if (0.5.coin, {
		~grglitch.value(list, (44100 * 10).rand);
	}, {
		~grunglitch.value(list);
	});
	
	(1 + ((i*7) % 3)).wait;
	
}); };