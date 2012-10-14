
~sineamp = -26.dbamp;
//~sineamp = 0.25;

~sineg = Group.new(s);
~sstk = { arg tbase=32.0, start=100, num=6, end=200;
	var step = ((end - start) / num).floor;
	num.do({
		arg i;
		Synth.new(\rlpfsawsin, [
			\amp, ~sineamp / num,
			//			\amp, ~samp / num * ~analist[start+(spread*i)].amp,
			//			\hz, ~analist[start + (spread * i)].pitch,
			\hz, ~hzl[start + (step * i)],
			\atk, tbase / num * i + 0.01,
			\rel, tbase / num * (num-i) + 0.01,
			//			\sus, ~tbase
		], ~sineg);
	});
};
