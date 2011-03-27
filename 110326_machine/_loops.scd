~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.default;
s.options.memSize = 8192 * 64;
s.boot;
s.waitForBoot { Routine {
	
	~numloops = 4;
	
	~buflen = 300;
	~bufs = Array.fill(~numloops, { Buffer.alloc(s, s.sampleRate * ~buflen, 1, completionMessage: { }) });
	
	SynthDef.new(\rec_adc, {
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

	
	SynthDef.new(\rec, {
		arg in=0, buf=0,
			reclevel=1.0, prelevel=0.0, offset=0.0, trig=1.0, loop=0, run=1,
			atk=0.01, rel=0.01, gate=1;
			
		RecordBuf.ar(In.ar(in, 1),
			bufnum: buf, 
			offset:0,
			recLevel:reclevel,
			preLevel:prelevel,
			run:run,
			loop:loop,
			trigger:trig
		);
	}).send(s);


	SynthDef.new(\play_loop, {
		arg out=0, buf=0,
		pos=0.0, rate=1.0, loop=0,
		atk=0.01, dur=10.0, rel=0.01, gate=1, doneaction=2,
		looptime=2.0, level=0.63, levellag=1.0;

		var sig, amp, env, trig;

		level = Lag.kr(level, levellag);
		env = Env.asr(atk, 1.0, rel);
		amp = EnvGen.ar(env, gate, doneAction:doneaction);
		trig = Impulse.kr(1.0 / looptime);
		sig = PlayBuf.ar(1, buf, rate, trig, pos, loop:loop);
		Out.ar(out, sig * amp * level);
	}).send(s);
	
	0.1.wait;
	
	~rg = Group.new(s);
	
	~rec_s = Array.fill(~numloops);
	~play_s = Array.fill(~numloops);
	
	~loop_in_b = Bus.audio(s, 1);
	~loop_in_s = Synth.new(\adc_patch, [\in, 1, \out, ~loop_in_b.index], ~rg, \addBefore);

	~loop_clear_flags = Array.fill(~numloops, {true});
	~loop_taps = Array.fill(~numloops, { CfTapper.new; });
	
	~post_cc = CCResponder({
		arg src, chan, num, val;
		[src, chan, num, val].postln;
	}, nil, nil, nil);
	
	~loop_pad_r = CCResponder({
		arg src, chan, num, val;
		var i = num-9;
		if (val > 0, {
			// press
			~start_record.value(i);
		}, { 
			// lift
			~stop_record.value(i);
		});
	}, nil, nil, {|num| (num>8) && (num<13) });
	
	~loop_knob_r = CCResponder({
		arg src, chan, num, val;
		var i = num-1;
		if (val ==0, {
			~loop_clear.value(i);
		} , {
			~play_s[i].set(\level, ((1 - (val/ 127)) * -30).dbamp);
		});
	}, nil, nil, {|num| (num>0) && (num<5) });

	
	~start_record = {
		arg i;
		postln("start record " ++ i);
		~rec_s[i] = Synth.new(\rec, [\buf, ~bufs[i].bufnum, prelevel:1.0, \in, ~loop_in_b.index], ~rg);		if(~loop_clear_flags[i], {
			~loop_taps[i].tap;
		});
	};
	
	~rates = [1.0, 1.0, 0.5, 0.25];
	
	~stop_record = {
		arg i;
		postln("stop record " ++ i);
		~rec_s[i].free;
		if(~loop_clear_flags[i], {
			~loop_taps[i].tap;
			~play_s[i] = Synth.new(\play_loop, [\buf, ~bufs[i].bufnum, \looptime, ~loop_taps[i].time / ~rates[i], \rate, ~rates[i], \out, 0]);
			~loop_clear_flags[i] = false;
		}, {
			
		});
	};
	
	~loop_clear = {
		arg i;
		~bufs[i].zero;
		~play_s[i].set(\gate, 0);
		~loop_clear_flags[i] = true;
	};
	
}.play; }
