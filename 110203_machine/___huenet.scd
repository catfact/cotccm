~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };
//Document.current.background_(Color.white.alpha_(0.8));


c = CfHueMorphCanvas.new("___");
c.layers.add(CfGridTrace2d.new(c.window.view.bounds, 32, 16));

x.value("_hid.scd");
x.value("__events.scd");



// canvas parameters
c.layers[0].alpha_(0.125);
c.layers[0].mode_(15);
c.dt = 0.125;

// run

c.layers[0].model = CfFpuRing.new(c.layers[0].n);
~model = \fpu;

c.color_(Color.new(0.3, 0.0, 1.0));
c.play;

//~randomize_model_params.value;
//~randomize_hue.value;

c.window.fullScreen;