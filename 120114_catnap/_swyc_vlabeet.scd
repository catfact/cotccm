~vlabeet_t = 60/55 * 0.5;
~vlabeet_rbase = 1.0;
~vlabeet_dur_base = 1.0;
~vlabeet_level = 2.dbamp;
//~vlabeet_level = 0.10;

~vlabeet_dur_seq = Pseq([
	// count off
	2, 3, 2, 2, 3, 2, 2, 3, 2, 2, 3, 2,
	
	// g
	2, 3, 2, 2, 3, 2, 4, 3, 6, 
	
	// eb
	2, 3, 2, 2, 3, 2, 4, 3, 6, 
	
	// g
	2, 3, 2, 2, 3, 2, 4, 3, 6, 
	
	// eb
	2, 3, 2, 2, 3, 2, 4, 3, 6, 
	
	// g
	2, 3, 2, 2, 3, 2, 4, 3, 6, 
	
	// c
	2, 3, 2, 2, 3, 2, 4, 3, 6, 
	
	
	// g
	2, 3, 2, 2, 3, 2, 4, 3, 6, 
	
	// eb
	2, 3, 2, 2, 3, 2, 4, 3, 6, 
	
	// g
	2, 3, 2, 2, 3, 2, 4, 3, 6, 
	
	// eb
	2, 3, 2, 2, 3, 2, 4, 3, 6, 
	
	// c
	2, 3, 2, 2, 3, 2, 4, 3, 6, 
], inf).asStream;


~vlabeet_rate_seq = Pseq([
	// count off
	//2, 3, 2, 2, 3, 2, 2, 3, 2, 2, 3, 2,
	  1, 2, 4, 1, 2, 4, 1, 2, 4, 1, 3, 8, 
	// g
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	// eb
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	// g
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	// eb
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	// g
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	// c
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	
	// g
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	// eb
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	// g
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	// eb
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	// c
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
], inf).asStream;



~vlabeet_io_seq = Pseq([
	// count off
	//2, 3, 2, 2, 3, 2, 2, 3, 2, 2, 3, 2,
	  1, 2, 1, 1, 2, 1, 1, 2, 3, 1, 3, 2, 
	// g
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 1, 1, 2, 1, 1, 4, 2,
	// eb
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 1, 1, 2, 4, 1, 1, 2,
	
	// g
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 1, 1, 2, 4, 1, 1, 2,
	
	// eb
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 1, 1, 2, 4, 1, 1, 2,
	
	// g
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 1, 1, 2, 4, 1, 1, 2,
	
	// c
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 1, 1, 2, 4, 1, 1, 2,
	
	
	// g
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	// eb
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	// g
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	// eb
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
	
	// c
	//2, 3, 2, 2, 3, 2, 4, 3, 6, 
	  1, 2, 4, 1, 2, 4, 1, 4, 2,
], inf).asStream;

~vlabeet_r = Routine { inf.do({ arg i;
	var dur = ~vlabeet_dur_seq.next * ~vlabeet_t * ~vlabeet_dur_base;
	var rate = ~vlabeet_rate_seq.next * 0.5 * ~vlabeet_rbase;
	var io = ~vlabeet_io_seq.next * -32.dbamp;
	dur.postln;
	Synth.new(\grain_1shot_rez_dist, [
		\buf, ~jl_bufs[i%4].bufnum,
		\pos, 0.125,
		\dur, 0.125,
		\rate, rate,
		\choprate, 0.25 / ~vlabeet_t,
		\hz, 220 * 8/9 * (i % 2 + 1),
		\rq, (i%4) * 0.02 + 0.07,
		\insideout, io,
		\atk, 0.01, \rel, dur * 2.0,
		\level, ~vlabeet_level, //i.min(32) / 32
	], s);
	dur.wait;
}); }.play;


~metro_w = SCWindow.new("metro", Rect(300, 300, 100, 80));
~metro_t = SCStaticText(~clock_w, ~clock_w.view.bounds);
~metro_t.setProperty(\font, Font(\Monaco, 60));
~metro_r = Routine{ inf.do({ arg i;
	{ ~metro_w.view.background = Color.white }.defer;
	
	AppClock.sched(0.1, { ~metro_w.view.background = Color.black; nil});
	(~vlabeet_t * 0.5).wait;
}) }.play;
~metro_w.front;

/* 
~metro_r.stop;
*/