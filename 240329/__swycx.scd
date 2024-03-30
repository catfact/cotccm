
if (~basepath.isNil, {
	~basepath = Document.current.dir ++"/";
});

postln("basepath: " ++ ~basepath);
x = { |p| this.executeFile(~basepath++p); };

Routine {
	x.value("_audio.scd");
	x.value("defs.scd");

	//	~mbut = Point(2, 2);
	1.wait;

	//	"drift drag".postln;

	//	x.value("2_driftdrag.scd");
	//	x.value("2_driftdrag_ctl.scd");

	x.value("_savewhatyoucan.scd")


}.play;

~clock_w = Window.new("clock", Rect(300, 600, 300, 80));
~clock_t = StaticText(~clock_w, ~clock_w.view.bounds);
~clock_t.setProperty(\font, Font(\Monaco, 60));
~clock_r = Routine{ inf.do({ arg i;
	{ ~clock_t.string = "" ++ (i / 60).floor ++ "." ++ i; }.defer;
	1.0.wait;
}) }.play;
~clock_w.front;

~notify = { arg string, color;
	var win, text;
	{
		win = Window.new(nil, Window.screenBounds.insetBy(100));
		if(color.isNil, { color = Color.new(1.0, 1.0.rand, 1.0.rand, 0.5); });
		win.view.background = color;
		text = StaticText(win, win.view.bounds);
		text.font = Font("Andale Mono", 54);
		text.string = string;
		win.front;
		string.postln;
		//	win.refresh;
		AppClock.sched(4.0, {win.close; nil});
	}.defer;
};


///// midi

MIDIClient.init;
MIDIIn.connectAll;

// midi responder functions
m = ();
m.allCC =  MIDIFunc.cc({
	arg val, num, chan, src;
	[val, num, chan, src].postln;
}, nil);

m.noteOn =  MIDIFunc.noteOn({
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	if (num == 64, {
		~advance_score.value;
	});
}, nil);
//
// m.noteOff =  MIDIFunc.noteOff({
// 	arg val, num, chan, src;
// 	[val, num, chan, src].postln;
// }, nil);

//m.wasOn = false;
/*
m.ccVol = MIDIFunc.cc({
	arg val, num, chan, src;
	[val, num, chan, src].postln;

	if (m.wasOn.not, {
// 		postln("?");
		if (val > 124, {
			m.wasOn = true;
			postln("vol pedal down");
			~advance_score.value
		}, {
			m.wasOn = false;
		});
	}, {
		if (val > 124, {
		}, {
			m.wasOn = false;
		});
	});
}, 11);*/

