~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.default;
s.waitForBoot { Routine {

	SynthDef.new(\multicomp, {
		arg in=0, out=0, amp=0.24;
		var sig;
		sig = In.ar(in);
/*		sig = Normalizer.ar(sig, 1.0, [0.1, 0.15]);
		sig = Normalizer.ar(sig, 1.0, [0.2, 0.25]);
		sig = Normalizer.ar(sig, 1.0, [0.3, 0.35]);
*/
		sig = [LPF.ar(sig, 1000), HPF.ar(sig, 1000)];
		sig = Compander.ar(sig, sig, thresh:(-24.dbamp), slopeAbove:0.05, slopeBelow:1, clampTime: 0.01, relaxTime: 0.01);
		sig = Mix.new(sig);
		sig = sig * 15.0;
		sig = Compander.ar(sig, sig, thresh:([-16.dbamp, -18.dbamp]), slopeAbove:0.05, slopeBelow:1, clampTime: [0.01, 0.02], relaxTime: [0.01, 0.02]);
		sig = sig * 6.0;
		Out.ar(out, amp * sig);
	}).store;
	
	0.1.wait;
	
	~ig = Group.new(s);
	~xg = Group.after(~ig);
	~og = Group.after(~og);	
	
	~in_b = Bus.audio(s, 2);
	~in_s = { Out.ar(~in_b.index, SoundIn.ar(0)) }.play(~ig);
	
	0.1.wait;
	
	~crawl_in_b = Bus.audio(s, 2);
	// nomralizer splits mono to stereo
	~crawl_norm = Synth.new(\multicomp, [\in, ~in_b.index, \out, ~crawl_in_b.index], ~ig, \addAfter);
	
	0.1.wait;
	
	~crawls_bottom = Array.fill(8, {
		Crawl.new(s, ~xg, ~crawl_in_b.index, 0);
	});
	
	~crawls_top = Array.fill(8, {
		Crawl.new(s, ~xg, ~crawl_in_b.index, 0);
	});
	
	0.1.wait;
	
	~crawls_top.do({ arg crawl; crawl.rate = 0.5; });
	
	x.value("_gui.scd");
		
}.play; };


/*

~crawls_bottom[0].startRecording;
~crawls_bottom[0].stopRecording;

~crawls_bottom[1].startRecording;
~crawls_bottom[1].stopRecording;

~crawls_top[0].startRecording;
~crawls_top[0].stopRecording;

~crawls_top[1].startRecording;
~crawls_top[1].stopRecording;

~crawls_bottom[2].startRecording;
~crawls_bottom[2].stopRecording;

~crawls_bottom[3].startRecording;
~crawls_bottom[3].stopRecording;

~crawls_top[2].startRecording;
~crawls_top[2].stopRecording;

~crawls_top[3].startRecording;
~crawls_top[3].stopRecording;



~crawls_bottom[1].buf.plot

~crawls_bottom[0].dur
~crawls_bottom[0].dur * 8
~crawls_bottom[0].posinc
~crawls_bottom[0].skip

~crawls_bottom[0].level = 0.5

~crawls_bottom[0].pos


*/

