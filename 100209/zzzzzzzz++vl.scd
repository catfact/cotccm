/*
~loop_buf = Buffer.alloc(s, 100 * s.sampleRate, 1);
*/

~loop_buf = Buffer.alloc(s, 100 * s.sampleRate, 1, {
SystemClock.sched(0.1, {
/*
~loop_buf.free;
*/	
	/*
	 SynthDef.new(\bufdelay, {
		arg in=6, 
			out=0,
			buf=0,
			buflength = 1.0,
			amp = 1.0,
			inputamp = 1.0,
			delaytime= 1.0,
			feedback = 0.0;
		var delay, fb;
		delay = BufDelayL.ar(buf, In.ar(in) * inputamp, delaytime) * amp;
		fb = RecordBuf.ar(delay, buf, recLevel:feedback, preLevel:1.0, loop:1);
		Out.ar(out, (delay * amp) );
	}).load(s);


	SynthDef.new(\bufdelay_fb, {
		arg in=6, 
			out=0,
			buf=0,
			buflength = 1.0,
			amp = 1.0,
			inputamp = 1.0,
			delaytime= 1.0,
			feedback = 0.0;
		var delay, fb;
		delay = BufDelayL.ar(buf, (In.ar(in) * inputamp) + (LocalIn.ar(1)), delaytime) * amp;
		LocalOut.ar(delay * feedback);
		Out.ar(out, (delay * amp) );

	}).load(s);
	
	SynthDef.new(\in_hw, { arg in=0, out=0, amp=1.0;
		Out.ar(out, SoundIn.ar(in) * amp);
	}).load(s);
	
	SynthDef.new(\patch, { arg in=0, out=0, amp=1.0;
		Out.ar(out, In.ar(in) * amp);
	}).load(s);
	
	
	SynthDef.new(\in_pan, { arg in=0, out=0, amp=1.0, pan=0.0;
		Out.ar(out, Pan2.ar(In.ar(in) * amp, pan));
	}).load(s);
	
	
	SynthDef.new(\in_fb, { arg in=0, out=0, amp=1.0;
		Out.ar(out, InFeedback.ar(in) * amp);
	}).load(s);
	
	
	
	*/
	
	
	~vla_del_in_b = Bus.audio(s, 1);	
	~vla_del_in_s = Synth.new(\in_hw, [\in, 6, \out, ~vla_del_in_b.index]);
	~vla_del_out_b = Bus.audio(s, 1);
	
	~vla_del = Synth.new(\bufdelay_fb, [
		\buf, ~loop_buf.bufnum,
		\in, ~vla_del_in_b.index,
		\delaytime, 1.2 * 4.0,
		\out, ~vla_del_out_b.index;
	], ~vla_del_in_s, \addAfter);
	
	
	~vla_del_out_s = Synth.new(\in_pan, [\in, ~vla_del_out_b, \out, 0], ~vla_del, \addAfter);



	~vla_del.set(\delaytime, 1.2 * 68.0);



	~vla_del.set(\feedback, 1.0);
	~vla_del.set(\inputamp, 0.0);
	



	/*
	~vla_del.free;
	*/
	
nil }); //alloc sched	
	
}); // /alloc

/* free

~vla_del.free;
~loop_buf.free;
~vla_del_in_s.free;
~vla_del_out_s.free;
~vla_del_out_b.free;
~vla_del_in_b.free;
*/