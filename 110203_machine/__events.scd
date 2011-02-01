x.value("_ca_weights.scd");

x.value("_hues.scd");

~randomize = {
	if (0.25.coin, {
		~randomize_model.value;
	});
	if (0.65.coin, {
		~randomize_model_params.value;
	});
	if (true, { //0.85.coin, {
		~randomize_hue.value;
	});
	if (0.75.coin, {
		~randomize_speed.value;
	});
	if (0.25.coin, {
		~randomize_blend.value;
	});
	
};

~randomize_model = {
	if (0.5.coin, {
		c.layers[0].model = CfFpuRing.new(c.layers[0].n);
		~model = \fpu;
	}, {
		c.layers[0].model = CfContinuousAut.new(c.layers[0].n);
		~model = \ca;
	});
	SystemClock.sched(0.1, {~randomize_model_params.value; nil });
};

~randomize_model_params = {
	if(~model == \fpu, {	
		//c.layers[0].n.postln;
		(10.rand + 1).do({
			c.layers[0].model.val[(c.layers[0].n - 1).rand] = 1.0.rand2;
		});
		
		// FPU specific params!
		c.layers[0].model.dt = 1/(16 + 64.rand);
		c.layers[0].model.k = 1.0 + 4.0.rand;
		c.layers[0].model.a = 1.0 + 3.0.rand;
		c.layers[0].model.d = 0.9 + 0.199999.rand;
		
		// FPU specific params!
		c.layers[0].model.dt = 1/32;
		c.layers[0].model.k = 4.0;
		c.layers[0].model.d = 0.995;
	});
	if(~model == \ca, {	
		c.layers[0].model.weights_l = ~weights_l.choose;
		c.layers[0].model.weights_r = ~weights_r.choose;
	});
};

~randomize_hue = {
	c.setTargetH(~colorFromHex.value(~hues.choose));
	c.setBlendFactorH(0.001 + 0.01.rand);	
};

~randomize_speed = {
	c.setTargetDt(0.125 + 2.0.rand, 100 + 400.rand);
};


~randomize_mode = {
	c.layers[0].mode_([13, 14, 15].wchoose([1, 2, 6].normalizeSum));
	c.layers[0].alpha_(0.0001 + 0.125.rand);
};

////// local control

c.window.view.keyDownAction = { arg v, c, m, u, k;	
	if (c == $r, { ~randomize.value; });
};

////// HID control
~switch_func = { arg val;
	if (val > 0, {~randomize.value; });
};

////// OSC control
