
// a List of Lists?
~grainlist = List.new;
~gr_g = Group.new;
~gr_b = Bus.audio(s, 2);

~gr_out_s = Synth.new(\patch_stereo, [
	\in, ~gr_b.index, \out, 0
], ~gr_g, \addAfter);

~grrecord = { arg buf=0, in=0;
	if (buf < ~grbuflist.size, {
			
		~rec_s = Synth.new(\record_adc, [
			\in, in,
			\buf, ~grbuflist[buf].bufnum,
			\loop, 0,
			\doneAction, 2
		]);
	});
};


~grplay = {
	arg buf=0,
		count=4,
		gap=4.0,
		wait=8.0;
	
	while({buf >= ~grainlist.size}, {
		~grainlist.add(List.new);
	});
	
	~grainlist.postln;
	
	~grainlist[buf] = List.new;
		
		
	Routine {count.do({ arg i;
		~grainlist[buf].add(
			BusGrainer.new(
				s,
				~grbuflist[buf],
				~gr_g,
				~gr_b.index
			)
		);
		(i * gap + wait).wait;
	}) }.play;
	
	
};

