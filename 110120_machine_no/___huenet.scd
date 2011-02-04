Document.current.background_(Color.white.alpha_(0.8));


c = CfHueMorphCanvas.new;
c.layers.add(CfGridTrace2d.new(c.window.view.bounds, 32, 16));



// add FPU model
// TODO make a cleaner method for this!
c.layers[0].model = CfFpuRing.new(c.layers[0].n);
c.layers[0].model.val[16] = 1.0;
c.layers[0].model.val[11] = 1.0;
// FPU specific params!
c.layers[0].model.dt = 1/32;
c.layers[0].model.k = 4.0;
c.layers[0].model.d = 0.995;



// canvas parameters
c.layers[0].alpha_(0.125);
c.layers[0].mode_(15);
c.dt = 0.125;

// run
c.play;

c.setColor(Color.new(0.2, 0.8, 1.0));
c.setTargetH(Color.new(0.3, 0.0, 1.0));
c.setBlendFactorH(0.0005);


c.setTargetH(Color.new(1.0, 0.1, 0.1));
c.setBlendFactorH(0.05);
c.color.postln;