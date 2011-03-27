s = Server.default.boot;
s.waitForBoot { Routine {

~del = CfDelay4.new(s, s);

1.0.wait;

~del.del_in_s.set(\in, 1);
~del.del_s.do({ arg syn; syn.set(\filtermix, 0.5); });

~del_out_b = Bus.audio(s, 1);


SynthDef.new(\patch, {arg in=0, out=0, amp=1, amplag = 0.01;
	var sig;
	amp = Lag.kr(amp, amplag);
	sig = InFeedback.ar(in);
	Out.ar(out, sig * amp);
}).send(s);


1.0.wait;

~del.del_s.do({ arg syn, i;
	syn.set(\band, 0.0);
	syn.set(\amp, 1.0);
	syn.set(\fb, 0.5);
	syn.set(\delaytime, (i + 1) * 4.0); 
	syn.set(\rq, 1.0);
	
	~del.del_s.do({ arg syn; syn.set(\out, ~del_out_b.index); });
}); 


~del_out_s = Synth.new(\patch, [\in, ~del_out_b.index, \out, 0], s, \addToTail);



	~del_taps = Array.fill(4, { CfTapper.new; });
	
	~del_which = 0;
	
	~del_pad_r = CCResponder({
		arg src, chan, num, val;
		var i = num-13;
		if (val > 0, {
			// press
			~del_taps[i].tap;
			~del.del_s[i].set(\delaytime, ~del_taps[i].time);
			~del.del_s[i].set(\filterlag, ~del_taps[i].time);
		}, { 
			// lift
			//~stop_record.value(i);
		});
		~del_which = i;
	}, nil, nil, {|num| (num>12) && (num<17) });
	
	~del_knob_r = CCResponder({
		arg src, chan, num, val;
		var i = num-5;
		postln("del knob "++i);
		if (val ==0, {
			~del.del_s[i].set(\amp, 0.0);
		} , {
			~del.del_s[i].set(\amp, ((1 - (val/ 127)) * -30).dbamp);
		});
		
		~del_which = i;
	}, nil, nil, {|num| (num>4) && (num<9) });

	~del_note_r = NoteOnResponder({
		arg src, chan, num, vel;
		[src, chan, num, vel].postln;
		~del_note_func.value(src, chan, num, vel);
	}, nil, nil, nil, nil);

	~del_note_func = { arg src, chan, num, vel; 
		~del.del_s[~del_which].set(\hz, (num + 0.2).midicps);
	};

}.play; };

//~del.del_s[0].set(\delaytime, 1.0);

