~event = { arg x;
	x.switch(
		\fpuDefault, {
			// TODO make a cleaner method for this!
			c.layers[0].model = CfFpuRing.new(c.layers[0].n);
			c.layers[0].model.val[16] = 1.0;
			c.layers[0].model.val[11] = 1.0;
			
			// FPU specific params!
			c.layers[0].model.dt = 1/32;
			c.layers[0].model.k = 4.0;
			c.layers[0].model.d = 0.995;

		}
	);
};