x.value('buf_loops.scd');

~blz = List.new;

z = ~bl.value(~buf.noise, 1/5, 1/4);
z.set(\amp, -24.dbamp);

~blz.add(z);
z.free;

r = Routine {
	var r1 = Pseq([1, 1, 6/5], inf).asStream;
	var r2 = Pseq([6/5, 4/3], inf).asStream;
	inf.do {
		z.set(\rate1, r1.next);
		z.set(\rate2, r2.next);
		8.wait;
	}
}.play;



y = ~bl.value(~buf.tones, 0.5, 0.75, 16, 24);
y.set(\lpf, 3000);
y.set(\hpf, 80);

~blz.add(y);

z = ~bl.value(~buf.tones, 0.5, 0.75, 16, 24);
z.set(\lpf, 3000);
z.set(\hpf, 80);

~blz.add(z);



x.value('pitch_loops.scd');

~plz = List.new;
~plz.do({ arg rout; rout.stop;});

a = ~pl.value(6, durSeq:#[6], ratSeq:#[0.5, 1, 1, 1, 1.5], ampscale:0.2, atkSeq:[0.5, 0.01], susSeq:#[0.5, 0.2, 0.1], relSeq:#[0.2, 0.4, 0.6], panSeq:#[-1, 1, 0]);
~plz.add(a);

b = ~pl.value(12, durSeq:#[6], ratSeq:#[0.5, 1, 1, 0.5, 1.5], ampscale:0.2, atkSeq:[0.5, 0.01], susSeq:#[0.5, 0.2, 0.1], relSeq:#[0.2, 0.4, 0.6], panSeq:#[-0.25, 0.25, -0.5, 0.5, -1, 1]);
//b.stop;
~plz.add(b);

~blz[0].set(\amp, 0.2)
~blz[0].set(\amp, 0)

//~sine_out.set(\amp, 6.dbamp)
~sine_out_s.set(\amp, 0)
~sine_out_s.set(\lagtime, 20);
