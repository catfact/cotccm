~snaps = { arg whichsource=0, wait=0.1, start=0, num=8;
	
	var idx = start;
	~freezer.set(\in, ~jl_b[whichsource].index);
	Routine { num.do({ arg i;
		~snapshot.value(idx);
		idx = idx + 1;
		wait.wait;
	}) }.play;

};
