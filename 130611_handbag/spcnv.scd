SynthDef(\pv_inv_ins, { arg in=0,  amp=0.5;
	var snd, chain;
	snd = In.ar(in, 1);
	chain = FFT(LocalBuf(2048), snd);

	chain = PV_Invert(chain);
	ReplaceOut.ar(in, 0.5 * IFFT(chain).dup);
}).send(s);





~spcnv = Array.fill(8, { arg i; Array.fill(5, { arg j; nil }); });

~spc = { arg i, j;
	if(~spcnv[i][j].isNil, {
		~spcnv[i][j] = Synth.new(\pv_inv_ins, [
			\in, ~fltlb[i][j].index
		], ~fltlg, \addAfter);
		postln("spc on " ++ i ++ " , " ++ j);
	}, {
		~spcnv[i][j].free;
		~spcnv[i][j] = nil;
		postln("spc off " ++ i ++ " , " ++ j);
	});
};



/*
5.do({ arg j;
	8.do({ arg i;
		postln(" ~spec.value(" ++ i ++ ", " ++ j ++ ")");
	});
});
*/


/*

 ~spc.value(0, 0)
 ~spc.value(1, 0)
 ~spc.value(2, 0)
 ~spc.value(3, 0)
 ~spc.value(4, 0)
 ~spc.value(5, 0)
 ~spc.value(6, 0)
 ~spc.value(7, 0)
 ~spc.value(0, 1)
 ~spc.value(1, 1)
 ~spc.value(2, 1)
 ~spc.value(3, 1)
 ~spc.value(4, 1)
 ~spc.value(5, 1)
 ~spc.value(6, 1)
 ~spc.value(7, 1)
 ~spc.value(0, 2)
 ~spc.value(1, 2)
 ~spc.value(2, 2)
 ~spc.value(3, 2)
 ~spc.value(4, 2)
 ~spc.value(5, 2)
 ~spc.value(6, 2)
 ~spc.value(7, 2)

 ~spc.value(0, 3)
 ~spc.value(1, 3)
 ~spc.value(2, 3)
 ~spc.value(3, 3)
 ~spc.value(4, 3)
 ~spc.value(5, 3)
 ~spc.value(6, 3)
 ~spc.value(7, 3)
 ~spc.value(0, 4)
 ~spc.value(1, 4)
 ~spc.value(2, 4)
 ~spc.value(3, 4)
 ~spc.value(4, 4)
 ~spc.value(5, 4)
 ~spc.value(6, 4)
 ~spc.value(7, 4)



*/