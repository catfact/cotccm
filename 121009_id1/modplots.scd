a = 9;
b = 17;

x = 1;

z = Array.newClear(100);

100.do({ arg i;
	x = (a*x) % b;
	z[i] = x;
});


z.plot;

z




/*
[4, 13]
[9, 17]
*/