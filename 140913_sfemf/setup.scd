// utility stuff
~cueAction = {
	arg label="act", timein=8.0, timeout=8.0, dur=16.0,
	start={"start".postln}, end={"end".postln;};

	var win,lab,val;
	{
		win = Window.new(label, Rect(50, 600, 200, 200));
		win.front;
		lab = StaticText.new(win, Rect(0, 150,  200, 50));
		lab.font = Font(size:16);
		lab.align = \center;
		lab.string = label;

		val = Slider.new(win, Rect(0, 0, 200, 100));

		Routine {
			// fade in
			32.do({ |i|
				val.value = i / 32;
				(timein/32).wait;
			});
			val.value = 1.0;
			start.value;
			(dur-timeout).wait;
			// fade out
			32.do({ |i|
				val.value = (32-i)/32;
				(timeout/32).wait;
			});
			val.value=0.0;
			end.value();
			2.0.wait;
			win.close;
		}.play(AppClock);

	}.defer;
};

//~cueAction.value("this");

// special case to record buffer 1 time
~recBuf = { arg buf, in=0, end;
	var dur;
	buf.postln;
	dur = buf.numFrames / s.sampleRate;
	~cueAction.value(
		label: ("record "++ buf.asString),
		start: { Synth.new(\recOnce, [\buf, buf.bufnum, \in, ~ib.index + in], ~ig, \addAfter); },
		end:end,
		dur:dur
	);
};
