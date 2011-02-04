~basepath = Document.current.dir ++"/";
x = { |p| this.executeFile(~basepath++p); };


s = Server.default;
s.boot;
s.waitForBoot { Routine {


	~ndelays = 16;
	~delaybank = CfDelayBank(s, s, ~ndelays);
	
	0.2.wait;
	
	~delay_dur = 9;
	
	~delaybank.del_s.do({ arg syn, i; 
		i.postln;
		syn.set(\amplag, ~delay_dur * 0.5);
		syn.set(\delaytime, ~delaybank.maxDelay / (~ndelays-1) * (i+1));
		syn.set(\out, 1);
	});

	1.0.wait;

	/// animation
	{
		c = CfHueMorphCanvas.new;
		c.color_(Color.new(1.0, 0.01, 0.09));
		
		/////////////////// bottom layer: echo amps
		c.layers.add(CfGridTrace2d.new(c.window.view.bounds, ~ndelays, ~ndelays));
		c.layers[0].alpha_(1.0);
		c.layers[0].mode_(1); c.window.refresh;
		c.layers[0].hue_(Color.blue);
		//c.dt = 0.3;
		 //c.dt = 0.0625;
		 c.dt = ~delay_dur;
		
		
		c.layers[0].model = CfContinuousAut.new(c.layers[0].n);
//		c.layers[0].model = CfBinaryAut.new(c.layers[0].n);
		//c.layers[0].model.val = Array.fill(c.layers[0].n, { if(0.5.coin, {1}, {0}) });
		c.layers[0].model.val = Array.fill(c.layers[0].n, { 2.0.rand2} );
		/*
		c.layers[0].model.rule = 110;
		c.layers[0].model.rule = 111;
		*/
		// c.layers[0].model.rule = 127.rand;
		/*
		c.layers[0].model.rule
		*/

		//c.layers[0].model.weights_l = ~weights_l.choose;
		//c.layers[0].model.weights_r = ~weights_r.choose;
		
		
		x.value("weights_ok_1.scd");
	
	
		c.layers[0].model.function = {
			arg val;
			// val.postln;
			val.do({arg v, i;
				postln([v, i]);
				~delaybank.del_s[i].set(\amp, v.abs * 0.5);
				if (v < 0, {
					~delaybank.del_s[i].set(\out, 0)	
				}, {
					~delaybank.del_s[i].set(\out, 1)	
				});
			});
		};
		

	}.defer;
//	c.stop;	
	
		~delaybank.del_s.do({ arg syn, i; 
			i.postln;
			syn.set(\amp, 0.0);
		});

	
		120.0.wait;
		
{		c.play; }.defer;
}.play; };