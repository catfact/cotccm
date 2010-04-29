Routine.run{var c; c = Condition.new;

~glevel = 0.1;
~gclock = TempoClock(1);

s.sync(c);

~gui.value('rec start', Color.green);

~grec0 = Synth.new('vRecord_1_1', [\in, 0, \buf, ~gbuf0.bufnum], ~gg, \addBefore);

// pause recording @ 1:00
~gclock.sched(60, {
~grec0.run(false);
~gui.value("rec pause", Color.red);
nil}); 

// start recording @ 3:00
~gclock.sched(180, {
~grec0.run(true);
~gui.value("rec run", Color.green);
nil}); 

// pause recording @ 4:00
~gclock.sched(210, {
~grec0.run(false);
~gui.value("rec pause", Color.red);
nil}); 


////////////////////////////////////////////////////
// play @ 2:00
// start at 0
// rate 0.125
// dur 3:00
// fade in :30
// fade out :30
// loop at 2:30
~gclock.sched(120, {
Synth.new('vGrain_1_2', [
\level, ~glevel,
\dur, 180,
\pitch, 0.125,
\attacktime, 30,
\releasetime, 30,
\startpos, 0,
\curve, 0,
\pan0, -0.3,
\pan1, 0.2,
\pancurve, 0,
\buf, ~gbuf0.bufnum, 
], ~gg0, 'addToTail');
150; });

// play @ 2:00
// start at :30
// rate 0.125
// dur 2:00
// fade in :40
// fade out :40
// loop at 1:20
~gclock.sched(120, {
Synth.new('vGrain_1_2', [
\level, ~glevel,
\dur, 120,
\pitch, 0.125,
\attacktime, 40,
\releasetime, 40,
\startpos, 30,
\curve, 0,
\pan0, 0.2,
\pan1, -0.22,
\pancurve, 0,
\buf, ~gbuf0.bufnum, 
], ~gg0, 'addToTail');
80; });

///////////////////////////////////////////////////
// play @ 2:30
// start at :00
// rate 0.25
// dur 3:00
// fade in 1:20
// fade out 1:20
// loop at 1:40
~gclock.sched(150, {
Synth.new('vGrain_1_2', [
\level, ~glevel * 0.5,
\dur, 120,
\pitch, 0.25,
\attacktime, 80,
\releasetime, 80,
\startpos, 0,
\curve, 0,
\pan0, -0.7,
\pan1, 0.7,
\pancurve, 0,
\buf, ~gbuf0.bufnum, 
], ~gg0, 'addToTail');
100; });

// play @ 2:30
// start at :30
// rate 0.25
// dur 2:00
// fade in 1:00
// fade out 1:00
// loop at 1:00
~gclock.sched(150, {
Synth.new('vGrain_1_2', [
\level, ~glevel * 0.5,
\dur, 120,
\pitch, 0.25,
\attacktime, 80,
\releasetime, 80,
\startpos, 30,
\curve, 0,
\pan0, 0.7,
\pan1, -0.7,
\pancurve, 0.1,
\buf, ~gbuf0.bufnum, 
], ~gg0, 'addToTail');
60; });

///////////////////////////////////////////////
//////////////////////////////////////////////
// play @ 3:00
// start at 1:00
// rate 0.125
// dur 4:00
// fade in 1:00
// fade out 1:00
// loop at 3:00
~gclock.sched(180, {
Synth.new('vGrain_1_2', [
\level, ~glevel * 0.4,
\dur, 240,
\pitch, 0.125,
\attacktime, 60,
\releasetime, 60,
\startpos, 60,
\curve, 0,
\pan0, 0.6,
\pan1, -0.6,
\pancurve, -0.5,
\buf, ~gbuf0.bufnum, 
], ~gg0, 'addToTail');
180; });

// play @ 3:00
// start at 1:15
// rate 0.125
// dur 4:00
// fade in 2:00
// fade out 2:00
// loop at 2:00
~gclock.sched(180, {
Synth.new('vGrain_1_2', [
\level, ~glevel * 0.4,
\dur, 240,
\pitch, 0.125,
\attacktime, 120,
\releasetime, 120,
\startpos, 75,
\curve, 0,
\pan0, -0.9,
\pan1, 0.9,
\pancurve, 0.5,
\buf, ~gbuf0.bufnum, 
], ~gg0, 'addToTail');
180; });

// play @ 3:00
// start at 1:30
// rate 0.125
// dur 4:00
// fade in 1:30
// fade out 1:30
// loop at 2:30
~gclock.sched(180, {
Synth.new('vGrain_1_2', [
\level, ~glevel * 0.4,
\dur, 240,
\pitch, 0.125,
\attacktime, 90,
\releasetime, 90,
\startpos, 90,
\curve, 0,
\pan0, 0.4,
\pan1, -0.9,
\pancurve, 0.1,
\buf, ~gbuf0.bufnum, 
], ~gg0, 'addToTail');
150; });


//////////////////////
//////////////////////
play @ 4:00

~gclock.sched(240, {
Synth.new('vGrain_1_2', [
\level, ~glevel * 0.2,
\dur, 240,
\pitch, 0.25,
\attacktime, 60,
\releasetime, 60,
\startpos, 60,
\curve, 0,
\pan0, 0.6,
\pan1, -0.6,
\pancurve, -0.5,
\buf, ~gbuf0.bufnum, 
], ~gg0, 'addToTail');
120; });

~gclock.sched(240, {
Synth.new('vGrain_1_2', [
\level, ~glevel * 0.2,
\dur, 180,
\pitch, 0.25,
\attacktime, 80,
\releasetime, 80,
\startpos, 75,
\curve, 0,
\pan0, -0.9,
\pan1, 0.9,
\pancurve, 0.5,
\buf, ~gbuf0.bufnum, 
], ~gg0, 'addToTail');
100; });

~gclock.sched(240, {
Synth.new('vGrain_1_2', [
\level, ~glevel * 0.2,
\dur, 120,
\pitch, 0.25,
\attacktime, 30,
\releasetime, 30,
\startpos, 90,
\curve, 0,
\pan0, 0.4,
\pan1, -0.9,
\pancurve, 0.1,
\buf, ~gbuf0.bufnum, 
], ~gg0, 'addToTail');
90; });

///////////////////////
///////////////////////


} // end sync routine


