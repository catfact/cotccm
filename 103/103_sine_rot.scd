~rotdex=1;

~sinerottask = Task({~sinelist.do({|arr, i|
var newhz, thisentry, thisindex;
arr.postln;
i.postln;
thisindex = arr[1];
thisentry = ~pitch_entries[~gpitchkeys[arr[0]]];
thisentry.postln;
newhz = thisentry[(thisindex + ~rotdex).wrap(0, thisentry.size)]; 
arr[2].set(\hzlag, 4 + 32.rand);
arr[2].set(\panlag, 4 + 32.rand);
arr[2].set(\hz, newhz);
arr[2].set(\pan, 1.0.rand2);
~rotdex = ~rotdex+1;
4.wait;
})
});        