(
4.do {  arg i;
	~tremloop.buf[i].normalize;
	{ ~tremloop.buf[i].plot }.defer;
};
)

(
// overdub all
Routine { 4.do { arg i;

	~tremloop.rec(i, 0, pre:0.5);
	((i+1) * 1.75).wait;
} }.play;
)

~poll_task.stop;
~poll_task.reset;
~poll_task.play;

	x.value("sine_sequence.scd");
