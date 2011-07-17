~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };


s = Server.local.boot;
s.waitForBoot { Routine {

//	x.value("io.scd");
	x.value("loops.scd");
	
	0.1.wait;
	
	x.value("freeze.scd");
	
	4.1.wait;
	
	x.value("ctl_funcs.scd");	
	
	0.1.wait;
	
	x.value("spiral.scd");	
}.play; };

