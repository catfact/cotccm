cv = CfCanvas.new("hm");

v.layers.add(CfGridTrace2d.new(v.window.view.bounds, 32, 16));
v.layers[0].model = CfContinuousAut.new(v.layers[0].n);

v.layers[0].model.val = Array.fill(v.layers[0].model.val.size, 1.0.rand);

r = v.layers[0].model.weight_res;
v.layers[0].model.weights_l = Array.fill(r, {1.0.rand});
//v.layers[0].model.weights_r = Array.fill(r, {1.0.rand});
v.layers[0].model.weights_r = v.layers[0].model.weights_l;


v.layers[0].hue = Color.blue;
v.dt = 1;
v.play;

