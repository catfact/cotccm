p = PathName.new(Document.current.path).pathOnly;
x = { |f| this.executeFile(p ++ f); };


Routine {
	s = Server.default;
	s.boot;
	s.sync;

	~tremloop = x.value("tremloop.scd");


	4.0.wait;
	~tremloop.rec(0);
	~tremloop.rec(1, 1);

//	1.0.wait;
//	~loop0 = ~tremloop.run(0);
//
	~loop1 = ~tremloop.run(0, 1, -1, 6/5);

	~loop2 = ~tremloop.run(0, 1, 1, 9/7, 7/6);

	~loop3 = ~tremloop.run(1, 1, -1, 9/8, 7/6);

	~loop3 = ~tremloop.run(1, 1, 1, 11/7, 6/5);

//~loop0

	/*
	{ ~tremloop.buf[0].plot; }.defer;
	*/
}.play;