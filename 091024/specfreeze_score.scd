~specfreezescore = Array.with(
	[0.5, 0.25, 0.1, 0.1, 16, 8, 26, 30],
	[0.25, 0.25, 0.1, 0.1, 16, 10, 26, 30],
	[0.5, 1.25, 0.1, 0.1, 16, 12, 26, 30],
	[0.25, 0.125, 0.1, 0.1, 16, 13, 26, 30],
	[0.215, 0.5, 0.125, 0.12, 16, 14, 26, 30],
	[0.5, 0.25, 0.1, 0.1, 16, 15, 26, 30],
	[0.25, 0.5, 0.1, 0.1, 16, 16, 26, 30],
	[0.5, 0.25, 0.1, 0.1, 16, 18, 26, 30],
	[1.0, 0.5, 0.1, 0.1, 16, 20, 24, 30],
	[0.5, 0.25, 0.1, 0.1, 16, 22, 22, 30],
	[1.5, 0.5, 0.1, 0.1, 16, 21, 22, 30],
	[0.25, 0.25, 0.1, 0.1, 16, 22, 20, 30],
	[0.5, 0.5, 0.1, 0.1, 16, 24, 20, 30],
	[0.25, 0.25, 0.1, 0.1, 16, 28, 26, 30],
	[0.5, 0.5, 0.1, 0.1, 16, 30, 36, 30],
	[1.0, 0.25, 0.1, 0.1, 16, 30, 56, 30]
);

~specscoreplay = Task({ ~specfreezescore.size.do({ arg i;
	var synth, score;
	score = ~specfreezescore[i];
	score.postln;
	synth = Synth.new(\specfreeze_shift_env, [
		\in, ~ezv_b.index, 
		\out, ~ezv_out_b.index,
		\attack, score[4], 
		\sustain, score[5], 
		\release, score[6],
		\stretchadd, score[0],
		\shiftadd, score[1],
		\stretchmul, score[2] * 0.3,
		\shiftmul, score[3] * 0.3,
		\stretchbus, ~ezv_amp_b.index,
		\shiftbus, ~ezv_amp_b.index,
		\stretchlag, 8.0,
		\shiftlag, 8.0,
		\stretchdelay, i % 3 + 1,
		\shiftdelay, i % 4 + 1
	], ~ezv_proc_g, \addToTail);
	
	SystemClock.sched(0.2, { synth.set(\freeze, 1); nil });
	AppClock.sched(score[7] - 10.0, {~fadeup.value; });
	score[7].wait;
}) }).play;