
//s = Server.local;

//s.freeAll;

~post = {|p|postln(p);};


SynthDef.new(\shapedelay_skz_env, {arg in=0, out=1, delbuf=0, shapebuf=0, delaytime=0, level=1, freq=440, attack=1, release=1, gate=1, lpf_freq=2000, hpf_freq=80;
	var sig, amp, env, output;
	sig = HPF.ar(LPF.ar(BufDelayN.ar(delbuf, In.ar(in, 1), delaytime), lpf_freq), hpf_freq);
	sig = Shaper.ar(shapebuf, sig);
	sig = sig + sig * LPF.ar(StandardL.ar(freq, LFNoise2.ar(0.01, 0.1, 0.9)), 120);
	env = Env.asr(attack, 1, release);
	amp = EnvGen.ar(env, gate, 1, doneAction:2);
	output = sig * amp * level;
	Out.ar(out, Compander.ar(output, output, 0.1, 1.0, 0.0, 0.001, 0.04));
}).load(s);
 


Routine{

//input/analysis/output groups
~ig = Group.new(s);
~xg = Group.new(~ig, \addAfter);
~og = Group.new(~xg, \addAfter);
//input/analysis/output busses
~in_b = Bus.audio(s, 1);
~freq_b = Bus.control(s, 1);
~amp_b = Bus.control(s, 1);
~out_b = Bus.audio(s, 1);
~out2_b = Bus.audio(s, 1);
//input/analysis/output synths

~in0_s = Synth.new(\in_adc, [\in, 0, \out, ~in_b.index], ~ig, \addToHead);
~in1_s = Synth.new(\in_adc, [\in, 1, \out, ~in_b.index], ~ig, \addToHead);
~freq_s = Synth.new(\inputfreq, [\in, ~in_b.index, \out, ~freq_b.index], ~xg, \addToHead);
~amp_s = Synth.new(\inputamp, [\in, ~in_b.index, \out, ~amp_b.index], ~xg, \addToHead);
~out1_s = Synth.new(\patch_pan, [\in, ~out_b.index, \out, 4, \pan, -0.4], ~og, \addToHead);
~out2_s = Synth.new(\patch_mono, [\in, ~out2_b.index, \out, 5], ~og, \addToHead);
~out1_s.set(\out, 0);
~out2_s.set(\out, 1);

~post.value('remmns___stt.');
4.wait;

////// wavetables
~vosc_bufs = Buffer.allocConsecutive
(	4, s, 1024, 1,
	{	arg buf, i;
			var sa;
		sa = Array.fill
		(	i+1,
			{	arg j;
				var val;
				if (j<i, {val=0}, {val=1});
				val.postln
			}
		);
		buf.sine1Msg(sa);
	}
);

~post.value('buffsd.');
5.wait;

//////

//echos

~delay_buf = Array.fill(4, {
	Buffer.alloc(s, s.sampleRate * 40.0, 1);
});
~post.value('dlbfss.');
5.wait;

~echo_s = Array.fill
(	4,
	{	arg i;
		Synth.new
		(	\shapedelay_skz_env,
			[	\delbuf, ~delay_buf[i],
				\in, ~in_b.index,
				\out, if(i%2 == 0,{~out2_b.index},{~out_b.index}),
				\delaytime, 20,
				\attacktime, 10 + (30 * i),
				\level, 0.018,
				\shapebuf, ~vosc_bufs[i].bufnum,
				\gate, 0
			], ~xg, \addToTail
		);
	}
);

~post.value('echsss....');

// sine function, vars, params
~sines = Array.newClear(12);
~whichsine = 0;
~attacktime = 10;
~newsinewave = 
{	arg freq, amp, time;
	SystemClock.sched
	(	time,
		{		/* sinwwave
				~sines[~whichsine] = Synth.new
				(	\sine_1shot, 
					[	\freq, freq,
						\attack, time, \sustain, time * 4, \release, time * 4,
						\level, amp * 0.1 + 0.06,
						\out, ~out_b.index
					], ~xg, \addToTail
				);
				*/
				/*
				var t1, t2, t3;
				t1 = 0.8.rand;
				t2 = 0.8.rand;
				t3 = 0.8.rand;
				("this time: " ++ time).postln;
				*/
				~voscs[~whichsine].set(\hzlag, time.min(32.0));
				~voscs[~whichsine].set(\hz, if(0.5.coin, {0.5}, {if(0.5.coin,{0.25},{1/0})}));
				
				/*
				~sines[~whichsine] = Synth.new
				(	\vorg_1shot, 
					[	\freq, freq,
						\level, amp * 0.05 + 0.03,
						\attack, time.min(180.0),
						\dur, (time * 6.0).min(360.0),
						\release, (time * 4.0).min(300.0),
						\timbre_offset, 0,
						\timbre1_0, t1,
						\timbre1_1, (t1 + (1.0-t1).rand2).abs,
						\timbre2_0, t2,
						\timbre2_1, (t2 + (1.0-t2).rand2).abs,
						\timbre3_0, t3,
						\timbre3_1, (t3 + (1.0-t3).rand2).abs,
						\basebuf, ~vosc_bufs[0].bufnum,
						\out, ~out_b.index
					], ~vg, \addToHead
				);
				*/

			~whichsine = (~whichsine + 1) % 64;
			nil;
		}
	);
};
//////

// pitch follow function, vars, params
~amp_thresh= 0.03;
~amp_t_thresh = 6.0;
~wasinrange = false;

~lastfreq = 0;
~lastnote = 0;
~lasthighamp = 0;
~dur = 0;
~whichecho = 0;

~delta_t = 0.5;

~pitch_amp_logic = Task.new
({	inf.do
	({	arg i;
		~freq_b.get // asynchronous bus read, we have to wait
		({	arg freq;
			//("FREQ: " + freq + ": " + freq.cpsmidi.round).postln;
			~amp_b.get // wait again
			({	arg amp;
				var inrange;
				inrange =  (amp >= ~amp_thresh);
				(" " + inrange + " . . " + ~wasinrange).postln;
				~box_set.value(0, 0, if(inrange, {1}, {0}));
				~box_set.value(0, 1, if(~wasinrange, {1}, {0}));
				//("AMP:  "+amp).postln;
				if (	inrange == false,
				{	if ( ~wasinrange, // ending the last duration
					{	SystemClock.sched
						(0, 
							{	arg time; 
								~dur= time - ~lasthighamp;
								~echo_s[~whichecho].set(\delaytime, ~dur * 4);
								~whichecho = (~whichecho + 1) % ~echo_s.size;
								~lastfreq = freq; 
								~wasinrange = inrange; 
									///
									//
									// false
								~wasinrange = false;
								nil
							}
						);
					});
					///being safe... yuk
					~lastfreq = freq; 
					~wasinrange = inrange;	
					//"TOO QUIET".postln;
				},
				{	//"LOUD ENOUGH".postln;
					SystemClock.sched
					(0,{	arg time;
						if ( ~wasinrange == false, // starting a new duration
						{	~lasthighamp = time;
						});
						if (	(time-~lasthighamp > ~amp_t_thresh) && (time-~lastnote > ~amp_t_thresh), // longenough->sine
						{	"LONG ENOUGH, NEW SINE".postln;
							("DUR : "+~dur).postln;
							~newsinewave.value(freq, amp, ~dur);
							~lastnote = time;
							~box_set.value(0, 2, 1);
						}, {~box_set.value(0, 2, 0)});
						~echo_s[~whichecho].set(\freq, freq * 8);
						~lastfreq = freq; 
						~wasinrange = inrange;
						nil // don't reschedule
					});
				});
			});
		});
		~delta_t.wait;
	});
});

~post.value('ssttup_fncss...');

5.wait;
~post.value('startn logggic....');

~pitch_amp_logic.start;
//~pitch_amp_logic.stop;
/////////

					120.wait;
~post.value('echhhhhssssssssssss......');

//SystemClock.sched(120, {
~echo_s.do({|syn, i| syn.set(\gate, 1)});
// nil});
/////////// neverending


/*
SystemClock.sched(80, {
~sines.do({|syn, i| syn.set(\gate, 0)});
 nil});
*/

}.play