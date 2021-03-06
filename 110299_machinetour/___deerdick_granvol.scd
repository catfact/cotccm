~dd = DeerDick.new;
~dd.start;

4.do({ arg i;
	~dd.spec.action_(("but"++i).asSymbol, {
		arg slot;
		("button " ++ i ++ " " ++ slot.value).postln;
	});
});

//s = Server.internal;
//s.boot;
s.waitForBoot { 
	Routine {	
		// group to hold control filter synths
		~smoothing_g = Group.new(s);
		// dictionary to reference control filter synths
		~smoothing_s = Dictionary.new;
		
		// basic up/down exponential lag
		SynthDef.new(\lagud, {
			arg io=0, lagup=0.005, lagdown=0.005;
			var sig;
			sig = In.kr(io);
			sig = LagUD.kr(sig, lagup, lagdown);
			ReplaceOut.kr(io, sig);
		}).store;
		
		0.01.wait; 
		
		// smoothing synths now have a convergence time equal to the dd's sampling period,
		// assuming defaults (5ms)
		
		// create busses and smoothing synths
		[\barre0, \barre1, \barre2, \barre3, \ant].do({
			arg key;
			~dd.spec.createBus(key, s);
			~smoothing_s.add(key -> 
				Synth.new(\lagud, [
					\io, ~dd.spec.at(key).bus.index
				], ~smoothing_g, \addToTail);
			);
		});
		
			
		0.1.wait;

		SynthDef.new(\chubVol, {arg chubBus, targetBus, invert=0.0;
			var chubIn, targetIn;
			chubIn = In.kr(chubBus);
			targetIn = In.ar(targetBus);
			chubIn = chubIn*(1.0 - invert) + (1.0 - chubIn)*invert;
			ReplaceOut.ar(targetBus, targetIn * chubIn);
		}).send(s);
		
		0.1.wait;
		
		~chub_vol_s = Array.fill(~ngrans, { |i|
			var key;
			key = i.switch(
				0, {\barre0},
				1, {\barre1},
				2, {\barre2},
				3, {\barre3}
			);
			Synth.new(\chubVol, [
				\chubBus, ~dd.spec.at(key).bus.index,
				\targetBus, ~gran_out_b[i].index,
				\invert, 0.0,
			], ~gran_out_s[i], \addAfter);
		});

	}.play;
	
};