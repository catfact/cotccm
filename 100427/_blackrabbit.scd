s = Server.internal;
s.waitForBoot { Routine {

// -- synthdefs
SynthDef.new(\patch, { arg in = 0, out=0, amp = 1.0, amplag = 0.01;	Out.ar(out, In.ar(in) * Lag.kr(amp, amplag));
}).send(s);

SynthDef.new(\patch_pan, { arg in = 0, out=0, amp = 1.0, amplag = 0.01, pan=0;	Out.ar(out, Pan2.ar(In.ar(in) * Lag.kr(amp, amplag), pan));
}).send(s);

SynthDef.new(\patch_stereo, { arg in = 0, out=0, amp = 1.0, amplag = 0.01;	Out.ar(out, In.ar(in, 2) * Lag.kr(amp, amplag));
}).send(s);

SynthDef.new(\br_vla, {arg in=1, dry=1.0, out=0, amp=1.0, windowsize=1.0, ratio=0.5;
	var input, shift;
	input = SoundIn.ar(in);
	shift = PitchShift.ar(input, windowsize, ratio);
	Out.ar(out, shift + (input * dry));
}).send(s);


SynthDef.new(\br_vox, {
	arg in=0, out=0, amp=1.0,
	verb_mix=0.24, verb_room=0.8, verb_damp=1.0, verb_lpf=4000,
	delaydc = 0.002,
	delaytime = 0.1,
	delaylpf = 1200,
	delayamp = 0.4,
	gate_thresh = 0.00001,
	gate_slope = 10.0,
	gate_clamp = 0.004, 
	gate_release = 0.05,
	comp_thresh = 0.5,
	comp_slope = 0.25,
	comp_clamp = 0.003,
	comp_release = 0.1;
	
	var input, gate, comp, eq, del, verb, output;
	
	input = SoundIn.ar(in);
	
	gate = Compander.ar(input, input, gate_thresh, gate_slope, 1.0, gate_clamp, gate_release);
	comp = Compander.ar(gate, input, comp_thresh, 1.0, comp_slope, comp_clamp, comp_release);

	del = DelayL.ar(comp, 1.0, delaytime);
	del = LPF.ar((del + DC.ar(delaydc)).softclip, delaylpf) * delayamp;

	verb = FreeVerb.ar(comp + del, 1.0, verb_room, verb_damp);
	verb = LPF.ar(verb, verb_lpf);
	output = comp * (1.0 - verb_mix) + (verb * verb_mix);
	
	Out.ar(out, output * amp);
}).send(s);



SynthDef.new(\bufdelay_fb_pan, {
	arg in=1, 
		out=0,
		buf=0,
		buflength = 1.0,
		amp = 1.0,
		inputamp = 1.0,
		delaytime= 1.0,
		feedback = 0.0,
		amplag = 0.1,
		pan=0.0;
	var delay, fb;
	delay = BufDelayL.ar(buf, (In.ar(in) * inputamp) + (LocalIn.ar(1)), delaytime) * amp;
	LocalOut.ar(delay * feedback);
	amp = Lag.kr(amp, amplag);
	Out.ar(out, Pan2.ar(delay * amp, pan) );

}).send(s);



s.sync;

~br_b = Bus.audio(s, 2);
~br_out = Synth.new(\patch_stereo, [\in, ~br_b.index, \out, 0], s);

~br_vla_b = Bus.audio(s, 1);
~br_vla_out = Synth.new(\patch_pan, [\in, ~br_vla_b.index, \out, ~br_b.index], ~br_out, \addBefore);

~br_vox_b = Bus.audio(s, 1);
~br_vox_out = Synth.new(\patch_pan, [\in, ~br_vox_b.index, \out, ~br_b.index], ~br_out, \addBefore);

~br_vla = Synth.new(\br_vla, [\out, ~br_vla_b.index], ~br_vla_out, \addBefore);
~br_vox = Synth.new(\god_vox, [\out, ~br_vox_b.index], ~br_vox_out, \addBefore);
~br_vox.set(\amp, -4.dbamp);

~del_buf = Buffer.alloc(s, s.sampleRate * 120.0);
0.1.wait;
~del_s = Synth.new(\bufdelay_fb_pan, [
	\in, ~br_vla_b.index,
	\out, ~br_b.index,
	\buf, ~del_buf.bufnum,
	\amp, 1.0,
	\fb, -24.dbamp
], ~br_out, \addBefore);

~del_on = false;
~del_tap = CfTapper.new;
~del_tapped = false;

/*
{
	~win = SCWindow.new;
	~win.front;
	~win.view.keyDownAction = { arg view, char;
		if (char == $ , {
			if (~del_tapped, {
				~del_tap.tap;
				~del_s.set(\delaytime, ~del_tap.time);
				~del_s.set(\amplag, ~del_tap.time * 2.0);
				~del_s.set(\amp, -3.dbamp);
				~del_tap.time.postln;
				~win.view.background = Color.white;
			}, {
				~del_tap.tap;
				~del_tapped = true;
				~win.view.background = Color.black;
			});
		});
	};
}.defer;
*/

// HID tap
~footswitch_func = { arg val;
	if (val == 0, {
		if (~del_tapped, {
				~del_tap.tap;
			~del_s.set(\delaytime, ~del_tap.time);
			//~del_s.set(\amplag, ~del_tap.time * 2.0);
			//~del_s.set(\amp, -3.dbamp);
			~del_tap.time.postln;
//			~win.view.background = Color.white;
		}, {
			~del_tap.tap;
			~del_tapped = true;
		});
	});
};

		

}.play; };