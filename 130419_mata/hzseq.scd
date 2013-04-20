~hzlist = List.new;

~hz_add = { arg hz;
	~hzlist.add(hz);
	~hzlist = ~hzlist.sort;
	~hzlist.postln;
};

