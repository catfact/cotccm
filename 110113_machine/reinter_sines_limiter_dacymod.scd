//Server.killAll

~ratios = 

[
3,15,5.6875,15.8125,1.92578125,9,2.1875,8.9375,1.52734375,1.3125,3.4375,13.8125,2.0625,5.3125,3.1875,2.0625,5.3125,1.3125,3.4375,13.8125,9,2.1875,8.9375,1.52734375,3,15,5.6875,15.8125,1.92578125,3,15,5.6875,15.8125,1.92578125,9,2.1875,8.9375,1.52734375,1.3125,3.4375,13.8125,2.0625,5.3125,3.1875,2.0625,5.3125,1.3125,3.4375,13.8125,9,2.1875,8.9375,1.52734375,3,15,5.6875,15.8125,1.92578125,3,15,5.6875,15.8125,1.92578125,9,2.1875,8.9375,1.52734375,1.3125,3.4375,13.8125,2.0625,5.3125,3.1875,2.0625,5.3125,1.3125,3.4375,13.8125,9,2.1875,8.9375,1.52734375,3,15,5.6875,15.8125,1.92578125,3,15,5.6875,15.8125,1.92578125,9,2.1875,8.9375,1.52734375,1.3125,3.4375,13.8125,2.0625,5.3125,3.1875,2.0625,5.3125,1.3125,3.4375,13.8125,9,2.1875,8.9375,1.52734375,3,15,5.6875,15.8125,1.92578125,3,15,5.6875,15.8125,1.92578125,9,2.1875,8.9375,1.52734375,1.3125,3.4375,13.8125,2.0625,5.3125,3.1875,2.0625,5.3125,1.3125,3.4375,13.8125,9,2.1875,8.9375,1.52734375,3,15,5.6875,15.8125,1.92578125,3,15,5.6875,15.8125,1.92578125,9,2.1875,8.9375,1.52734375,1.3125,3.4375,13.8125,2.0625,5.3125,3.1875,2.0625,5.3125,1.3125,3.4375,13.8125,9,2.1875,8.9375,1.52734375,3,15,5.6875,15.8125,1.92578125,3,15,5.6875,15.8125,1.92578125,9,2.1875,8.9375,1.52734375,1.3125,3.4375,13.8125,2.0625,5.3125,3.1875,2.0625,5.3125,1.312
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
	
	
	
	~basehz = 110;
	
	/*
	~rfunc = { arg msg;
		var amp;
//		if (msg[3] > 0.0000, {		 msg.postln; });
		amp = ((1.0 - msg[3]) * -12).dbamp;
		if (msg[3] < 0.0001, { amp = 0.0; });
		~sines[msg[1]][msg[2]].set(\amp, amp * 8.0 * (1.0 / (12 * 16)));
		
	};
	*/
	
//~sines[15][0]
//~ratios[16]


//~rfunc = {};	


	
	SynthDef.new(\sine, {arg out=0, amp=0.0, hz=100, ampattack=0.001, ampdecay=0.7;
		var ampenv = Decay2.kr(amp, 2.0, 1.0);
		ampenv = (ampenv * 8.0).min(1.0);
		ampdecay = ampdecay - (ampdecay * ampenv * 0.9);
		amp = Decay2.kr(amp, ampattack, ampdecay);
		
		Out.ar(out, (SinOsc.ar(hz) * amp * 0.5));
	}).send(s);

		0.2.wait;

	~sine_g = Group.new(s);
	~sine_b = Bus.audio(s, 2);

	~sines = Array.fill(~gridw, { arg x; Array.fill(~gridh, { arg y;
		var ratio, hz;
		postln([x, y]);
		ratio = ~ratios[y + ( x * ~gridh)];
		hz = ratio * ~basehz;
		postln(hz);
		Synth.new(\sine, [\hz, hz, \amp, 0.0, \out, ~sine_b.index], ~sine_g);
		//Synth.new(\sine_pulsemod, [\hz, hz, \amp, 0.0, \lfhz, ratio * 0.25], ~sine_g);
	})});
	
	
			SynthDef.new(\patch_limiter_pan, {arg in=0, out=0, pre=1.0, post=1.0, thresh=1.0, attack=0.01, release=0.1, pan=0.0;
			var input, limited;
			input = In.ar(in, 1) * pre;
			limited = Compander.ar(input, input, thresh, 1.0, 0.0, attack, release, post);
			Out.ar(out, Pan2.ar(limited, pan));
		}).send(s);	
		
		0.1.wait;
		
		//------------------------------------------- LIMITER
		~out_limiter_patch_1 = Synth.new(\patch_limiter_pan, [
			\in, ~sine_b.index, \out, 0,
			\pre, 12.dbamp,
			\thresh, -6.dbamp,
			\post, 12.dbamp,
		], ~sine_g, \addAfter);
		
		~out_limiter_patch_2 = Synth.new(\patch_limiter_pan, [
			\in, ~sine_b.index, \out, 0,
			\pre, 12.dbamp,
			\thresh, -6.dbamp,
			\post, 12.dbamp,
			\pan, 1.0
		], ~sine_g, \addAfter);
		
		
		~out_limiter_patch_1.set(\pan, -1);
	
		~out_limiter_patch_1.set(\post, -12.dbamp);
		~out_limiter_patch_2.set(\post, -12.dbamp);
	
	
	
	"wtf".postln;
	
	~rfunc = { arg msg;
		var amp;
		if (msg[3] > 0.0000, {		 msg.postln; });
		~sines[msg[1]][msg[2]].set(\amp, msg[3] * 0.125);
	};

	
	~responder = OSCresponderNode(nil, '/grid/unit', { arg t, r, msg;
		~rfunc.value(msg);
	}).add;
	
}.play; };