~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };


Routine {
	~vla_longdel_amp_line.free;
	~vox_delt_line.free; 
	~vox_fb_line.free;
	
	~vox_delamp_line.free;
	s.sync;

	~vox_delamp_line = { Out.kr(~vox_delamp_b.index, Line.kr(1.0, 0.0, 60); ) }.play(s); 
	~vla_longdel_amp_line = { Out.kr(~vla_delamp_b.index, Line.kr(1.0, 0.0, 60); ) }.play(s);

	x.value("gouge.scd");

}.play;