NetAddr.langPort.postln;
OSCFunc.trace(true);
OSCFunc.trace(false);


//'a' ++ 'b/' ++ 6.asSymbol


/// map multislider to cross-patch amplitudes

~xpatch = Array.fill(8, { |i|
	Array.fill(8, { |j|
		OSCFunc( { 			
			|msg, time, addr, recvPort|
			~echo_patch[i][j].set(\amp, msg[1] * 0.25);
		}, '/2/multifader' ++ i.asSymbol ++ '/' ++ j.asSymbol );

	});
});

