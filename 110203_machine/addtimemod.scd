~dt_base = 1/4;
~dt_mod = 5/8;
~dt_min = 1/16;
~dt_max = 2/3;
~dt_wrap = true;

c.layers[0].model.function = {
	arg val;
	var dt;
	dt = ~dt_base;
	val.do({arg v, i;
		v.postln;
		if(~dt_wrap, {
			dt = (dt + (v * ~dt_mod)).abs.wrap(~dt_min, ~dt_max);
		}, {
			dt = (dt + (v * ~dt_mod)).abs.max(~dt_min).min(~dt_max);
		});
		if ((v.abs > ~hitthresh) && (i < ~nsamps), {
			~hitsample.value(~drummap[i], ((1.0 - v.abs) * ~hitscaledb).dbamp);
		});
	});
	dt.postln;
	c.dt = dt;
};