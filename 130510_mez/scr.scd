~snapshot.value(0);

~frz_rec.value(0, true);
~frz_rec.value(0, false);

~frBuf[0].plot;

~frRec[0].run(true);

~frRec[0].set(\trig, 0);

~frRec[0].set(\trig, 1);


~ledmask.value(0, 0, 0);

a = -1;

a.sign

/////////////////
///////////// masking waterfall
8.do({ arg i; 8.do({ arg j; ~ledmask.value(i, j, 1); }); });

// velocities
~ledfall_vx = 0.2;
~ledfall_vy = 0;
~nspots = 10;
~ledfall_dt = 0.03;

////////// 
// blobs




// Bag

~ledfall_r = Routine {
	var spots = Array.fill(~nspots, { Point(8.rand, 8.rand) });
	
	inf.do {
		
		spots.do({ arg p;
			~ledmask.value(p.x, p.y, 1);
			if (~ledfall_vx.abs.coin, { p.x = ( p.x + ~ledfall_vx.sign ) % 8 });
			if (~ledfall_vy.abs.coin, { p.y = ( p.y + ~ledfall_vy.sign ) % 8 });			
			~ledmask.value(p.x, p.y, 0);
		});
		~ledfall_dt.wait;
	} 
}.play;

~ledfall_r.stop;

8.do({ arg i; 8.do({ arg j; ~ledmask.value(i, j, 0); }); });



//





/// try again

//// list of spots
~spots = List.new;
// add some spots
~spots.add(Point.new(3, 4));
(~nspots-1).do({
arg i;
var p;

p = ~spots.last;
// search 
while)
while( + [Point(0, 1), Point(1, 0), Point(0, -1), Point(-1, 0)].choose;

	p.x = p.x % 8;
	p.y = p.y % 8;
	~spots.add(p);
});

~spots.do({ arg p; ~ledmask.value(p.x, p.y, 1) });

~ledfall_update_y = { arg dir: 
	
};




/// blinking

d = [ 0.2, 0.2, 0.2, 0.2 ];
p = [ 0.12, 0.12, 0.12, 0.12 ];

~blink_r = Array.fill (4, { // 4 quads of blink routines
	arg i;
	Routine {
		var x0, y0; // start of quad
		var x, y;
		x0 = (i % 2) * 4;
		y0 = (i / 2).floor * 4;
		postln([x0 ,y0]);
		inf.do {
			y = y0;
			4.do({
				x = x0;
				4.do({
					~ledmask.value(x, y, 1);
					x = x + 1;
				}); y = y + 1;
			});

			d[i].wait;

			y = y0;
			4.do({
				x = x0;
				4.do({
					~ledmask.value(x, y, 0);
					x = x + 1;
				}); y = y + 1;
			});
			p[i].wait;
		}
	}.play;
});


~tilt = Point.new;

~tilt_r = OSCdef.newMatching('frz_key', { 
arg msg, time, addr, rec;
//msg.postln;

~tilt.x= (msg[2] - 127) >> 2;
~tilt.y = (msg[3] - 127) >> 2;

}, ~prefix++'/tilt');


~tilt_draw_r = Routine { inf.do {

~tilt.postln;

if( (~tilt_x != 0) || (~tilt_y != 0) , {
	8.do({ arg x; 8.do({ arg y;
		if(Point(x,y).dist(~tilt + Point(3.5, 3.5)) < 4, {
			~ledmask.value(x, y, 0);
		}, {
			~ledmask.value(x, y, 1);
		});
	
	})});
});

0.1.wait;
} }.play;


/*
~tilt_draw_r.stop;
*/


s.prepareForRecord
s.record
s.stopRecording;


~changegrains.value;

~hz_base.cpsmidi.postln;


60 - 46
~grl[0].free;
~grl[1].free;
~grl[2].free;
~grl[3].free;
~grl[4].free;
~grl[5].free;
~grl[6].free;
~grl[7].free;
~grl[0].free;


~frBuf[0].duration

~voch_frz_buf[0].plot;

s.free(7749);