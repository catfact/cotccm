~gui.value("flipop", Color(0.5, 0.5, 0.89));

~trigbus = Bus.control(s, 1);

~trigbufdur = 32;
~numtrigbufs = 8;
~trigbufs = Array.fill(~numtrigbufs, {
	Buffer.alloc(s, s.sampleRate * ~trigbufdur, 1); 
});

~psyntharr = List.new;

~addplayer={arg buf;
~psyntharr.add(Synth.new('dustyflipflop',[
\level, -24.dbamp,
\buf, ~trigbufs[buf].bufnum,
\buflen, ~trigbufdur,
\trigin, ~trigbus.index,
\jumpdensity, 0.07,
\attacktime, 20.0, 
\invertpauseswitch, #[1, 1, 1, 0, 0].choose
], s, 'addToTail'));   
};

SystemClock.sched(10,{

~recsynths = Array.fill(~numtrigbufs, {|i|
Synth.new('amp_pause_rec',[
\buf, ~trigbufs[i].bufnum,
\out, if(i==0, {~trigbus.index}, {-1}), // only 1 rec synth sending triggers
\ampthtresh, (-26 + i).dbamp,
\uplag, 0.01,
\downlag, 0.3,
\in, 1
], s, 'addToHead');
nil});


~numplayers = 24;

~playtask = Task({~numplayers.do({|i|
~addplayer.value(i % ~numtrigbufs);
(0.25 + 12.rand).wait;
})});

~playtask.play;

nil;
});