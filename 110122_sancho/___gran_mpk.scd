

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
	
	~ngrans = 8;
	
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
	~gran[1].deltime = 8.0;
	~gran[0].dur = 6.0;
	~gran[0].wait = 1.0;
	~gran[0].attack = 0.5;
	~gran[0].release = 0.5;

	~gran[1].rate = 1.0;
	~gran[0].deltime = 16.0;
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
	
	/* //////////////// monome and hid
	
	~gran_in_switch = Array.fill(8, {0});
	~gran_in_switchtap = Array.fill(8, {CfTapper.new; });
	
	~gran_out_switch = Array.fill(8, {0});
	~gran_out_switchtap = Array.fill(8, {CfTapper.new; });
	*/
	
	
	
	/*
	~gran[4].rate = 2.0;
	~gran[4].dur = 8.0;
	~gran[4].wait = 1.5;
	~gran[4].attack = 0.25;
	~gran[4].release = 0.25;
	~gran[4].deltime = 2.0;

	~gran[5].rate = 2.0;
	~gran[5].dur = 3.0;
	~gran[5].wait = 0.25;
	~gran[5].attack = 0.25;
	~gran[5].release = 0.25;
	~gran[5].deltime = 0.5;
	
	~gran[6].rate = 0.25;
	~gran[6].dur = 2.0;
	~gran[6].wait = 0.25;
	~gran[6].attack = 0.25;
	~gran[6].release = 0.25;
	~gran[6].deltime = 2.5;

	~gran[7].rate = 4.0;
	~gran[7].dur = 4.0;
	~gran[7].wait = 0.25;
	~gran[7].attack = 0.25;
	~gran[7].release = 0.25;
	~gran[7].deltime = 3.0;
*/



	
	/* ////////////// monome
	~monome.pressFunctions.add('bottom2'->{ arg col, row;
		if (row==6, {
			~gran_in_switchtap[col].tap;
		});
		if (row==7, {
			~gran_out_switchtap[col].tap;
		});
	});
	
	~monome.liftFunctions.add('bottom2'->{ arg col, row;
		
		if(row==6, {
			if (~gran_in_switch[col] > 0, {
				~gran_in_switchtap[col].tap;
				~gran_in_s[col].set(\amplag, ~gran_in_switchtap[col].time);
				~gran_in_s[col].set(\amp, 0.0);
				~gran_in_switch[col] = 0;
				~monome.led(col, 6, 0);
			}, {
				~gran_in_switchtap[col].tap;
				~gran_in_s[col].set(\amplag, ~gran_in_switchtap[col].time);
				~gran_in_s[col].set(\amp, 1.0);
				~gran_in_switch[col] = 1;
				~monome.led(col, 6, 1);
			});
		});
		
		if(row==7, {
			if (~gran_out_switch[col] > 0, {
				~gran_out_switchtap[col].tap;
				~gran_out_s[col].set(\amplag, ~gran_out_switchtap[col].time);
				~gran_out_s[col].set(\amp, 0.0);
				~gran_out_switch[col] = 0;
				~monome.led(col, 7, 0);
			}, {
				~gran_out_switchtap[col].tap;
				~gran_out_s[col].set(\amplag, ~gran_out_switchtap[col].time);
				~gran_out_s[col].set(\amp, 0.25);
				~gran_out_switch[col] = 1;
				~monome.led(col, 7, 1);
			});
		});


		
	});
	*/
	
	
	/* ///////// hid
	Routine {
	~gw = SCWindow.new("_g");
	~gw.front;
	
	~switch = 0;
	~switchtap = CfTapper.new;
	
	~switch_func = { arg val; 
		"footswitch".postln;
		if(val > 0, {
			postln("press");
			~switchtap.tap;
		}, {
			postln("lift");
			if(~switch > 0, {
				postln("turning off");
				~switchtap.tap;
				~out_g.set(\amplag, ~switchtap.time);
				~out_g.set(\amp, 0.0);
				~switch = 0;
				{ ~gw.view.background = Color.black; }.defer;
			}, {
				postln("turning on");
				~switchtap.tap;
				~out_g.set(\amplag, ~switchtap.time);
				~out_g.set(\amp, 0.1);
				~switch = 1;
				{ ~gw.view.background = Color.red; }.defer;
			});
		});
	};

	}.play(AppClock);
	//////
	*/
}.play; };	


/*
~gran_in_b[0].scope;
~gran_out_b[0].scope;
*/