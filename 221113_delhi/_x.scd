p = Document.current.path;
p = PathName(p).pathOnly;
x = { arg filename; this.executeFile(p ++ filename) };
//
 c = Condition.new;

Routine {
	x.value('audio.scd');
	c.hang;

	x.value('buffers.scd');
	c.hang;

	x.value('dowse.scd');
	c.hang;

	//x.value('lownoise.scd');

	/*
	~lownoise_loops_s = {
	arg rate1=3/4, rate2= 3/5, amp=0.5;
	var snd = PlayBuf.ar(1, ~lownoise_buf.bufnum, [rate1, rate2], loop:1);
	Out.ar(~out_b.index, snd*amp)
	}.play(~xg);
	*/


	x.value('midi.scd');
	c.hang;

}.play;


/*
~lownoise_start_rec.value;
~lownoise_stop_rec.value;
~lownoise_buf.plot;
*/