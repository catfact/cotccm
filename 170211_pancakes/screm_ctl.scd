w = Window.new("screm");
w.view.keyDownAction = {
	arg view, char, mod, unicode, keycode, key;
	var which = nil;
	which = switch(char,
		$1, {0}, $2, {1}, $3, {2}, $4, {3}
	);
	if(which.notNil, {
		~capture_start.value(which);
	});
	w.view.background = Color.white;
};
w.view.keyUpAction = {
	arg view, char, mod, unicode, keycode, key;
	var which = nil;
	which = switch(char,
		$1, {0}, $2, {1}, $3, {2}, $4, {3}
	);
	if(which.notNil, {
		~capture_stop.value(which);
	});
	w.view.background = Color.black;
};
w.front;

~capture_start.value(0);
~capture_stop.value(0);

~capture_start.value(1);
~capture_stop.value(1);

~screm[0].buf.plot;
~screm[1].buf.plot;

~screm[0].buf.normalize
~screm[1].buf.normalize

~doscrem.value(~screm[0], 35, 7, 11, 31, amp:0.25 / 35);
~doscrem.value(~screm[1], 24, 5, 3, 17, amp:0.25 / 25);

~screm_g.set(\amplag, 60.0);
~screm_g.set(\amp, 1.0 / (24 + 35));


~screm_g.set(\amp, 0.0);
