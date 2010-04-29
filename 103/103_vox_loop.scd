Routine.run{var c; c = Condition.new;

~glevel2 = 0.2;
~gclock1 = TempoClock(1);

s.sync(c);

~gui.value('rec start', Color.green);

~grec1 = Synth.new('vRecord_1_1', [\in, 1, \buf, ~gbuf1.bufnum], ~gg1, \addBefore);

// pause recording at 2:00
~gclock.sched(120, {
~grec1.run(false);
~gui.value("rec pause", Color.red);
nil}); 


////////////////////////////////////////////////////
~gclock.sched(120, {
Synth.new('vGrain_1_2', [
\level, ~glevel2,
\dur, 120,
\pitch,1.0,
\attacktime, 00,
\releasetime, 20,
\startpos, 0,
\curve, 0,
\pan0, -0.3,
\pan1, 0.2,
\pancurve, 0,
\buf, ~gbuf1.bufnum, 
], ~gg1, 'addToTail');
nil; });

~gclock.sched(120, {
Synth.new('vGrain_1_2', [
\level, ~glevel2,
\dur, 120,
\pitch,1.0,
\attacktime, 00,
\releasetime, 20,
\startpos, 30,
\curve, 0,
\pan0, 0.3,
\pan1, -0.2,
\pancurve, 0,
\buf, ~gbuf1.bufnum, 
], ~gg1, 'addToTail');
nil; });

~gclock.sched(150, {
Synth.new('vGrain_1_2', [
\level, ~gleve2l,
\dur, 90,
\pitch,1.0,
\attacktime, 00,
\releasetime, 20,
\startpos, 0,
\curve, 0,
\pan0, -0.3,
\pan1, 0.2,
\pancurve, 0,
\buf, ~gbuf1.bufnum, 
], ~gg1, 'addToTail');
nil; });

~gclock.sched(150, {
Synth.new('vGrain_1_2', [
\level, ~glevel2,
\dur, 90,
\pitch,1.0,
\attacktime, 0,
\releasetime, 20,
\startpos, 30,
\curve, 0,
\pan0, 0.3,
\pan1, -0.2,
\pancurve, 0,
\buf, ~gbuf1.bufnum, 
], ~gg1, 'addToTail');
nil; });




} // end sync routine


