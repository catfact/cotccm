
/*
	Routine {
	if(idx > 0, {
	~voch1.get(\shift, { arg val;
	///			postln("voch1shift: " ++ val);
	v = val * (~vochr1.next);
	~voch1.set(\shift, v);
	~post.value("vs1_"++v);
	});
	~voch2.get(\shift, { arg val;
	v = val * (~vochr2.next);
	//			postln("voch2shift: " ++ val);
	~voch2.set(\shift, v);
	~post.value("vs2_"++v);
	});
	}, {
	~voch1.get(\shift, { arg val;
	v = val / (~vochr1.next);
	//postln("voch1shift: " ++ val);
	~voch1.set(\shift, v);
	~post.value("vs1_"++v);
	});
	~voch2.get(\shift, { arg val;
	v = val / (~vochr2.next);
	//postln("voch2shift: " ++ val);
	~voch2.set(\shift, v);
	~post.value("vs2_"++v);
	});
	});
	s.sync;
	//		~post.value(txt.flatten);
	}.play;
*/
