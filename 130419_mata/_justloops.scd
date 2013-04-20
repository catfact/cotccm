/*
~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.default;
s.options.memSize = 8192 * 64;
s.boot;
s.waitForBoot { Routine {
*/	
	~jl_numloops = 8;
	
	~jl_buflen = 60;
	~jl_bufs = Array.fill(~jl_numloops, { Buffer.alloc(s, s.sampleRate * ~jl_buflen, 1, completionMessage: { }) });
	
	SynthDef.new(\justloop_rec, {
		arg in=0, buf=0,
			reclevel=1.0, prelevel=0.0, offset=0.0, trig=1.0, loop=0, run=1,
			atk=0.01, rel=0.01, gate=1;
			
		RecordBuf.ar(SoundIn.ar(in, 1),
			bufnum: buf, 
			offset:0,
			recLevel:reclevel,
			preLevel:prelevel,
			run:run,
			loop:loop,
			trigger:trig
		);
	}).send(s);

	SynthDef.new(\justloop_play, {
		arg out=0, buf=0,
		pos=0.0, rate=1.0, loop=0,
		atk=0.01, dur=10.0, rel=0.01, gate=1, doneaction=2,
		looptime=2.0, level=0.63,
		ratelag=0.01,
		shift_ratio=0.5, shift_amp=0.0, shift_amplag=1.0, shift_window=0.125;
		
		var sig, amp, env, trig, shift;
		
		env = Env.asr(atk, 1.0, rel);
		amp = EnvGen.ar(env, gate, doneAction:doneaction);
		trig = Impulse.kr(1.0 / looptime);
		rate = Lag.kr(rate, ratelag);
		sig = PlayBuf.ar(1, buf, rate, trig, pos, loop:loop);
		
		shift_amp = Lag.kr(shift_amp, shift_amplag);
		shift = PitchShift.ar(sig, shift_window, shift_ratio);
		sig = sig + (shift * shift_amp);
		
		Out.ar(out, sig * amp * level);
	}).send(s);
	
	
	0.1.wait;
	
	
	~jl_rec_s = Array.newClear(~jl_numloops);
	~jl_play_s = Array.newClear(~jl_numloops);

	~jl_clear_flags = Array.fill(~jl_numloops, {true});
	~jl_taps = Array.fill(~jl_numloops, { CfTapper.new; });
	
	/*
	~post_cc = CCResponder({
		arg src, chan, num, val;
		[src, chan, num, val].postln;
	}, nil, nil, nil);
	
	~jl_pad_r = CCResponder({
		arg src, chan, num, val;
		var i = num-17;
		if (val > 0, {
			// press
			~jl_start_record.value(i);
		}, { 
			// lift
			~jl_stop_record.value(i);
		});
	}, nil, nil, {|num| (num>16) && (num<25) });
	
	~jl_knob_r = CCResponder({
		arg src, chan, num, val;
		var i = num-1;
		if (val ==0, { ~jl_clear.value(i); });
	}, nil, nil, {|num| (num>0) && (num<9) });

	*/
	
	~jl_start_record = {
		arg i;
		postln("jl_ start record " ++ i);
		~jl_rec_s[i] = Synth.new(\justloop_rec, [\buf, ~jl_bufs[i].bufnum, prelevel:1.0, \in, 0]);
		if(~jl_clear_flags[i], {
			~jl_taps[i].tap;
		});
	};
	
	~jl_rates = [1.0, 1.0, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25];
	
	~jl_stop_record = {
		arg i;
		postln("jl_ stop record " ++ i);
		~jl_rec_s[i].free;
		if(~jl_clear_flags[i], {
			~jl_taps[i].tap;
			~jl_clear_flags[i] = false;
		}, {
			
		});
	};
	
	~jl_clear = {
		arg i;
		~jl_bufs[i].zero;
		~jl_play_s[i].set(\gate, 0);
		~jl_clear_flags[i] = true;
	};

~jl_play = { arg i;
	~jl_play_s[i] = Synth.new(\justloop_play, [\buf, ~jl_bufs[i].bufnum, \looptime, ~jl_taps[i].time / ~jl_rates[i], \rate, ~jl_rates[i], \level, -12.dbamp, \out, 0]);
};

//}.play; }

/*
			~jl_bufs[0].normalize(0.25);



*/