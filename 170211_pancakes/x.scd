/*
x = { arg amp=0.125, hz=110; Out.ar(0, (SinOsc.ar(hz) * amp).dup); }.play
x.free;

SynthDef.new(\shortdel, { arg out=0, amp=1.0, time=0.25, fb=0.1, in=1;
	var insnd, outsnd;
	insnd = SoundIn.ar(in) + (LocalIn.ar(1) * fb);
	outsnd = DelayC.ar(insnd, 4.0, time);
	LocalOut.ar(outsnd);
	Out.ar(out, (outsnd * amp).dup);
}).send(s);

y = Synth.new(\shortdel);
y.set(\fb, 0.5);
y.free;
*/

~del_buf = Array.fill(2, { Buffer.alloc(s, s.sampleRate * 16.0, 1) });

SynthDef.new(\flipdel, {
	arg buf1, buf2, mod, in=0, out=0,
	amp=1.0, fb=0.0, time1=0.25, time2=0.4;
	var del1, del2, insnd, outsnd, fade;
	insnd = SoundIn.ar(in) + (LocalIn.ar(1) * fb);
	del1 = BufDelayC.ar(buf1, insnd, time1);
	del2 = BufDelayC.ar(buf2, insnd, time2);
	fade = In.ar(mod);
	outsnd = (del1 * fade) + (del2 * (1.0-fade));
	LocalOut.ar(outsnd);
	Out.ar(out, (outsnd * amp).dup);
}).send(s);

z = Synth.new(\flipdel, [
	\buf1, ~del_buf[0].bufnum,
	\buf2, ~del_buf[1].bufnum
]);

z.set(\in, 1);
z.set(\fb, 0.6);

SynthDef.new(\lpfsaw, {
	arg out=0, hz = 2.0, lpfhz=10;
	var snd = LPF.ar(LFSaw.ar(hz), lpfhz);
	Out.ar(out, snd);
}).send(s);

~mod_b = Bus.audio(s);
~mod_s = Synth.new(\lpfsaw, [ \out, ~mod_b.index ], target:z, addAction:\addBefore);

~mod_s.set(\lpfhz, 5.0);

z.set(\time1, 2.0);

~mod_t = 0.8;
~mod_r = Routine { var
}

z.set(\mod, ~mod_b.index);

~mod_b.scope

z.free;
~mod.free;


48000 / 256
