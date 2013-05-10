c = CfAudioContext.new(s, 2, {
Routine {

	10.wait;

	//	x.value("killgrains.scd");
	// x.value("killsynth.scd");
	
	~vox_b = Bus.audio(s, 2);
	~vla_b = Bus.audio(s, 2);

	SynthDef.new(\patch_2, {arg in=0, out=0, amp=1.0;
		Out.ar(out, In.ar(in, 2) * amp);
	}).send(s);
		
	s.sync;
	
	~vox_out_s = Synth.new(\patch_2, [\in, ~vox_b, \out, c.out_b], c.og, \addBefore);
	~vla_out_s = Synth.new(\patch_2, [\in, ~vla_b, \out, c.out_b], c.og, \addBefore);

	SynthDef.new(\vladown, {
		arg in=1, out=0, amp=0.0625,
		prelpfhz = 1000,
		postlpfhz = 1000,
		pretan = 1.0,
		posttan = 1.0,
		del = 0.25, 
		fb = 0.0625,
		octdown=1.0,
		oct2down=0.5;

		var sig, delsig;

		sig = In.ar(in);
		
		delsig = DelayN.ar(sig, 1.0, del) + (LocalIn.ar(1) * fb);
		LocalOut.ar(delsig);
		
		sig = sig + delsig;

		sig = LPF.ar(sig, prelpfhz);
		sig = sig + (sig.tanh * pretan);

		sig = sig + (PitchShift.ar(sig, 0.5, 0.5) * octdown)
		+ (PitchShift.ar(sig, 0.25, 0.25) * oct2down);
		
		sig = sig + (sig.tanh * posttan);
		sig = LPF.ar(sig, postlpfhz);
		//			x.value("analysis.scd");
		Out.ar(out, Mix.new(sig).dup * amp);
		
	}).send(s);

	s.sync;

	~vladown_s = Synth.new(\vladown, [
		\in, c.in_b.index + 1,
		\out, ~vla_b.index
	], c.ig, \addAfter);

	~vladown_s.set(\postlpfhz, 2000);

	~vladown_s.set(\amp, -30.dbamp);

	SynthDef.new(\comp_rev, {
		arg in=1, out=0, amp=1.0,
		verb_mix=0.24, verb_room=0.8, verb_damp=1.0,
		delaydc = 0.002,
		delaytime = 0.1,
		delaylpf = 1200,
		delayamp = 0.4,
		gate_thresh = 0.00001,
		gate_slope = 10.0,
		gate_clamp = 0.004, 
		gate_release = 0.05,
		comp_thresh = 0.5,
		comp_slope = 0.25,
		comp_clamp = 0.003,
		comp_release = 0.1,
		fb = 0.5;

		var input, gate, comp, eq, del, verb;
		
		input = In.ar(in, 2);
		
		gate = Compander.ar(input, input, gate_thresh, gate_slope, 1.0, gate_clamp, gate_release);
		comp = Compander.ar(gate, input, comp_thresh, 1.0, comp_slope, comp_clamp, comp_release);
		//	comp = Compander.ar(input, input, comp_thresh, 1.0, comp_slope, comp_clamp, comp_release);

		del = DelayL.ar(comp, 1.0, delaytime) + (LocalIn.ar(2) * fb);
		LocalOut.ar(del);
		del = LPF.ar((del + DC.ar(delaydc)).softclip, delaylpf) * delayamp;

		verb = FreeVerb.ar(comp + del, verb_mix, verb_room, verb_damp);
		//	verb = FreeVerb.ar(input, verb_mix, verb_room, verb_damp);
		//	verb = FreeVerb.ar(gate, verb_mix, verb_room, verb_damp);	
		Out.ar(out, verb * amp);
	}).send(s);

 
	
	SynthDef.new(\bufdelay_shift_fb_2, {
		arg in=0, 
		out=0,
		buf=0,
		amp = 1.0,
		inputamp = 1.0,
		delaytime= 1.0,
		feedback = 0.0,
		rate = 2.0,
		windowsize=0.5;

		var sig, delay, fb;
		sig = In.ar(in, 2);
		sig = Mix.new(sig + PitchShift.ar(sig, 0.5, rate));
		delay = BufDelayL.ar(buf, (sig * inputamp) + (LocalIn.ar(2)), delaytime) * amp;
		LocalOut.ar(delay * feedback);

		Out.ar(out, Mix.new(delay * amp));
	}).send(s);

	s.sync;
				

	/*
	~gv = Synth.new(\god_vox, [\in, 0], s);
	~gv.set(\amp, -12.dbamp);
	~gv.set(\verb_mix, 0.0);
	*/

	
	~vla_compr_s = Synth.new(\comp_rev, [\in, ~vla_b, \out, ~vla_b, \verb_mix, 0.0, \amp, -24.dbamp], c.xg);
	~vox_compr_s = Synth.new(\comp_rev, [\in, c.in_b, \out, ~vox_b, \verb_mix, 0.0, \amp, -12.dbamp], c.ig, \addAfter);

	~vox_delt_b = Bus.control(s, 1);
	~vox_delt_b.set(0.1);
	~vox_fb_b = Bus.control(s, 1);
	~vox_fb_b.set(0.0);
	~vox_delamp_b = Bus.control(s, 1);
	~vox_delamp_b.set(0.0);
	
	~vox_compr_s.map(\delaytime, ~vox_delt_b);
	~vox_compr_s.map(\delayamp, ~vox_delamp_b);
	~vox_compr_s.map(\fb, ~vox_fb_b);
		~vox_delt_b.get({ arg v; v.postln; });

	~vla_delt = 15.216253995895;
	~vla_delbuf = Buffer.alloc(s, s.sampleRate * 20.0, 2);

	~vox_delamp_line = { Out.kr(~vox_delamp_b.index, Line.kr(0.1, 1.0, 120); ) }.play(s); 

	s.sync;
	
	~vla_longdel = Synth.new(\bufdelay_shift_fb_2, [
		\in, ~vla_b, 
		\out, c.out_b,
		\buf, ~vla_delbuf,
		\amp, 0.0,
		\delaytime, ~vla_delt,
		\fb, 0.75,
	], c.xg);

	~vla_delamp_b = Bus.control(s, 1);
	~vla_longdel.map(\amp, ~vla_delamp_b);
	~vla_delamp_b.set(0.0);

	~start = SystemClock.seconds;

	~clockr = Routine { inf.do {
		(SystemClock.seconds - ~start).postln;
		10.wait;
	} }.play;
	

	/*
	120.wait;
	~vla_longdel_amp_line = { Out.kr(~vla_delamp_b.index, Line.kr(0.1, 1.0, 240); ) }.play(s);

	~vox_delt_line = { Out.kr(~vox_delt_b.index, Line.kr(0.1, 0.5, 120.0); ) }.play(s); 

	~vox_fb_line = { Out.kr(~vox_fb_b.index, Line.kr(0.1, 0.85, 120); ) }.play(s); 
	*/
	// test:
	~vla_longdel_amp_line = { Out.kr(~vla_delamp_b.index, Line.kr(0.1, 1.0, 24); ) }.play(s);

	~vox_delt_line = { Out.kr(~vox_delt_b.index, Line.kr(0.1, 0.5, 12.0); ) }.play(s); 

	~vox_fb_line = { Out.kr(~vox_fb_b.index, Line.kr(0.1, 0.85, 12); ) }.play(s); 


}.play
 });