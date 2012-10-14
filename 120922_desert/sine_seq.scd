~siner  = List.new;

~siner.add( Routine { inf.do {
	~sstk.value(num:5, tbase:16, start:300, end:350);
	48.wait;
} }.play );
	

~siner.add( Routine { inf.do {
	~sstk.value(num:3, tbase:12, start:10, end:200);
	60.wait;
} }.play );
	

~siner.add( Routine { inf.do {
	~sstk.value(num:6, tbase:6, start:200, end:450);
	16.wait;
} }.play );
	



~siner.add( Routine { inf.do {
	~sstk.value(num:3, tbase:32, start:50, end:200);
	84.wait;
} }.play );
	


~siner.add( Routine { inf.do {
	~sstk.value(num:3, tbase:32, start:30, end:120);
	96.wait;
} }.play );

~siner.add( Routine { inf.do {
	~sstk.value(num:6, tbase:64, start:300, end:600);
	120.wait;
} }.play );
	


	


