p = PathName.new(Document.current.path).pathOnly;
x = { |f| this.executeFile(p ++ f); };


Routine {
	s = Server.default;
	s.boot;
	s.sync;

	x.value("tremloop.scd");

	x.value("remains.scd");


	4.0.wait;

	postln("3...");
	1.0.wait;
	postln("2...");
	1.0.wait;
	postln("1...");
	1.0.wait;

	postln("--------------------");
	postln("---- start ---------");
	postln("--------------------");

	110.wait;


	postln("10...");
	1.0.wait;
	postln("9...");
	1.0.wait;
	postln("8...");
	1.0.wait;
	postln("7...");
	1.0.wait;
	postln("6...");
	1.0.wait;
	postln("5...");
	1.0.wait;
	postln("4...");
	1.0.wait;
	postln("3...");
	1.0.wait;
	postln("2...");
	1.0.wait;
	postln("1...");
	1.0.wait;

	postln("");
	postln("--------------------");
	postln("---- recording ---------");
	postln("--------------------");
	postln("");

	~tremloop.rec(0);
	~tremloop.rec(1, 1);

	16.wait;
	x.value("sine_sequence.scd");

	~poll_task.stop;

//~loop0

	/*
	{ ~tremloop.buf[0].plot; }.defer;
	*/
}.play;