Routine {

	~jl_num = 4;

	~jl_in_b = Bus.audio;
	~jl_patch = Array.with(
		Synth.new(\patch, [\in, c.in_b.index, \out, ~jl_in_b.index], c.ig, \addToTail),
		Synth.new(\patch, [\in, c.in_b.index + 1, \out, ~jl_in_b.index], c.ig, \addToTail),
		Synth.new(\patch, [\in, c.in_b.index + 4, \out, ~jl_in_b.index], c.ig, \addToTail)
	);
	~jl_buflen = 300;
	~jl_bufs = Array.fill(~jl_num, { Buffer.alloc(s, s.sampleRate * ~jl_buflen, 1, completionMessage: { }) });
	
	~jl_b = Bus.audio(s, 1);
	~jl_out_s = Synth.new(\pan, [\in, ~jl_b.index, \out, c.out_b.index], c.og, \addToHead);
	
	SynthDef.new(\justloop_rec, {
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

	SynthDef.new(\justloop_play, {
		arg out=0, buf=0,
		pos=0.0, rate=1.0, loop=0,
		atk=1.0, dur=10.0, rel=2.0, gate=1, doneaction=2,
		looptime=2.0, level=0.63,
		ratelag=0.01,
		shift_ratio=0.5, shift_amp=0.0, shift_amplag=1.0, shift_window=0.125,
		dry_amp = 1.0;
		
		var sig, amp, env, trig, shift;
		
		env = Env.asr(atk, 1.0, rel);
		amp = EnvGen.ar(env, gate, doneAction:doneaction);
		trig = Impulse.kr(1.0 / looptime);
		rate = Lag.kr(rate, ratelag);
		sig = PlayBuf.ar(1, buf, rate, trig, pos, loop:loop);
		
		shift_amp = Lag.kr(shift_amp, shift_amplag);
		shift = PitchShift.ar(sig, shift_window, shift_ratio);
		sig = (sig * dry_amp) + (shift * shift_amp);
		
		Out.ar(out, sig * amp * level);
	}).send(s);
	
	
	0.1.wait;
	
	
	~jl_rec_s = Array.newClear(~jl_num);
	~jl_play_s = Array.newClear(~jl_num);

	~jl_clear_flags = Array.fill(~jl_num, {true});
	~jl_taps = Array.fill(~jl_num, { CfTapper.new; });
	
	
	~jl_start_record = {
		arg i;
		postln("jl_ start record " ++ i);
		~jl_rec_s[i] = Synth.new(\justloop_rec, [
			\buf, ~jl_bufs[i].bufnum,
			prelevel:1.0,
			\in, ~jl_in_b.index
			], c.ig, \addAfter);
		if(~jl_clear_flags[i], {
		~jl_taps[i].tap;
		});
	};
	
	~jl_rates = [1.0, 1.0, 1.0, 1.0];
	
	~jl_stop_record = {
		arg i;
		postln("jl_ stop record " ++ i);
		if(~jl_rec_s[i].isRunning, { ~jl_rec_s[i].free; });
		if(~jl_clear_flags[i], {
			~jl_taps[i].tap;
			~jl_play_s[i] = Synth.new(\justloop_play, [
				\buf, ~jl_bufs[i].bufnum, 
				\looptime, ~jl_taps[i].time / ~jl_rates[i], 
				\rate, ~jl_rates[i], 
				\level, -4.dbamp, 
				\out, ~jl_b.index]
			);
			~jl_clear_flags[i] = false;
		}, {
			
		});
	};
	
	~jl_clear = {
		arg i;
//		~jl_bufs[i].zero;
		~jl_play_s[i].set(\gate, 0);
		~jl_clear_flags[i] = true;
	};
	
	
	///// controls
	~jlstate = Array.fill(~jl_num, { 0 });
	~jli = 0;
	
	~but_func[2] = { arg state;
		if(state, {
			~jli = (~jli + 1) % ~jl_num;
		});
	};
	
	~but_func[0] = { arg state;
		("loop button state: " ++ state ++ " , index: " ++ ~jli ++ ", loopstate: " ++ ~jlstate).postln;
		if(state, {
			~jlstate[~jli].switch(
			0, { 
				~jl_start_record.value(~jli);
				~jlstate[~jli] = 1;
				~led0_on=0.2; ~led0_off=0.05; ~led0_r.next;
			},
			1, {
				~jl_stop_record.value(~jli);
				~jlstate[~jli] = 2;
				~led1_on=0.2; ~led1_off=0.05; ~led1_r.next;
				~led0_on=0.02; ~led0_off=1.5; ~led0_r.next;
			},
			2, {			
				~jl_clear.value(~jli);
				~jlstate[~jli] = 0;
				~led1_on=0.02; ~led1_off=1.5; ~led1_r.next;
				~led0_on=0.02; ~led0_off=1.5; ~led0_r.next;
			}
			);
		});
	};
	
}.play;
