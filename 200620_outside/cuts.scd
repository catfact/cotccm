n = NetAddr("localhost", 9999);

// mix to softcut
n.sendMsg("/set/level/adc_cut", 1.0);

// mix to DAC


/// voice 1, playing
n.sendMsg("/set/level/in_cut", 1, 0, 1.0);

n.sendMsg("/set/param/cut/rec_flag", 0, 1);
n.sendMsg("/set/param/cut/play_flag", 0, 1);
n.sendMsg("/set/level/cut", 0, 0.8);
n.sendMsg("/set/param/cut/buffer", 0, 0);
n.sendMsg("/set/pan/cut", 0, 0.0);
n.sendMsg("/set/enabled/cut", 0, 1.0);

n.sendMsg("/set/param/cut/rate", 0, 3);
n.sendMsg("/set/param/cut/loop_start", 0, 0.43);
n.sendMsg("/set/param/cut/loop_end", 0, 1.7);

n.sendMsg("/set/param/cut/loop_flag", 0, 1.0);
n.sendMsg("/set/param/cut/fade_time", 0, 0.025);
n.sendMsg("/set/param/cut/rec_level", 0, 1.0);
n.sendMsg("/set/param/cut/pre_level", 0, 0.8);
n.sendMsg("/set/param/cut/position", 0, 1);
n.sendMsg("/set/param/cut/read_duck", 0, 1); // cycle

/*
n.sendMsg("/set/param/cut/read_duck", 0, -1); // cycle
*/

//n.sendMsg("/set/param/cut/write_duck", 0, 1); // cycle


/// voice 2, recording and playing
n.sendMsg("/set/param/cut/rec_flag", 1, 1);
n.sendMsg("/set/param/cut/play_flag", 1, 1);

n.sendMsg("/set/enabled/cut", 1, 1.0);
n.sendMsg("/set/param/cut/buffer", 1, 1);

n.sendMsg("/set/level/in_cut", 0, 1, 1.0);
//n.sendMsg("/set/level/in_cut", 1, 1, 1.0);
n.sendMsg("/set/level/cut", 1, 0.8);
n.sendMsg("/set/pan/cut", 1, 0);

n.sendMsg("/set/param/cut/rate", 1, 2.5);
n.sendMsg("/set/param/cut/loop_start", 1, 0.2);
n.sendMsg("/set/param/cut/loop_end", 1, 0.83);
n.sendMsg("/set/param/cut/loop_flag", 1, 1.0);
n.sendMsg("/set/param/cut/fade_time", 1, 0.05);

n.sendMsg("/set/param/cut/rec_level", 1, 1);
n.sendMsg("/set/param/cut/pre_level", 1, 0.95);

n.sendMsg("/set/param/cut/position", 1, 0);

//n.sendMsg("/set/param/cut/read_duck", 1, 0); // cycle
//n.sendMsg("/set/param/cut/write_duck", 1, 0); // cycle


/// route 1 back to 2 for a little shimmer
n.sendMsg("/set/level/cut_cut", 0, 1, 0.5);
n.sendMsg("/set/level/cut_cut", 1, 0, 0.5);

// no duck
/*
n.sendMsg("/set/param/cut/read_duck", 0, -1);
n.sendMsg("/set/param/cut/read_duck", 1, -1);
n.sendMsg("/set/param/cut/write_duck", 0, -1);
n.sendMsg("/set/param/cut/write_duck", 1, -1);
*/



/*
n.sendMsg("/softcut/reset");
*/
