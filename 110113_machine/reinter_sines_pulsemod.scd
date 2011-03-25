//Server.killAll

~ratios = 

[

3,1.875,1.421875,3.953125,7.703125,1.125,4.375,2.234375,6.109375,2.625,6.875,3.453125,4.125,1.328125,6.375,4.125,1.328125,2.625,6.875,3.453125,1.125,4.375,2.234375,6.109375,3,1.875,1.421875,3.953125,7.703125,3,1.875,1.421875,3.953125,7.703125,1.125,4.375,2.234375,6.109375,2.625,6.875,3.453125,4.125,1.328125,6.375,4.125,1.328125,2.625,6.875,3.453125,1.125,4.375,2.234375,6.109375,3,1.875,1.421875,3.953125,7.703125,3,1.875,1.421875,3.953125,7.703125,1.125,4.375,2.234375,6.109375,2.625,6.875,3.453125,4.125,1.328125,6.375,4.125,1.328125,2.625,6.875,3.453125,1.125,4.375,2.234375,6.109375,3,1.875,1.421875,3.953125,7.703125,3,1.875,1.421875,3.953125,7.703125,1.125,4.375,2.234375,6.109375,2.625,6.875,3.453125,4.125,1.328125,6.375,4.125,1.328125,2.625,6.875,3.453125,1.125,4.375,2.234375,6.109375,3,1.875,1.421875,3.953125,7.703125,3,1.875,1.421875,3.953125,7.703125,1.125,4.375,2.234375,6.109375,2.625,6.875,3.453125,4.125,1.328125,6.375,4.125,1.328125,2.625,6.875,3.453125,1.125,4.375,2.234375,6.109375,3,1.875,1.421875,3.953125,7.703125,3,1.875,1.421875,3.953125,7.703125,1.125,4.375,2.234375,6.109375,2.625,6.875,3.453125,4.125,1.328125,6.375,4.125,1.328125,2.625,6.875,3.453125,1.125,4.375,2.234375,6.109375,3,1.875,1.421875,3.953125,7.703125,3,1.875,1.421875,3.953125,7.703125,1.125,4.375,2.234375,6.109375,2.625,6.875,3.453125,4.125,1.328125,6.375,4.125,1.328125,2.625
];

/*
~ratios.size
16*12
*/

s = Server.local.waitForBoot { Routine {
	
	~gridw = 16;
	~gridh = 12;
	
	
	
	
	//~xratios = [3/4, 4/5, 8/9, 9/8, 5/4, 4/3];
	//~yratios = [7.0, 5.0, 3.0, 2.0];
	
	
	
	~basehz = 220;
	
	/*
	~rfunc = { arg msg;
		var amp;
//		if (msg[3] > 0.0000, {		 msg.postln; });
		amp = ((1.0 - msg[3]) * -12).dbamp;
		if (msg[3] < 0.0001, { amp = 0.0; });
		~sines[msg[1]][msg[2]].set(\amp, amp * 8.0 * (1.0 / (12 * 16)));
		
	};
	*/
	
	
	~rfunc = { arg msg;
		var amp;
	//	if (msg[3] > 0.0000, {		 msg.postln; });
		~sines[msg[1]][msg[2]].set(\amp, msg[3]);
		
	};
	

//~sines[15][0]
//~ratios[16]


//~rfunc = {};	


	~responder = OSCresponderNode(nil, '/grid/unit', { arg t, r, msg;
		~rfunc.value(msg);
	}).add;
	
	SynthDef.new(\sine, {arg amp=0.0, hz=100;
		(SinOsc.ar(hz) * amp).dup;
	}).send(s);

	
	
	SynthDef.new(\sine_pulsemod, {arg out=0, amp=0.0, hz=100, lfhz=0.25, modratio = 6/5, hzlag=0.5, pulsewidth=0.5;
		var pulse;
		pulse = LFPulse.kr(lfhz, 0, pulsewidth);
		hz = hz + (pulse * hz * modratio);
		//hz = Lag.kr(hz, hzlag);
		Out.ar(out, (SinOsc.ar(hz) * amp).dup);
	}).send(s);
	
	0.2.wait;

	~sine_g = Group.new(s);
	~sine_b = Bus.audio(s, 2);

	~sines = Array.fill(~gridw, { arg x; Array.fill(~gridh, { arg y;
		var ratio, hz;
		ratio = ~ratios[y + ( x * ~gridh)];
		hz = ratio * ~basehz;
		postln(hz);
		//Synth.new(\sine, [\hz, ~xratios[x] * ~yratios[y] * ~basehz], s);
		//Synth.new(\sine, [\hz, hz, \amp, 0.0], s);
		Synth.new(\sine_pulsemod, [\hz, hz, \amp, 0.0, \lfhz, ratio * 0.25], ~sine_g);
	})});
	
	/*
			SynthDef.new(\patch_limiter_pan, {arg in=0, out=0, pre=1.0, post=1.0, thresh=1.0, attack=0.01, release=0.1, pan=0.0;
			var input, limited;
			input = In.ar(in, 1) * pre;
			limited = Compander.ar(input, input, thresh, 1.0, 0.0, attack, release, post);
			ReplaceOut.ar(out, Pan2.ar(limited, pan));
		}).send(s);	
		
		0.1.wait;
		
		//------------------------------------------- LIMITER
		~out_limiter_patch_1 = Synth.new(\patch_limiter_pan, [
			\in, 0, \out, 0,
			\pre, 12.dbamp,
			\thresh, -6.dbamp,
			\post, 12.dbamp,
		], ~sine_g, \addAfter);
		
		~out_limiter_patch_2 = Synth.new(\patch_limiter_pan, [
			\in, 0, \out, 0,
			\pre, 12.dbamp,
			\thresh, -6.dbamp,
			\post, 12.dbamp,
			\pan, 1.0
		], ~sine_g, \addAfter);
		
		
		~out_limiter_patch_1.set(\pan, -1);
		
	*/
}.play; };