

s = Server.default;
s.options.memSize = 8192 * 8;
// s.boot;

s.waitForBoot { Routine {

	SynthDef.new(\patch, {arg in, out, amp=1.0, amplag=1.0;
		amp = Ramp.kr(amp, amplag);
		Out.ar(out, In.ar(in) * amp);
	}).send;
	
	
	SynthDef.new(\adc, {arg in, out, amp=1.0, amplag=1.0;
		amp = Ramp.kr(amp, amplag);
		Out.ar(out, SoundIn.ar(in) * amp);
	}).send;
	
		
	SynthDef.new(\fb_rlpf, {
		arg in=0, out=0,
			amp=0.125, hz=5000, rq=0.5,
			amplag=0.1, hzlag=0.1, rqlag=0.1;
			
		var sig;
		
		amp = Ramp.kr(amp, amplag);
		hz= Lag.kr(hz, hzlag);
		//rq = Ramp.kr(rq, rqlag);
		
		sig = InFeedback.ar(in, 1);
		sig = RLPF.ar(sig, hz, rq);
		
		Out.ar(out, sig * amp);
	}).send;
	
	s.sync;
	
	~ngrans = 4;
	
	// synth, input, and output groups
	~gran_g = Group.new(s);
	~gran_in_g = Group.before(~gran_g);
	~gran_out_g = Group.after(~gran_g);
	
	// input and output busses
	~gran_in_b = Array.fill(~ngrans, { Bus.audio(s, 1); });
	~gran_out_b = Array.fill(~ngrans, { Bus.audio(s, 1); });
	
	// input synths for L and R channels
	~gran_in0_s = Array.fill(~ngrans, { arg i; Synth.new(\adc, [\in, 0, \out, ~gran_in_b[i].index, \amp, 1.0, \amplag, 0.5], ~gran_in_g); });
	~gran_in1_s = Array.fill(~ngrans, { arg i; Synth.new(\adc, [\in, 1, \out, ~gran_in_b[i].index, \amp, 1.0, \amplag, 0.5], ~gran_in_g); });
	
	// output synths split even/odd
	// ~gran_out_s = Array.fill(~ngrans, { arg i; Synth.new(\patch, [\in, ~gran_out_b[i].index, \out, i % 2, \amp, 0.0], ~gran_out_g); });
	
	// output*2 synths sum to mono
	~gran_out_s = Array.fill(~ngrans, { arg i; var group;
		group = Group.tail(~gran_out_g);
		2.do({arg j;
			Synth.new(\patch, [\in, ~gran_out_b[i].index, \out, j, \amp, 0.0, \amplag, 0.5], group); 
		});
		group
	});
	
	// one grandel for each bus
	~gran = Array.fill (~ngrans, { arg i;
		Grandel.new(s, ~gran_in_b[i].index, ~gran_out_b[i].index, ~gran_g, \addToTail);
	});
	
	0.1.wait;
	

	// feedback synths
	~gran_fb_s = Array.fill(~ngrans, { arg i;
		Synth.new(\fb_rlpf, [
			\in, ~gran_out_b[i].index,
			\out, ~gran_in_b[(i+1) % ~ngrans].index,
			\amp, 0.0,
			\amplag, 4.0,
			\rqlag, i + 1,
			\hzlag, (i*2) + 1,
			\hz, 800 * (1.5 ** i),
			\rq, 1.0
		], ~in_g, \addBefore);
	});
	
	
	~gran_fb_s.do({arg syn;
		syn.set(\amp, -24.dbamp);
		syn.set(\rq, 1.0);
	});
	
	
	/// 
	
	s.sync;
	
	~gran[0].rate = 1.0;
	~gran[0].deltime = 8.0;
	~gran[0].dur = 6.0;
	~gran[0].wait = 1.0;
	~gran[0].attack = 0.5;
	~gran[0].release = 0.5;

	~gran[1].rate = 1.0;
	~gran[1].deltime = 16.0;
	~gran[1].dur = 8.0;
	~gran[1].wait = 2.0;
	~gran[1].attack = 1.0;
	~gran[1].release = 1.0;

	~gran[2].rate = 0.5;
	~gran[2].deltime = 12.0;
	~gran[2].dur = 4.0;
	~gran[2].wait = 0.5;
	~gran[2].attack = 0.5;
	~gran[2].release = 0.5;

	~gran[3].rate = 2.0;
	~gran[3].deltime = 12.0;
	~gran[3].dur = 4.0;
	~gran[3].wait = 0.25;
	~gran[3].attack = 0.25;
	~gran[3].release = 0.25;
	
//////////////// mpk
	~gran_inamp_cc = CCResponder(
		{	arg src, chan, num, val;
			//~gran_in0_s[num - 9].set(\amp, if(val > 0, {1.0}, {0.0}));
			//~gran_in1_s[num - 9].set(\amp, if(val > 0, {1.0}, {0.0}));
			val.postln;
			~gran[num-9].bufwr_s.run(val>0);
		},
		nil, // any source
		nil, // any channel
		{ |cc| (cc > 8) && (cc < 13) } // cc number 9 through 12
	);

	~gran_outamp_cc = CCResponder(
		{	arg src, chan, num, val;
			var amp = if(val > 0, { (-12 - ((127-val) / 127.0 * 24.0)).dbamp }, {0.0});
			amp.postln;
			~gran_out_s[num-1].set(\amp, amp);
		}, 
		nil, // any source
		nil, // any channel
		{ |cc| (cc > 0) && (cc < 5) } // cc number 1 through 4
	);
	
	~gran_fbamp_cc = CCResponder(
		{	arg src, chan, num, val;
			~gran_fb_s[num-5].set(\amp, if(val > 0, { (-6.0 - (val / 127.0 * 24.0)).dbamp }, {0.0}));
		}, 
		nil, // any source
		nil, // any channel
		{ |cc| (cc > 5) && (cc < 9) } // cc number 5 through 8
	);
	
	~gran_tap = Array.fill(~ngrans, { CfTapper.new; }); 
	~gran_tap_cc = CCResponder(
		{ 	arg src, chan, num, val;
			var time;
			~gran_tap[num-13].tap;
			time = ~gran_tap[num-13].time;
			if (val == 0, {
				~gran[num-13].deltime = time;
			});
			~gran[num-13].wait = time *0.25;
			~gran[num-13].dur = time;
		},
		nil, // any source
		nil, // any channel
		{ |cc| (cc > 12) && (cc < 17) } // cc number 5 through 8
	);
	
}.play; };	
