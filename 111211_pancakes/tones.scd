
~hz_b = Bus.control(s, 1);

~hz_s = SynthDef.new(\freq, {arg in=0, out=0; // target bus should have two channels
	var sig;
	sig = In.ar(in, 1);
	Out.kr(out, Pitch.kr(sig));
}).play(~gr_g, [\in, ~gr_b.index, \out, ~hz_b.index], \addAfter);


~hz = List.new;

~hz_store = {
	~hz_b.get({arg val;
		~hz.add(val);
	});
};


~toneseconds = 120;

~hz_play = {
	~hz.do({ arg hz;
		{
			var atk, dec, ampenv, curve, amp;
			
			while( { hz > 880 }, { hz = hz * 0.5; });
			atk  = ~toneseconds.rand.max(16.0);
			dec = (~toneseconds - atk).rand.max(14.0);
			curve = 0.5.rand2;
			ampenv = Env.new([0.0, 1.0, 1.0, 0.0], [atk, ~toneseconds - atk - dec, dec], curve);
			amp = EnvGen.ar(ampenv, gate:1, doneAction:2);
			Out.ar(0, Pan2.ar(SinOsc.ar(hz) * amp / ~hz.size * 0.67), 1.0.rand2);
		}.play(s);
	});	
};