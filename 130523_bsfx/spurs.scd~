// copy voch delay line buffers
~nvochgr = 4;
~voch_frz_buf = Array.fill(~nvochgr, { Buffer.alloc(s, ~vochlen * s.sampleRate) });
~voch_gr_s = Array.newClear(~nvochgr);
~voch_gr_g = Group.new(s, \addToTail);

~voch_frz = { arg n;
	~voch_buf[n].copyData(~voch_frz_buf[n], 0, 0, -1);
	if(~voch_gr_s[n].isNil, {
		~voch_gr_s[n] = Synth.new(\grain_tripos, [
			\buf, ~voch_frz_buf[0].bufnum,	
			\posrate, 1/16,
			\posratenoise, 1/4,
			\posnoise, 0.0001,
			\trigrate, 16,
			\trigratenoise, 0.5,
			\dur, 8.0,
			\durnoise, 0.85,
			\playratenoise, 1/128,
			\amp, -26.dbamp,
			\pan, n.linlin(0, ~nvochgr - 1, -0.2, 0.2);
		], ~voch_gr_g, \addToTail);
	});
		
}; 

~voch_frz_key = OSCdef.newMatching( 'voch_frz_key', { arg msg, addr, rec; 
	var x, y, val;
	x = msg[1];
	y = msg[2];
	val = msg[3];

	if(x == 7, {
		if(y < 4, {
			~voch_frz.value(y);
			~led.value(x, y, 1);
		});
	});

}, ~prefix++'/grid/key');


// grainr
SynthDef.new(\grain_tripos, {
	arg buf, out=0, amp=0.5,
	trigrate=8.0, trigratenoise=0.125,
	playrate=1.0, playratenoise=0.0001,
	posrate=0.25, posratenoise=0.000125,
	dur=4.0, durnoise=0.0001,
	pan = 0, pannoise = 0.5;

	var trig, grain, pos;
	
	trigrate = trigrate * (1 +  WhiteNoise.kr(trigratenoise));
	playrate = playrate * (1 +  WhiteNoise.kr(playratenoise));
	posrate = posrate * (1 + WhiteNoise.kr(posratenoise) );
	dur = dur * (1 + WhiteNoise.kr(durnoise));
	pan = pan * (1 + WhiteNoise.kr(pannoise));
	
	
	posrate = posrate / BufDur.kr(buf);

	pos = LFTri.kr(posrate).range(0, 1);

	trig = Impulse.ar(trigrate);
	dur = dur / trigrate;

	grain = GrainBuf.ar(2, trig, dur, buf, playrate, pos, 1, pan, -1, 64);

	Out.ar(out, grain * amp);
}).send(s);
// 4.0.log2


// ~voch_frz.value(0);


/*
z = Synth.new(\grain_tripos, [\buf, ~voch_frz_buf[0].bufnum]);
z.set(\posrate, 1/16);
z.set(\posratenoise, 1/4);
z.set(\posnoise, 0.0001);
z.set(\trigrate, 16);
z.set(\trigratenoise, 0.5);
z.set(\dur, 8.0);
z.set(\durnoise, 0.85);
z.set(\playratenoise, 1/128);
z.set(\amp, -24.dbamp);


z.free;
z.set(\trigratenoise, 1/32);

~voch_gr_s[0].set(\amp, -24.dbamp);

~voch_gr_s[0].free;
~voch_gr_s[0] = nil;


~voch_gr_s[2].free;
~voch_gr_s[2] = nil;

~voch_gr_s[3].free;
~voch_gr_s[3] = nil;
*/