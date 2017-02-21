

~wraphz = { arg val, max=500.0;
	var ret = val;
	while( {ret > max}, {ret = ret * 0.5; });
	ret
};

~do_cluster = { arg n=8, stride=1, atk=4.0, dur=4.0, rel=8.0, amp=0.125, ioff=10;
	n.do({ arg i;
		var hz = ~wraphz.value(~analist_pitch[(i*stride)+ioff].pitch);
		hz.postln;
		
		{
			var ampenv = EnvGen.ar(
				Env.new([0, 1, 1, 0], [atk * (1.0 + 0.125.rand), dur, rel * (1.0 + 0.125.rand)]),
				doneAction:2
			);
			Out.ar( 0, amp / n * ampenv * Pan2.ar(SinOsc.ar(hz), 0.4.rand));
		}.play(s);
	});
};
