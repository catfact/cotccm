~basepath = "/home/emb/sc/cotccm/120823_machine/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.local;

c = CfAudioContext.new(s, 2, { Routine {

	// input buffer:
	//	~bbuf = Buffer.read(s, "bbbcch.wav");
	~blen = 600;
	~bbuf = Buffer.alloc(s, s.sampleRate * ~blen, 1);
	s.sync;
	//	~bbuf.inspect;
	"channels: ".post; ~bbuf.numChannels.postln;
	"length: ".post; ~bbuf.duration.postln;	

	// fft buffer:
	~fftbuf = Buffer.alloc(s, 2048, 1);

	// source audio bus:
	~src_b = Bus.audio(s, 2);

	// analysis busss:
	~cent_b = Bus.control(s, 1);
	~flat_b = Bus.control(s, 1);
	~pitch_b = Bus.control(s, 1);
	~haspitch_b = Bus.control(s, 1);
	~amp_b = Bus.control(s, 1);

	// analysis synth:
	SynthDef.new(\analysis_all, {
		arg in, buf,
		out_flat, out_cent,
		out_pitch, out_haspitch,
		out_amp;

		var input, chain,
		flat, cent, pitch, amp, haspitch;
		
		input = In.ar(in);
		chain = FFT(buf, input);
		flat = SpecFlatness.kr(chain);
		cent = SpecCentroid.kr(chain);
		#pitch, haspitch = Pitch.kr(input, clar:1);
		amp = Amplitude.kr(input);
		
		Out.kr(out_flat, flat);
		Out.kr(out_cent, cent);
		Out.kr(out_pitch, pitch);
		Out.kr(out_haspitch, haspitch);
		Out.kr(out_amp, amp);
	}).send(s);

	s.sync;

	
	Synth.new(\analysis_all, [
		\in, ~src_b.index,
		\buf, ~fftbuf.bufnum,
		\out_flat, ~flat_b.index,
		\out_cent, ~cent_b.index,
		\out_pitch, ~pitch_b.index,
		\out_haspitch, ~haspitch_b.index,
		\out_amp, ~amp_b.index
	], target:c.xg, addAction:\addAfter
	);
	

	// play:
	//	Synth.new(\play_2, [\buf, ~bbuf.bufnum, \out, ~src_b.index], c.xg);


	//	record:
	~rec = c.recOnce(1, ~bbuf.bufnum);
	~blen.wait;

	bc_chop
	
}.play; });



