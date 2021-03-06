~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };


~nflt = 2;

Routine {

	~rlen = 30.0;
	~nl = 8;
	// record buffer
	~fltr_buf = Buffer.alloc(s, s.sampleRate * ~rlen, 1);
	// loop buffers (copies)
	~fltl_buf = Array.fill(~nl, { Buffer.alloc(s, s.sampleRate * ~rlen, 1) });

	s.sync;

	x.value("_defs.scd");

	/// normalized filter
	SynthDef.new(\normrlpf, {
		arg in=0, out=0, hz=20, rq=1.0, normlev=0.5, normmix=0.5, amp=0.5, amplag = 1.0, dur=1.0;
		var snd;
		amp = Lag.kr(amp, amplag);
		snd = In.ar(in);
		snd = (snd * 1-normmix) + (normmix * Normalizer.ar(snd, level:normlev, dur:dur) );
		snd = RLPF.ar(snd, hz, rq);
		Out.ar(out, snd * amp);
	}).send(s);
	s.sync;

	~hzb = Array.fill(~nflt, { Bus.control(s, 1); });
	~inb = Bus.audio(s, 1);
	~ins = Synth.new(\adc, [\in, 0, \out, ~inb.index]);

	s.sync;

	~fltb = Bus.audio(s, 1);
	~fltg = Group.new(~ins, \addAfter);
	//	~flto = { Out.ar(0, In.ar(~fltb.index).dup); }.play(target:~ins, addAction:\addAfter);
	~flto = Synth.new(\patch_pan, [\in, ~fltb.index, \out, 0], ~fltg, \addAfter);
	s.sync;

	~flt = Array.fill(~nflt, { 
		Synth.new(\normrlpf, [\in, ~inb.index, \out, ~fltb.index, \rq, 0.05, \hz, 20], ~fltg);
	});
	
	~nflt.do({ arg i;
		~hzb[i].set(20 * (i + 1));
		s.sync;
		~flt[i].map(\hz, ~hzb[i]);
	});

	~swps = Array.newClear(~nf);

	/// sweep function
	~swp = { arg n, target, dur; Routine{
		if(~swps[n].notNil, { ~swps[n].free; });
		s.sync;				
		~hzb[n].get({ arg hz; 
			hz.postln;
			~swps[n] =  { Out.kr(~hzb[n].index, Line.kr(hz.cpsmidi, target.cpsmidi, dur).midicps) }.play;
		});
	}.play; };

	/// record and stop-record functions
	~fltrin = 0;
	~nrecbuts = 0;
	~flt_recstart = {
		if(~fltrin == 0, { 
			~fltr = Synth.new(\rec, [\in, ~fltb.index, \buf, ~fltr_buf.bufnum], ~fltg, \addAfter);
		}, {
			~fltr = Synth.new(\rec, [\in, c.in_b.index + 1, \buf, ~fltr_buf.bufnum], c.ig, \addAfter);
		});
		~flt_rect = SystemClock.seconds;
		~nrecbuts = ~nrecbuts + 1;
	};
	
	
	~flt_recstop = { arg target;
		var dur;
		~nrecbuts = ~nrecbuts - 1;
		if(~nrecbuts == 0, { ~fltr.free; });
		dur = SystemClock.seconds - ~flt_rect;
		if(~fltrin == 1, {
			~fltr_buf.normalize(0.5);
			~fltr_buf.copyData(~fltl_buf[target], numSamples:(dur * s.sampleRate));
		});
	};


	//// playback at pitched ratio
	
}.play;

// spectral invertscr