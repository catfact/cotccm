/*
x.set(\amp, -4.dbamp);

x = Synth.new(\henonsvf, [\amp, -19.dbamp, \out, ~master_out_b.index], s, \addToHead);

x.set(\res, 0.9);
x.set(\a, 1.2);
x.set(\b, 0.41);
x.set(\out, ~master_out_b.index);
*/

~nwhichbus = 0;

~ng = Group.after(~ezv_proc_g);

~nwait = 37.0;
~ni = 0;
~nsynths = Array.newClear(4);

~namp = -16.dbamp;

~ntask = Task({ inf.do({
	if(~nsynths[~ni].notNil, {
		~nsynths[~ni].set(\gate, 0);
	});
	if (~nwhichbus ==0, {
		~ezv_pitch_b.get({
			arg hz;
			
			hz.post; " ".post;
			
			~ezv_flatness_b.get({
				arg flatness;
				flatness.post; " ".post;
				
				~ezv_amp_b.get({
					arg amp;
					amp.post; " ".post;
					
					~nsynths.postln;
					Routine {
						~nsynths[~ni] = Synth.new(\henonsvf, [
							\hz, hz * 0.5,
							\osc_hz, hz * (2.0 ** (~ni + 4)),
							\resbus, ~ezv_flatness_b.index,
							\res, 0.9 - (flatness * 0.4),
							\attack, ~nwait * 0.6,
							\release, ~nwait * 0.6,
							\out, ~master_out_b.index,
							\amp, ~namp
						], ~ng);
						
						s.sync;
											
						~nsynths[~ni].set(\blag, ~nwait * 2.0);
						~nsynths[~ni].set(\b, amp * 0.1 + 0.3);
					}.play;
				});
			});
		});
	}, {
		~vla_pitch_b.get({
			arg hz;
			
			hz.post; " ".post;
			
			~vla_flatness_b.get({
				arg flatness;
				flatness.post; " ".post;
				
				~vla_amp_b.get({
					arg amp;
					amp.post; " ".post;
					
					~nsynths.postln;
					Routine {
						~nsynths[~ni] = Synth.new(\henonsvf, [
							\hz, hz * 0.5,
							\osc_hz, hz * (2.0 ** (~ni + 4)),
							\resbus, ~vla_flatness_b.index,
							\res, 0.9 - (flatness * 0.4),
							\attack, ~nwait * 0.6,
							\release, ~nwait * 0.6,
							\out, ~master_out_b.index,
							\amp, ~namp
						], ~ng);
						
						s.sync;
											
						~nsynths[~ni].set(\blag, ~nwait * 2.0);
						~nsynths[~ni].set(\b, amp * 0.1 + 0.3);
					}.play;
				});
			});
		});
	});
		
	~ni = (~ni + 1) % ~nsynths.size;
	~ni.postln;
	AppClock.sched(~nwait - 10.0, {~fadeup.value(1); });
	~nwait.wait;
})});

~ntask.play;

/*
~ntask.stop;
*/