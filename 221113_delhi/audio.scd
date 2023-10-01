s = Server.default;
s.options.numInputBusChannels = 2;
//s.options.numOutputBusChannels = 4;

//s.options.inDevice = "Universal Audio Thunderbolt";
//s.options.outDevice = "Universal Audio Thunderbolt";

s.waitForBoot {
	Routine {
		var outChannel;
		// for Arrow:
		outChannel=2;
		// testing internal:
//		outChannel = 0;

		// audio I/O
		~vla_b = Bus.audio(s, 1);

		/// live input
		~vla_in_s = { Out.ar(~vla_b.index, SoundIn.ar(0)) }.play(s);

		~ig = Group.new(s);
		~xg = Group.after(~ig);
		~og = Group.after(~xg);

		~out_b = Bus.audio(s, 2);

		~out_s = { arg out=0, amp=1.0;
			Out.ar(out, In.ar(~out_b, 2) * amp)
		}.play(~og, args:[\out, outChannel]);

		/*
		~test_sine = {
			arg out=0, hz=220, detune=2, amp=0.1;
			Out.ar(out, SinOsc.ar([hz+detune, hz-detune]) * amp);
		}.play(~xg, args:[\out, ~out_b.index]);

		s.sync;
		~test_sine.set(\out, ~out_b.index);
		*/

		/*
		~test_sine.free;
		*/

		postln("done initializing audio system");
		c.unhang;

	}.play;
}