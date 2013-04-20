

// master bus patches
~p02 = Synth.new(\patch, [\in, 0, \out, 2, \amplag, 6.0, \amp, 0.0], s, \addToTail);
~p03 = Synth.new(\patch, [\in, 0, \out, 3, \amplag, 6.0, \amp, 0.0], s, \addToTail);
~p12 = Synth.new(\patch, [\in, 1, \out, 2, \amplag, 6.0, \amp, 0.0], s, \addToTail);
~p13 = Synth.new(\patch, [\in, 1, \out, 3, \amplag, 6.0, \amp, 0.0], s, \addToTail);

~tilt = Point.new;

~tilt_r = OSCdef.newMatching('tilt', { 
	arg msg, time, addr, rec;
	~tilt.x = (msg[2] - 127);
	~tilt.y = (msg[3] - 127);

if(~tilt.x < 0, {
	~p02.set(\amp, ~tilt.x.abs.linlin(0, 32, -inf, 0).dbamp );
}, {
	~p03.set(\amp, ~tilt.x.linlin(0, 32, -inf, 0).dbamp );
});


if(~tilt.y < 0, {
	~p12.set(\amp, ~tilt.y.abs.linlin(0, 32, -inf, 0).dbamp );
}, {
	~p13.set(\amp, ~tilt.y.linlin(0, 32, -inf, 0).dbamp );
});


}, ~prefix++'/tilt');


~tilt_draw_r = Routine { inf.do {

	~tilt.postln;

	if( (~tilt_x != 0) || (~tilt_y != 0) , {
		8.do({ arg x; 8.do({ arg y;
			if(Point(x,y).dist(~tilt * 0.25 + Point(3.5, 3.5)) < 4, {
				~ledmask.value(x, y, 0);
			}, {
				~ledmask.value(x, y, 1);
			});
			
		})});
	});

	0.1.wait;
	
} }.play;


c.og


z = Synth.new(\patch, [\in, 0, \out, 2], s, \addToTail);


q = { Out.ar(2, SinOsc.ar(110) * 0.125)  }.play(s);

z