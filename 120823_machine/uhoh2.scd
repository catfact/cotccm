~jl_play_s[0] = Synth.new(\justloop_play, [
	\buf, ~jl_bufs[0].bufnum, 
	\looptime, 120.0 * 12,
	\rate, -1/12, 
	\level, -4.dbamp, 
	\out, ~jl_b.index]
);

~jl_play_s[0].set(\level, 1.0);

~jl_play_s[6]


~col.invert

~setcol.value(Color.new(0.7, 0.5, 0.1), 100, 0.01, 0.3);
~setcol2.value(Color.new(0.7, 0.2, 0.5), 100, 0.01, 0.3);


~jl_play_s.do({ arg syn; syn.set(\rel, 240); });

8.do({ arg i; ~jl_clear.value(i); });