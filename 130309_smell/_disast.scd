Routine {	// god dammit
		x.value("lion_defs.scd");
		s.sync;
		x.value("defs.scd");
		s.sync;
		x.value("_defs.scd");
		s.sync;
		x.value("def.scd");


~norm_buf = Buffer.alloc(s, 16 * 1.2 * s.sampleRate, 1);
s.sync;


~rec_norm_s = Synth.new(\norm_rec, [\input, 0, \buf, ~norm_buf.bufnum; ]);
SystemClock.sched(~norm_buf.duration + 0.01, { ~rec_norm_s.free; nil });



	~gvb = Bus.audio(s, 2);
	~god_vox = Synth.new(\god_vox, [\in, 0, \gate_thresh, -42.dbamp, \amp, 8.dbamp]);
	~god_vox.set(\amp, 4.dbamp);
	~god_vox.set(\delaydc, 0.1);
	~god_vox.set(\delaytime, 0.2);
	~god_vox.set(\out, ~gvb.index);
	~god_vod_out_s = Synth.new(\patch_s, [\in, ~gvb.index, \out, 0], ~god_vox, \addAfter);




z = Synth.new(\buf_ringz_lpf_env, [
\buf, ~norm_buf.bufnum ,
	//	\loop, 1
], s);

z.set(\amp, 0.5);
z.set(\rate, 2 ** -3);

~zhz = 1.0;
~zrate = 0.125;
~zpitch = 110;

y = Synth.new(\buf_ringz_lpf_env, [
	\buf, ~norm_buf.bufnum,
	//	\loop, 1
], s);



y.set(\amp, 0.5);
y.set(\rate, 2 ** -3);
y.set(\pulsehz, 1.0);

~yhz = 2.0;
~yrate = 0.125;
~ypitch = 110;

	~beet_t = 60/55;
//	~beet_t = 0.3 * 0.0;
	~beet_rbase = 1.0;
	~beet_dur_base = 0.25;
	~beet_level = -6.dbamp;

	~beet_dur_seq = Pseq([
		1, 1, 2, 1
		//		2, 3, 2, 2, 3, 
		//		2, 2, 3, 2, 2, 3, 2,
		//		2, 3, 2, 2, 3, 2, 4, 3, 1, 
		//		2, 3, 2, 2, 3, 2
	], inf).asStream;

	~beet_rate_seq = Pseq([
		1, 2, 1
		//		1, 2, 1, 2, 3, 2, 1, 2, 1
		//		1, 2, 4, 1, 2, 4, 1, 2, 4, 1, 3, 8, 
		//		1, 2, 4, 1, 2, 4, 1, 4, 2,
		//		1, 2, 4, 1, 2 //, 4, 1, 4, 2,
		//		//	1, 2, 4, 1, 2, 4, 1
	], inf).asStream;


	~beet_ratio_seq = Pseq([
		1, 2, 1, 1, 2, 1

	], inf).asStream;



	~beet_r = Routine {
		var dur, rate, io, hz, rq, ratio, pos, trigrate;
		inf.do({ arg i;
			dur = ~beet_dur_seq.next * ~beet_t * ~beet_dur_base;
			rate = ~beet_rate_seq.next * ~beet_rbase / ~beet_t;
			//			io = ~beet_io_seq.next * -32.dbamp;
			ratio = ~beet_ratio_seq.next * ~beet_rbase;
			//ratio =  (((i*3) % 2) + 1) + (((i * 5) % 4) * 2) * ~beet_rbase;
			//			hz = 220 * 4/5 * ratio;
			rq = (i%4) * 0.02 + 0.07;
			pos = ~beet_t * (i % 4);
			//			pos = ~beet_t * ((i*7) % 3) * 0.125;
			[i, ratio, rate, io, rq, pos].postln;
			if( (i % 2) > 0, {
				//				z.set(\rate, ratio * ~zrate);
				z.set(\startpos, pos);
				z.set(\pulsehz, rate * ~zhz);
				z.set(\envdecay, dur * 4.0);
				z.set(\ringdecay, rq / 256);
				z.set(\ringhz, ~zpitch * ratio);
				z.set(\lpfhz, ~zpitch * ratio);
				z.set(\trig, 0);
				z.set(\trig, 1);
			}, { 
				//				y.set(\rate, ratio * ~yrate);
				y.set(\startpos, pos);
				y.set(\pulsehz, rate * ~yhz);
				y.set(\envdecay, dur * 4.0);
				y.set(\ringdecay, rq / 256);
				y.set(\ringhz, ~ypitch * ratio);
				y.set(\lpfhz,  ~ypitch * ratio);
				y.set(\trig, 0);
				y.set(\trig, 1);
			});
			//	dur.postln;
			dur.wait;
		});
	}.play;


//z.free;
}.play;




/*



*/