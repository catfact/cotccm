Routine {
	// 2x2 array of buffers
	~del_buf = Array.fill(2, { Array.fill(2, { Buffer.alloc(s, s.sampleRate * 16.0, 1) }); });

	SynthDef.new(\flipdel, {
		arg buf1, buf2, mod, in=0, out=0,
		amp=1.0, fb=0.0, time1=0.25, time2=0.4, tlag=0.25;
		var del1, del2, insnd, outsnd, fade;
		insnd = SoundIn.ar(in) + (LocalIn.ar(1) * fb);
		time1 = Lag.kr(time1, tlag);
		time2 = Lag.kr(time2, tlag);

		del1 = BufDelayC.ar(buf1, insnd, time1);
		del2 = BufDelayC.ar(buf2, insnd, time2);
		fade = In.ar(mod);
		outsnd = (del1 * fade) + (del2 * (1.0-fade));
		LocalOut.ar(outsnd);
		Out.ar(out, (outsnd * amp));
	}).send(s);

	s.sync;

	~zg = Group.new;
	z = Array.fill(2, { arg i;
		Synth.new(\flipdel, [
			\buf1, ~del_buf[i][0].bufnum,
			\buf2, ~del_buf[i][1].bufnum,
			\time1, 4.0 + (0.35 * i),
			\time2, 6.0 + (0.4 * i),
			\in, 1,
			\fb, 0.7,
			\out, i
		], ~zg);
	});

	SynthDef.new(\lpfsaw, {
		arg out=0, hz = 0.2, lpfhz=4.0;
		var snd = LPF.ar(LFSaw.ar(hz), lpfhz);
		Out.ar(out, snd);
	}).send(s);
	s.sync;


	~mod_b = Array.fill(2, { Bus.audio(s); });
	~mod_s = Array.fill(2, { arg i;
		Synth.new(\lpfsaw, [ \out, ~mod_b[i].index ], target:~zg, addAction:\addBefore);
	});


	z.do({ arg syn, i; syn.set(\mod, ~mod_b[i].index); });

	~mod_s[0].set(\hz, 2.2);
	~mod_s[1].set(\hz, 3.8);
	~mod_s[0].set(\lpfhz, 40);
	~mod_s[1].set(\lpfhz, 30);

	~zg.set(\tlag, 10.0);

}.play;

{
	w = Window.new;
	w.acceptsMouseOver = true;
	t = StaticText(w, w.bounds);
	w.view.mouseMoveAction = {
		arg view, x, y, modifiers, buttonNumber, clickCount;
		var ux, uy, str, hz0, hz1, t0, t1;
		//[view, x, y, modifiers, buttonNumber, clickCount].postln;
		ux  = x / (w.bounds.width);
		uy  = y / (w.bounds.height);
		str = "";

		if(modifiers.isShift, {
			t0 = ux * 8.0;
			t1 = uy * 8.0;
			z[0].set(\time1, t0);
			z[0].set(\time2, t1);
		});


		if(modifiers.isCtrl, {
			t0 = ux * 4.0;
			t1 = uy * 4.0;
			z[1].set(\time1, t0);
			z[1].set(\time2, t1);
		});

		hz0 = 0.25 * (32.0 ** ux);
		hz1 = 0.25 * (32.0 ** uy);
		~mod_s[0].set(\hz, hz0);
		~mod_s[1].set(\hz, hz1);
		str = str ++ "\n"++ hz0.floor ++ " " ++ hz1;
		str.postln;
		t.string = str;

	};
	w.front;
}.defer;