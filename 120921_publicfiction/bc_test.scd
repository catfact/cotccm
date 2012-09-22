~post_wait = 0.125;

~ampt = -24.dbamp;
~clart = 0.6;

~analist = List.new;

~anar = Routine {
	var amp, pitch, clar, flat, cent;
	inf.do { 
		
		~amp_b.get({ arg v; amp = v; });
		~pitch_b.get({ arg v; pitch = v; });
		~clar_b.get({ arg v; clar = v; });
		~flat_b.get({ arg v; flat = v; });
		~cent_b.get({ arg v; cent = v; });
		
		s.sync;
		
		if(amp > ~ampt, {
			if(clar > ~clart, {
				~analist.add(Event.with(
					\amp->amp, 
					\pitch->pitch,
					\clar->clar,
					\flat->flat,
					\cent->cent
				));
			});			
		});

		~post_wait.wait;		
	}
}.play;

//r.stop;
// visualize:
/*
w = Window.new;
w.front;

~vis_t = 0.125;

~vis_r = Routine {
	var con = Condition.new(false);
	var vals = 
	inf.do {

	~amp_b.get({ arg v; postln("amp: "++v); });
	~pitch_b.get({ arg v; postln("pitch: "++v); });
	~clar_b.get({ arg v; postln("clarity: "++v); });
	~flat_b.get({ arg v; postln("flatness: "++v); });
	~cent_b.get({ arg v; postln("centroid: "++v); });
	cond.wait;
} }.play;

~setsl = {arg val;

*/

