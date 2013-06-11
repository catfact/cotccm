~rlen = 30.0;
~nl = 8;
// record buffer
~rbuf = Buffer.alloc(s, s.sampleRate * ~rlen, 1);
// loop buffers (copies)
~lbuf = Array.fill(~nl, { Buffer.alloc(s, s.sampleRate * ~rlen, 1) });

SynthDef.new(\rec, {
	arg in=0, buf=0,
	reclevel=1.0, prelevel=0.0, offset=0.0, trig=1.0, loop=1, run=1;

	RecordBuf.ar(In.ar(in, 1),
		bufnum: buf, 
		offset:0,
		recLevel:reclevel,
		preLevel:prelevel,
		run:run,
		loop:loop,
		trigger:trig
	);
}).send(s);

/// sweep filter


/// record output



/// toggle record and copy



//// play

