x = {|p| this.executeFile('/Users/e/_code/_sc/cotccm/1016/'++p)};

x.value('../../__ANY_BOOT.scd');   
x.value('../../__VANILLA_LIB.scd'); 

x.value('103_gui.scd');

SystemClock.sched(5, {
x.value('103_setup.scd');
 nil});

SystemClock.sched(8, {
~gui.value('grains', Color.blue);
 nil});
 
SystemClock.sched(10, {
x.value('103_grains.scd');
 nil});

SystemClock.sched(470, {
~gui.value("30s vox rec", Color.white);
nil});

SystemClock.sched(500, {
x.value('103_vox_pitch_gather.scd');
 nil});
 
SystemClock.sched(500, {
x.value('103_vox_loop.scd');
 nil});
 
SystemClock.sched(700, {
x.value('103_vox_pitch_play.scd');
nil});

SystemClock.sched(701, {
x.value('876_trigshape_defs.scd');
nil});

SystemClock.sched(820, {
x.value('876_trigshape_init_rec.scd');
nil});

SystemClock.sched(1200, {
s.set(\releasetime, 3);
s.set(\gate, 0);
nil;
});