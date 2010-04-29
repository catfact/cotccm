Routine {

~growflag = true;
~wait = 0.02;
10.wait;

~max_size = ~max_size + 1; ~max_size.postln;
10.wait;
	
//~max_size = ~max_size + 1; ~max_size.postln;
~wait = 0.03;

30.wait;
~gs.choose.set(\r1, (5.rand+1) / (3.rand+1));
~gs.choose.set(\r0, (5.rand+1) / (3.rand+1));
~gg.set(\pos_off, 1.0.rand);

//~max_size = ~max_size + 1; ~max_size.postln;
~wait = 0.04;

//~colors = ~colors.add(Color.grey);
~max_size = 2;

30.wait;
~gs.choose.set(\r1, (5.rand+1) / (3.rand+1));
~gs.choose.set(\r0, (5.rand+1) / (3.rand+1));

~gg.set(\pos_off, 1.0.rand);

~colors = ~colors.add(Color.new(0.8, 1.0, 0.9));
20.wait;
~gs.choose.set(\r1, (5.rand+1) / (3.rand+1));
~gs.choose.set(\r0, (5.rand+1) / (3.rand+1));

~colors.pop.postln;
~colors.postln;

30.wait;
~gs.choose.set(\r1, (5.rand+1) / (3.rand+1));
~gs.choose.set(\r0, (5.rand+1) / (3.rand+1));
~gg.set(\pos_off, 1.0.rand);


~colors = ~colors.add(Color.black);

10.wait;
~gs.choose.set(\r1, (5.rand+1) / (3.rand+1));
~gs.choose.set(\r0, (5.rand+1) / (3.rand+1));


/*
~rot = ~rot + 1; ~rot.postln;
~rot = 5;
~rot = 1;
~rot = 4;
~rot = 3;
~rot
*/
~wait = 0.05;	



~rot = 9;

5.do({ |i| ~colors = ~colors.add(Color.new(i/4,i/4,i/4));});


18.wait;
~gs.choose.set(\r1, (5.rand+1) / (3.rand+1));
~gs.choose.set(\r0, (5.rand+1) / (3.rand+1));

~gg.set(\pos_off, 1.0.rand);

~wait= 0.06;

~rot = 1;

~colors.postln;
~colors.pop.postln;

//w.view.background = Color.black;

22.wait;

~rot = 5;

~squares.size.postln;


// maybe like numsquares > 3200;

~wait = 0.1;

22.wait;
~gs.choose.set(\r1, (5.rand+1) / (3.rand+1));
~gs.choose.set(\r0, (5.rand+1) / (3.rand+1));

~colors = ~colors.add(Color.new(1.0, 0.2, 0.4));

~rot = 6;

24.wait;
~gs.choose.set(\r1, (5.rand+1) / (3.rand+1));
~gs.choose.set(\r0, (5.rand+1) / (3.rand+1));

~gg.set(\pos_off, 1.0.rand);


~rot = 8;

50.wait;
5.do({ |i| ~colors = ~colors.add(Color.new(i/4,i/12,i/18));});
~rot = 1;

~gg.set(\pos_off, 1.0.rand);

//~growflag = false;

30.wait;
~gs.choose.set(\r1, (5.rand+1) / (3.rand+1));
~gs.choose.set(\r0, (5.rand+1) / (3.rand+1));

~rot = 10;
30.wait;
~gs.choose.set(\r1, (5.rand+1) / (3.rand+1));
~gs.choose.set(\r0, (5.rand+1) / (3.rand+1));

~rot = 12;
30.wait;
~gs.choose.set(\r1, (5.rand+1) / (3.rand+1));
~gs.choose.set(\r0, (5.rand+1) / (3.rand+1));

~gg.set(\pos_off, 1.0.rand);

~rot = 14;

30.wait;
~gs.choose.set(\r1, (5.rand+1) / (3.rand+1));
~gs.choose.set(\r0, (5.rand+1) / (3.rand+1));

~rot = 2;


//~squares = ~squares.rotate(10.rand);
}.play;