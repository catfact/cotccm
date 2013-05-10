
~basepath = "/home/emb/sc/cotccm/120827_hil/";
x = { |p| this.executeFile(~basepath++p); };

c = CfAudioContext.new(s, 2, {
	x.value("_defs.scd");
	s.sync;		
	x.value("_jloop.scd");

}); 


/*
b[0].plot;
*/