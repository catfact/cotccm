~gui.value("playing pitches", Color.new(0.1, 0.2, 1.0));

~sineamp = 0.2;

~pitch_entries = 
~gpitchgrid.collect({arg list;
if (list.size > 0,
{list},
{nil}
)
});
~gpitchkeys = ~pitch_entries.keys.asArray;

~vosc_bufs = Buffer.allocConsecutive
(	4, s, 1024, 1,
	{	arg buf, i;
			var sa;
		sa = Array.fill
		(	i+1,
			{	arg j;
				var val;
				val = (1 / (j+1))*0.5 + 0.25;
				val.postln
			}
		);
		buf.sine1Msg(sa);
	}
);

SystemClock.sched(5, {

~sineg = Group.tail(s);
~sinelist = List.new;

~pitchclassamp = ~sineamp / (~pitch_entries.size);
~pitchclassamp.postln;

~pitchplaytask = Task({~pitch_entries.size.do({
	arg entrydex;
	var thisamp, thispan;
	var entry = ~pitch_entries[~gpitchkeys[entrydex]];
	thisamp = (~pitchclassamp / (entry.size)) * 0.8 + (~pitchclassamp * 0.05);
	thispan = ((entrydex % 2) * 2.0 - 1.0 + (entrydex * 0.2).wrap(-1.0, 1.0)).wrap(-1.0, 1.0);
	thisamp.postln;
	entry.do({|hz, i|	
		~sinelist.add(Array.with(entrydex, i,
			Synth.new('vLagMultiWave_0_2',[
			\level, thisamp,
			\hz, hz,
			\attacktime, 4,
			\out, 0,
			\pan, thispan,
			\bufnum, ~vosc_bufs[0].bufnum;
			],~sineg, 'addToTail'); // sine synth
		)) // add to array in sine list
	}); // end pitch class     iteration
	4.wait;
})}); // end pitch play task

~pitchplaytask.play;

~gclock.clear;

SystemClock.sched(4 * ~pitch_entries.size, {
x.value('103_wave_rot.scd');
~waverottask.play;
nil});

SystemClock.sched(8 * ~pitch_entries.size, {
x.value('103_sine_rot.scd');
~sinerottask.play;
nil});

SystemClock.sched(12 * ~pitch_entries.size, {
~sineg.set(\releasetime, 30 + (120.rand));
~sineg.set(\gate, 0);
nil});


nil}); // end sched