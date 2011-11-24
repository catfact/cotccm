m = Cf40h.new;

// divide the 40h into 4 regions
m.press = {};
m.lift = {};
m.pressFunctions.clear;
m.liftFunctions.clear;
/*
m.pressFunctions.add('post'->{arg x, y; postln(["press", x, y]); });
m.liftFunctions.add('post'->{arg x, y; postln(["lift", x, y]); });
*/

m.clear;

~quads = Array.fill(4, { CfQuad.new(4) });
~quadOnFuncs = Array.fill(4, { {} });
~quadOffFuncs = Array.fill(4, { {} });

m.pressFunctions.add('quad'->{arg x, y;
	if (x < 4, {
		if(y < 4, {
			~quads[0].press(x, y);
		}, {
			~quads[2].press(x, y-4);
		})
	}, {
		if(y < 4, {
			~quads[1].press(x-4, y);
		}, {
			~quads[3].press(x-4, y-4);
		})
	});
});

m.liftFunctions.add('quad'->{arg x, y;
	if (x < 4, {
		if(y < 4, {
			~quads[0].lift(x, y);
		}, {
			~quads[2].lift(x, y-4);
		})
	}, {
		if(y < 4, {
			~quads[1].lift(x-4, y);
		}, {
			~quads[3].lift(x-4, y-4);
		})
	});
});


~quads.do({ arg quad, quadIdx;
	quad.toggle = true;
	quad.onAction = {
//		postln("quad on " ++ quadIdx);
		~quadOnFuncs[quadIdx].value;
		4.do({ arg i;
			4.do({ arg j;
				m.led(i + (4 * (quadIdx % 2)), j + (4 * (quadIdx / 2).floor), 1);
			});
		});	
	};
	quad.offAction = {
		// postln("quad off " ++ quadIdx);
		~quadOffFuncs[quadIdx].value;
		4.do({ arg i;
			4.do({ arg j;
				m.led(i + (4 * (quadIdx % 2)), j + (4 * (quadIdx / 2).floor), 0);
			});
		});	
	};
});111