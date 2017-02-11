
~capture_start.value(0);
~capture_stop.value(0);

~capture_start.value(1);
~capture_stop.value(1);

~screm[0].buf.plot;

~doscrem.value(~screm[0], 35, 7, 11, 31, amp:0.25 / 35);
~doscrem.value(~screm[1], 24, 5, 3, 17, amp:0.25 / 25);


~screm_g.set(\amplag, 10.0);
~screm_g.set(\amp, 0.0);
