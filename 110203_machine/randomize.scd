
c.layers[0].model.weights_l = ~weights_l.choose;
c.layers[0].model.weights_r = ~weights_r.choose;

c.layers[0].n.do({arg i;
	c.layers[0].model.val[i] = 1.0.rand2;
});

