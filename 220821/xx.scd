	~pnum = [ 60, 62, 64, 65, 67, 69];

	/*~prate = Dictionary.newFrom([
		60, [1, 2],
		62, [1, 3/2, 14/8],
		64, [1, 2, 6/5, 4/3],
		65, [1, 3/2, 4/3, 5/4, 15/8],
		67, [1, 3/2, 4/3],
		69, [9/8, 6/5, 4/3, 8/5],
	]);
*/

~prate[62] = Pseq([3/2, 2, 3, 8/5, 2, 6/5], inf).asStream;
~prate[60] = Pseq([1, 0.5, 1, 4/5], inf).asStream;
//~prate[64] = Pseq([1, 0.5, 1, 4/5], inf).asStream;
~prate[65] = Pseq([1, 0.5, 1, 4/5], inf).asStream;
~prate[67] = Pseq([1, 0.5, 1, 4/5], inf).asStream;
~prate[69] = Pseq([1, 0.5, 1, 4/5], inf).asStream;

	~ppos = ~prate.collect({arg x, i; i * 0.25});
