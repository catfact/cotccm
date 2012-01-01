~basepath = Document.current.dir ++"/";

 x = { |p| this.executeFile(~basepath++p); };



~topdoc = Document.current;
{ ~topdoc.background_(Color.white); }.defer;



~event_tap = CfTapper.new;
~event_tap.tap;

~grbuflist = List.new;
~grbuflen=60.0;
~numgrbufs = 6;

/*
m = Cf40h.new(host:"127.0.0.1", port:8080, prefix:'/box');


m.pressFunctions.add(\tr -> {
	arg col, row;
	["press", col, row].postln;
	if(col==1 && row==1, {
		~topdoc.background_(Color.new(1.0, 0.5, 0.5));
		~event_tap.tap;
		~events.next.value(1, ~event_tap.time);
	});
});


m.liftFunctions.add(\tr -> {
	arg col, row;
	["lift", col, row].postln;
	if(col==1 && row==1, {
		~topdoc.background_(Color.white);
	});
});
*/

w = SCWindow.new("_", Rect(0, 0, 300, 200));
w.view.keyDownAction = { arg v, ch;
	if(ch == $ , {
		~event_tap.tap;
		~events.next.value(1, ~event_tap.time);
	});
};
w.front;
~text = SCStaticText(w, w.view.bounds);
~text.font = Font("Andale Mono", 54);
		
s.boot;
s.waitForBoot { Routine {

		
	SynthDef.new(\patch_stereo, {arg in, out, level=1.0;
		Out.ar(out, In.ar(in, 2) * level);
	}).store;
	
	SynthDef.new(\record_adc, { arg in=0, buf=0, loop=1, recLevel=1.0, preLevel=0.0, offsetSamps=0, doneAction=0;
		RecordBuf.ar(SoundIn.ar(in), buf, loop:loop, recLevel:recLevel, preLevel:preLevel, offset:offsetSamps, doneAction:doneAction);	
	}).store;	
	
	~numgrbufs.do({ 
		~grbuflist.add ( Buffer.alloc(s, s.sampleRate * ~grbuflen) );
	});
	
	x.value("grains.scd");
	x.value("freeze.scd");
	x.value("tones.scd");
	x.value("grainbufglitch.scd");
	x.value("score.scd");



~notify = { arg string, color;
	var win, text;
	{
//		win = SCWindow.new(nil, Rect(0, 0, 800 + 40.rand, 180 + 40.rand));
		if(color.isNil, { color = Color.new(1.0, 1.0.rand, 1.0.rand, 0.5); });
		w.view.background = color; 
		~text.string = string;
//		win.front;
		string.postln;
		w.refresh;
//		AppClock.sched(60, {win.close; nil});
		w.front;
	}.defer;
};

~notify.value("sleep", Color.new(0.1, 0.1, 0.1));

45.do({ arg i;
	~notify.value("minute " ++ i, Color.new(1.0, 1.0, i/45));	60.wait;
});
		
}.play; };



/*


~rec_s.run(false);
~rec_s.run(true);
~rec_s.free;

~grbuflist[0]
~grbuflist[0].plot;

~grbuflist[0].write("rothkosrc.aiff", "AIFF");

~grbuflist[0].read("rothkosrc.aiff");

x = { Out.ar(0, PlayBuf.ar(1, ~buf.bufnum, 1.0)); }.play; 
x.free;

*/
