// TODO make a cleaner method for this!
c.layers[0].model = CfFpuRing.new(c.layers[0].n);
~canvas.layers[1].model.val[16] = 1.0;
~canvas.layers[1].model.val[11] = 1.0;

// FPU specific params!
~canvas.layers[1].model.dt = 1/64;
~canvas.layers[1].model.k = 5.0;
~canvas.layers[1].model.d = 0.995;
~canvas.layers[1].alpha = 0.5;
