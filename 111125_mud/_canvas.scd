Routine {		
	{	
		~canvas = CfCanvas.new;
//		~canvas.color_(Color.new(0.0, 0.0, 1.0));
		~canvas.layers.add(CfGridTrace2d.new(~canvas.window.view.bounds, 8, 16));
		~canvas.layers[0].alpha_(1.0);
		~canvas.layers[0].mode_(1);
		~canvas.dt = 0.18;
		
		x.value("_ca_weights.scd");
		
		~canvas.layers[0].model = CfContinuousAut.new(~canvas.layers[0].n);
	
//		~canvas.layers[0].model.weights_l = ~weights_l.choose;
//		~canvas.layers[0].model.weights_r = ~weights_r.choose;
		~wlidxbits = Array.fill(4, 0);
		~wridxbits = Array.fill(4, 0);
		~sumbits = { arg arr; var sum=0; arr.do({ arg v, i; sum = sum + (v << i) }); sum};
		~wridx = 0;
		~wlidx = 0;
	
		x.value("weights_ok_1.scd");
	
		~vrs = [1, 2, 3/2, 5/4, 6/5, 11/8];
	
		~canvas.layers[0].model.function = {
			arg val;
			~freezer_s.set(\amp, val.abs);
			~freezer_s.set(\shift, val * 4.0);
			~freezer_s.set(\stretch, val.wrap(1.0, 1.5));
		};
		
//		~canvas.play;
	}.defer;
}.play;


