~slowr = Routine {
	300.do({
		~canvas.dt = ~canvas.dt + 0.01;
		~shiftlag = Array.fill(8, {~canvas.dt});
		~stretchlag = Array.fill(8, {~canvas.dt});
		~freezer_s.set(\stretchlag, ~stretchlag);
		~freezer_s.set(\shiftlag, ~shiftlag);
		1.wait;
	}).play;
}