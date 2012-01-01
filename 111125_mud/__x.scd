~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.local;
~ctx = CfAudioContext.new(s, 2, { 
	Routine {
		x.value("freeze.scd");
		x.value("crawl.scd");
		s.sync;
		x.value("_canvas.scd");
		x.value("_audio.scd");
		s.sync;
		x.value("_driftdrag.scd");
		0.1.wait;
		x.value("_40h.scd");
		0.1.wait;
		
		x.value("_grandel_monome.scd");
		x.value("_keys.scd");
		300.wait;
		x.value("fpring.scd");
		1.0.wait;
		x.value("fpu_params.scd");
		50.wait;
		x.value("fpu_perturb.scd");
		300.wait;
		x.value("slow.scd");
		300.wait;
		~vg.set(\gate, 0);
	}.play;
});