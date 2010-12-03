~gran.do({arg gran; gran.bufwr_s.run(false); });

~gran[1].rate = 1.0;
~gran[2].rate = 0.5;
~gran[3].rate = 15/32;
~gran[4].rate = 3/4;
~gran[5].rate = 17/8;
~gran[6].rate = 9/8;
~gran[7].rate = 9/32;


~gran.do({arg gran; gran.bufwr_s.run(true);});
