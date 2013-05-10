// store a copy
~analist_unsorted = ~analist.copy;
// sort by pitch
~analist = ~analist.sort({ arg ana1, ana2; ana1.pitch > ana2.pitch }).reverse;

~syn_amp = -24.dbamp;

~sstk = { arg tbase=32.0, start=100, num=6, end=200;
	var step;
	//	end = end.min(~analist.size - 1);
	step = ((end - start) / num).floor;
	Routine { num.do({ arg i; 
		
		~anasyn.value(
			start + (step * i), // analist idx
			tbase / num * i + (tbase / num), // atk,
			tbase, //sus
			tbase / num * (num-i) + (tbase / num)  , // rel

		);
		(tbase / num).wait;
	}); }.play;
};

~siner  = List.new;
/*
~siner.do({ arg r; r.stop; });
*/
Routine {

~siner.add( Routine { inf.do {
	~sstk.value(num:5, tbase:16, start:0, end:500);
	(16 * 2).wait;
} }.play );

16.wait;

~siner.add( Routine { inf.do {
	~sstk.value(num:4, tbase:23, start:2, end:60);
	(23 * 2).wait;
} }.play );
	
23.wait;


57.wait;

~siner.add( Routine { inf.do {
	~sstk.value(num:8, tbase:60, start:17, end:300);
	(60 * 2).wait;
} }.play );

60.wait;

}.play;

