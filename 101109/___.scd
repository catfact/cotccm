~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };


s = Server.local.boot;
s.waitForBoot {

//	x.value("_hid.scd");
	x.value("jalop.scd");
	x.value("spirals.scd");
	x.value("__fraw.scd");
}
