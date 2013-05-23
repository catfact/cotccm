//~changegrains.value(1);


~ch_key = OSCdef.newMatching('pm_key', { arg msg, time, addr, rec;
	var x, y, val;

	x=msg[1];
	y=msg[2];
	val=msg[3];
	
	if(y == 5, {
		postln("chord index : " ++ x);
		~chgrfn[x].value;
	});
}, ~prefix++'/grid/key');
