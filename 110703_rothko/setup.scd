~grbuflist = List.new;
~grbuflen=60.0;
~numbufs = 4;

s.boot;
s.waitForBoot { Routine {

	
	SynthDef.new(\record_adc, { arg in=0, buf=0, loop=1, recLevel=1.0, preLevel=0.0, offsetSamps=0, doneAction=0;
		RecordBuf.ar(SoundIn.ar(in), buf, loop:loop, recLevel:recLevel, preLevel:preLevel, offset:offsetSamps, doneAction:doneAction);	
	}).store;	
	
	~numbufs.do({ 
		~grbuflist.add ( Buffer.alloc(s, s.sampleRate * ~grbuflen) );
	});
		
}.play; };



/*


~rec_s.run(false);
~rec_s.run(true);
~rec_s.free;

~grbuflist[0]
~grbuflist[0].plot;

~grbuflist[0].write("rothkosrc.aiff", "AIFF");

~grbuflist[0].read("rothkosrc.aiff");

x = { Out.ar(0, PlayBuf.ar(1, ~buf.bufnum, 1.0)); }.play; 
x.free;

*/
