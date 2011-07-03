

~grainlist[0].do({arg grainer, i;
	var num, denom, hz;
	num = 4+i;
	denom = 4 + ((i*5) % 3);
	hz = 4 * num / denom;
	[num, denom, hz].postln;
	grainer.grtrig_s.set(\hz, hz);
});



~grainlist[1].do({arg grainer, i;
	var num, denom, hz;
	num = 4+i;
	denom = 5 + (((i+1)*5) % 3);
	hz = 4 * num / denom;
	[num, denom, hz].postln;
	grainer.grtrig_s.set(\hz, hz);
});



~grainlist[2].do({arg grainer, i;
	var num, denom, hz;
	num = 6-i;
	denom = 7 + (((i+2)*3) % 4);
	hz = 8 * num / denom;
	[num, denom, hz].postln;
	grainer.grtrig_s.set(\hz, hz);
});


~grainlist[3].do({arg grainer, i;
	var num, denom, hz;
	num = 1;
	denom = (i%2) + 1;
	hz = 8 * num / denom + 0.01.rand2;
	[num, denom, hz].postln;
	grainer.grtrig_s.set(\hz, hz);
});




~grainlist.do({arg list; list.do({ arg grainer; grainer.grdur_b.set(1.5); }); });