Routine.run {var c; c = Condition.new;

// master duration!!!
~gbufdur = 120; // sec 


s.freeAll;

// record group
~rg = Group.new(s, 'addToHead');

// grain groups
~gg0=Group.after(~rg);  
~gg1=Group.after(~rg); 

//grain buffers
~gbuf0 = Buffer.alloc(s, s.sampleRate*~gbufdur, 1);
~gbuf1 = Buffer.alloc(s, s.sampleRate*~gbufdur, 1);

// shaper group
~sg = Group.after(~gg);

// analysis busses
~ampbus = Bus.control(s, 1);
~hzbus = Bus.control(s, 1); 

s.sync(c);

~gui.value("setup", Color.new(0.8, 0.8, 0.8))

} // end sync routine