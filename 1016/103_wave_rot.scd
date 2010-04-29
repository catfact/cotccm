~waverottask = Task({~sinelist.do({|arr, i|
var newwave, wavelag;

newwave = ~vosc_bufs[0].bufnum + (3.0.rand);
wavelag = ~gbufdur * 2 + ((~gbufdur*2).rand);

arr[2].set(\wavelag, wavelag);
arr[2].set(\bufnum, newwave);

4.wait;

})
});                 