~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };


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
		arg in=0, out=0, hz=110, rq=1.0, normlev=0.5, normmix=0.5, amp=0.5, dur=1.0;
		var snd;
		snd = In.ar(in);
		snd = (snd * 1-normmix) + (normmix * Normalizer.ar(snd, level:normlev, dur:dur) );
		snd = RLPF.ar(snd, hz, rq);
		Out.ar(out, snd * amp);
	}).send(s);
	s.sync;

	~hzb = Bus.control(s, 1);
	~inb = Bus.audio(s, 1);
	~ins = Synth.new(\adc, [\in, 0, \out, ~inb.index]);
	s.sync;

	~fltb = Bus.audio(s, 1);
	//	~flto = { Out.ar(0, In.ar(~fltb.index).dup); }.play(target:~ins, addAction:\addAfter);
	~flto = Synth.new(\patch_pan, [\in, ~fltb.index, \out, 0], ~ins, \addAfter);
	s.sync;

	~flt = Synth.new(\normrlpf, [\in, ~inb.index, \out, ~fltb.index, \rq, 0.05, \hz, 20], ~flto, \addBefore);
	~hzb.set(20);
	s.sync;
	~flt.map(\hz, ~hzb);

	/// sweep function
	~swp = { arg target, dur; Routine{
		~swps.free;
		s.sync;				
		~hzb.get({ arg hz; 
			hz.postln;
			~swps =  { Out.kr(~hzb.index, Line.kr(hz.cpsmidi, target.cpsmidi, dur).midicps) }.play;
		});
	}.play; };
	/// record and stop-record functions
	
	~flt_recstart = {
		~fltr = Synth.new(\rec, [\in, ~fltb.index, \buf, ~fltr_buf.bufnum], ~flt, \addAfter);
		~flt_rect = SystemClock.seconds;
	};
	
	
	~flt_recstop = { arg target;
		var dur;
		~fltr.free;
		dur = SystemClock.seconds - ~flt_rect;
		~fltr_buf.copyData(~fltl_buf[target], numSamples:(dur * s.sampleRate));
	};

	
	//// playback at pitched ratio
	
}.play;

// spectral invert