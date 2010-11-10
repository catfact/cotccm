s = Server.local.boot;
s = Server.local.waitForBoot {
	
	~spirals = Array.newClear(4);
	
	~spirals[0] = PrimeSpiralSine.new(s);

	~spirals[0].factorList = List[19, 19, 19, 19, 3];
	~spirals[0].sustain = 4.0;
	~spirals[0].relOff = 6.0;
	~spirals[0].relScale = 2.0;
	~spirals[0].waitScale = 0.5;
	~spirals[0].wait = 4.0;
	~spirals[0].amp = -12.dbamp;
	~spirals[0].wrapRatio = 4.0;
	~spirals[0].hz0 = 60.0;	

	
	~spirals[1] = PrimeSpiralSine.new(s);
	~spirals[1].factorList = List[29];
	~spirals[1].sustain = 0.125;
	~spirals[1].relOff = 0.25;
	~spirals[1].relScale = 1.0;
	~spirals[1].waitScale = 1/32;
	~spirals[1].wait = 3/16;
	~spirals[1].amp = -36.dbamp;
	~spirals[1].wrapRatio = 4.0;
	~spirals[1].hz0 = 480.0;	
	~spirals[1].play(inf);
	~spirals[1].stop;
	
	
	~spirals[2] = PrimeSpiralSine.new(s);
	~spirals[2].factorList = List[29];
	~spirals[2].sustain = 0.125;
	~spirals[2].relOff = 0.20;
	~spirals[2].relScale = 0.2;
	~spirals[2].waitScale = 1/16;
	~spirals[2].wait = 3/16;
	~spirals[2].amp = -36.dbamp;
	~spirals[2].wrapRatio = 4.0;
	~spirals[2].hz0 = 480.0;	
	
	~spiral_tog = {	arg which;
		if (~spirals[which].playR.isPlaying, {
			~spirals[which].stop;
		}, {
			~spirals[which].play(inf);
		});
	};
	
	~spiral_slowdown = {	arg which;
		~spirals[which].wait = ~spirals[which].wait * 2;
		~spirals[which].relOff = ~spirals[which].relOff * 1.5;
		~spirals[which].atkScale = ~spirals[which].atkScale + 1;
		~spirals[which].amp = ~spirals[which].amp * (-2.dbamp);
	};
	
	~spiral_speedup = {	arg which;
		~spirals[which].wait = ~spirals[which].wait / 2;
		~spirals[which].relOff = ~spirals[which].relOff / 1.5;
		~spirals[which].atkScale = ~spirals[which].atkScale - 1;
		~spirals[which].amp = ~spirals[which].amp / (-2.dbamp);
	};
	

};