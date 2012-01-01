/*
MonomeClient.scanDevices(steal:true);

~lions_r = MonomeResponder.new(
		 filter:(
		 	\cmd:'/grid/key',
		 	\b:7
		 ),
		 function:{
			 arg r, e; 
			 e.postln;
			 if (e.c > 0, {
				MonomeClient.msgDevice('m40h0005', '/grid/led/row', [0, 7, 1 << e.a.asInteger]);
				if (e.a == 0, {
		{ w.view.background = Color.black; }.defer;
					x.value("lions_vla_grain.scd");	
				});
				if (e.a == 1, {
		{ w.view.background = Color.white; }.defer;
					x.value("lions_crumbler.scd");	
				});
				if (e.a == 2, {
		{ w.view.background = Color.red; }.defer;
					x.value("lions_vox_grain.scd");	
				});
				if (e.a == 3, {			
					{ w.view.background = Color.green; }.defer;
					postln(" VOXX REC ON...........
					.....");
					~vgrain_rec.set(\reclevel, 1.0);
					~vgrain_rec.set(\trig, 0);
					~vgrain_rec.set(\trig, 1);

				});
				if (e.a == 4, {			
					postln(" CLEARING VOX GRAINS...........
					.....");
					~vgrain_rec.set(\prelevel, 0.0);

				});
				if (e.a == 5, {			
					postln(" POLL HZ...........
					.....");
					~setvhz.value;

				});
			 }, {
				if (e.a == 4, {			
					postln(" DONE CLEARinG...........
					.....");
					~vgrain_rec.set(\prelevel, 1.0);

				});
				if (e.a == 5, {
					{ w.view.background = Color.black; }.defer;
					~vgrain_rec.set(\reclevel, 0.0);
			
				});
			 });
		 }
	);


*/


w = SCWindow.new("__", Rect(0, 0, 400, 400));
w.front;
w.view.keyDownAction = { arg view, char;
	if (char == $z, {
		{ w.view.background = Color.black; }.defer;
		x.value("lions_vla_grain.scd");		
	});
	if (char == $x, {
		{ w.view.background = Color.white; }.defer;
		x.value("lions_crumbler.scd");	
	});
	if (char == $c, {
		{ w.view.background = Color.red; }.defer;
		x.value("lions_vox_grain.scd");	
	});
	if (char == $ , {
		{ w.view.background = Color.green; }.defer;
		postln(" VOXX REC ON...........
		..............
		..........
		.....");
		~vgrain_rec.set(\reclevel, 1.0);
		~vgrain_rec.set(\trig, 0);
		~vgrain_rec.set(\trig, 1);
	
	});
	
	if (char == $\r, {
		postln(" CLEARING VOX GRAINS...........
		..............
		..........
		.....");
		~vgrain_rec.set(\prelevel, 0.0);
	});
	if (char == $/, {
		postln(" POLL HZ...........
		..............
		..........
		.....");
		~setvhz.value;

	});
};

w.view.keyUpAction = { arg view, char;
	
	if (char == $\r , {
		postln(" DONE CLEARinG...........
		..............
		..........
		.....");
		~vgrain_rec.set(\prelevel, 1.0);
	});
	if (char == $ , {
		{ w.view.background = Color.black; }.defer;
		postln(" VOXX REC OFF...........
		..............
		..........
		.....");
		~vgrain_rec.set(\reclevel, 0.0);
	});
};

~butN_func = {
	arg val;
	if (val > 0, {
		{ w.view.background = Color.green; }.defer;
		postln(" VOXX REC ON...........
		..............
		..........
		.....");
		~vgrain_rec.set(\reclevel, 1.0);
		~vgrain_rec.set(\trig, 0);
		~vgrain_rec.set(\trig, 1);

	}, {
		{ w.view.background = Color.black; }.defer;
		postln(" VOXX REC OFF...........
		..............
		..........
		.....");
		~vgrain_rec.set(\reclevel, 0.0);
	});
};


~butS_func = {
	arg val;
	if (val > 0, {
		postln(" CLEARING VOX GRAINS...........
		..............
		..........
		.....");
		~vgrain_rec.set(\prelevel, 0.0);
	}, {
		postln(" DONE CLEARinG...........
		..............
		..........
		.....");
		~vgrain_rec.set(\prelevel, 1.0);
	});
};


~butE_func = {
	arg val;
	if (val > 0, {
		postln(" POLL HZ...........
		..............
		..........
		.....");
		~setvhz.value;
	}, {

	});
};

