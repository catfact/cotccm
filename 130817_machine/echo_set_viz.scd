// plot amplitudes
w = Window.new("wave", Rect(0, 0, 1600, 810));
w.view.decorator = FlowLayout(w.view.bounds);
w.front;

~slw =  w.view.bounds.width - 10;
~sl = MultiSliderView(w, Rect(0, 0, ~slw, 800)); 
~sl.readOnly_(true);

~sl.drawLines_(true);
~sl.drawRects_(false);
~sl.isFilled_(true);
~sl.selectionSize_(10);
~sl.index_(10);
~sl.thumbSize_(1);
~sl.gap_(0);
~sl.background_(Color.new(0.15, 0.15, 0.15));
~sl.colors_(Color.new(0.5, 0.5, 1.0), Color.new(0.7, 0.7, 0.7) );
w.refresh;

~draw_val = FloatArray.newClear(~slw);

~plot_dt = 1 / 16;
~plot_idx = 0;

~plot_func = { arg i;
	~amp_b.get({ arg v; 
		~draw_val[~plot_idx] = v; 
		~plot_idx = ~plot_idx + 1;
		if(~plot_idx == ~slw, { ~plot_idx = 0; });
		{ 
			~sl.value_(~draw_val); 
			w.refresh;
		}.defer;
	});
};

~plot_r = Routine {
	var i = 0;
	inf.do {
		~plot_func.value(i);
		~plot_dt.wait;
	}
}.play;

~sl.action = { arg xb; 
	var dif_i;
	var dif_t;
	dif_i = ~plot_idx - xb.index;
	if (dif_i < 0, { dif_i = dif_i + ~slw; });
	dif_t = dif_i * ~plot_dt;
	~echo_s[~which_xy12].set(\time_lag, 0);
	~echo_s[~which_xy12].set(\time, dif_t.min(~echo_dur));
	post(" dif_t : ");
	postln(dif_t);
};	


/*
~plot_func = { };
~plot_r.stop;
*/ 