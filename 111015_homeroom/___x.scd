~basepath = Document.current.dir ++"/";
 x = { |p| this.executeFile(~basepath++p); };
 
Routine {

	x.value("0_40h.scd");
	x.value("0_audio.scd");
	 
	6.wait;
	
	"ca".postln;
	
	x.value("1_ca.scd");
	x.value("1_ca_ctl.scd");
}.play;



~clock_w = SCWindow.new("clock", Rect(300, 600, 300, 80));
~clock_t = SCStaticText(~clock_w, ~clock_w.view.bounds);
~clock_t.setProperty(\font, Font(\Monaco, 60));
~clock_r = Routine{ inf.do({ arg i;
	{ ~clock_t.string = "" ++ (i / 60).floor ++ "." ++ i; }.defer;
	1.0.wait;
}) }.play;
~clock_w.front;