
~swin = SCWindow.new("weights");
~slid_l = SCMultiSliderView(~swin, Rect(0, 0, ~swin.bounds.width, ~swin.bounds.height * 0.5));
~slid_r = SCMultiSliderView(~swin, Rect(0, ~swin.bounds.height * 0.5, ~swin.bounds.width, ~swin.bounds.height * 0.5));

~slid_l.value = c.layers[0].model.weights_l;
~slid_r.value = c.layers[0].model.weights_r;

~slid_l.action = { arg slider;
	c.layers[0].model.weights_l = slider.value.collect({arg val; val * 2.0 - 1.0});
	c.layers[0].model.weights_l.postln;
};
~slid_r.action = { arg slider;
	c.layers[0].model.weights_r = slider.value.collect({arg val; val * 2.0 - 1.0});
	c.layers[0].model.weights_r.postln;
};

~slid_l.thumbSize_(0.0);
~slid_l.drawLines = true;
~slid_l.elasticMode = 1;
~slid_l.reference = Array.fill(~slid_l.size, {0.5});
~slid_r.thumbSize_(0.0);
~slid_r.drawLines = true;
~slid_r.elasticMode = 1;
~slid_r.reference = Array.fill(~slid_r.size, {0.5});

~swin.front;
