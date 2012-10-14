
~pos = 20.0;
~atk = 0.25;
~sus = 1.0;
~rel = 1.0;
~hz = 400;
~rate = 0.75;
~rq = 0.25;
~tw = 0.5;

~amp = 0.5;
~atk=2.0;
~tw = 1.0;
~crchop.value(0);


~hzl = ~analist.collect({ arg ev; ev.pitch });
~hzl.plot;

~chopev[0].hz = ~hzl[200];

~hzl[200];

~hz = ~hzl[250];


~tw = 9/5;
~rate = 2.0;
~pos = 10.0;
~crchop.value(2);

~rate = 0.5;
~amp = 0.5;
~hz = ~hzl[400];
~rq = 0.4;
~pos = 30.0;
~atk = 1.0;
~sus = 2.0;
~rel = 4.0;
~tw = 3.0;
~crchop.value(3);
~chopev[3].amp = 0.125;


~rate = 1.5;
~tw = 9.0;
~sus = 2.0;
~rel = 4.0;
~amp = 0.0625;
~pos = 222.0;
~crchop.value(9);
~tw = 9.25;
~crchop.value(10);
~tw = 9.75;
~crchop.value(11);
~tw = 10.5;
~crchop.value(12);

[9, 10, 11, 12].do({ arg i; ~chopev[i].hz = ~hzl[300] * (i + 2); });
[9, 10, 11, 12].do({ arg i; ~chopev[i].rq = 0.2; });

[9, 10, 11, 12].do({ arg i; ~chopev[i].amp = -34.dbamp; });



~analist.sortBy({ arg ev; ev.pitch });


~rate = 0.125;
~pos = 8.0;
~hz = 200;
~rq = 1.0;
~crchop.value(13);
~tw = 12.0;
~amp = 0.5;
~crchop.value(14);


~chopev[0].hz = ~hzl[100];
~chopev[1].hz = ~hzl[120];


~chopev[0].rq = 0.3;
~chopev[1].rq = 0.3;




[250, 251, 252, 253, 254].do({ arg i; i.postln; });

~chopr[0].play;

~chopev[0].atk = 10.0;
~chopev[1].atk = 10.0;


~chopev[0].rel = 10.0;
~chopev[1].rel = 10.0;


~chopev[0].sus = 30.0;
~chopev[1].sus = 30.0;

~chopev[0].tw = 60.0;
~chopev[1].tw = 80.0;

~chopev[0].amp = 0.5;
~chopev[1].amp = 0.5;


~chopev[0].amp = 0.5;
~chopev[1].amp = 0.5;

~pos = 30.0;
~amp = 0.5;
~tw = 100.0;
~rate = 2.3;
~atk=30.0;
~sus=30.0;
~rel=30.0
~crchop.value(20);

~pos = 40.0;
~tw = 110.0;
~rel = 40.0;
~crchop.value(21);

~pos = 180.0;
~rate = 0.5;
~tw = 120.0;
~hz = ~hzl[500];
~crchop.value(30);
~rq = 0.4;
~hz = ~hzl[510];
~rate = 5/8;
~amp = 0.25;
~crchop.value(31);
~chopev[30].amp = 0.25;
~chopev[30].rq = 0.4;

//~chopev[0].pos = 0.5;
//~chopev[1].amp = 0.5;


Synth.new('rlpfsawsin', [\hz, ~analist[550].pitch , \rel, 30.0, \amp, 0.0625], s);
Synth.new('rlpfsawsin', [\hz, ~analist[551].pitch , \rel, 30.0, \amp, 0.0625 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[552].pitch , \rel, 30.0, \amp, 0.0625 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[553].pitch , \rel, 30.0, \amp, 0.0625 ], s);


Synth.new('rlpfsawsin', [\hz, ~analist[70].pitch , \atk, 40, \rel, 180.0], s);
Synth.new('rlpfsawsin', [\hz, ~analist[80].pitch , \atk, 50, \rel, 180.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[90].pitch , \atk, 60, \rel, 170.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[100].pitch , \atk, 70, \rel, 160.0 ], s);

Synth.new('rlpfsawsin', [\hz, ~analist[170].pitch , \rel, 300.0, \amp, 0.0625, \atk, 120.0], s);
Synth.new('rlpfsawsin', [\hz, ~analist[180].pitch , \rel, 300.0, \amp, 0.0625, \atk, 120.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[190].pitch , \rel, 300.0, \amp, 0.0625, \atk, 120.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[200].pitch , \rel, 300.0,
Synth.new('rlpfsawsin', [\hz, ~analist[170].pitch , \rel, 300.0, \amp, 0.0625, \atk, 120.0], s);
Synth.new('rlpfsawsin', [\hz, ~analist[180].pitch , \rel, 300.0, \amp, 0.0625, \atk, 120.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[190].pitch , \rel, 300.0, \amp, 0.0625, \atk, 120.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[200].pitch , \rel, 300.0, \amp, 0.0625, \atk, 120.0 ], s);
 \amp, 0.0625, \atk, 120.0 ], s);
x

Synth.new('rlpfsawsin', [\hz, ~analist[270].pitch , \rel, 300.0, \amp, 0.0625, \atk, 120.0], s);
Synth.new('rlpfsawsin', [\hz, ~analist[280].pitch , \rel, 300.0, \amp, 0.0625, \atk, 120.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[290].pitch , \rel, 300.0, \amp, 0.0625, \atk, 120.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[300].pitch , \rel, 300.0, \amp, 0.0625, \atk, 120.0 ], s);


Synth.new('rlpfsawsin', [\hz, ~analist[470].pitch , \rel, 30.0], s);
Synth.new('rlpfsawsin', [\hz, ~analist[471].pitch , \rel, 30.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[472].pitch , \rel, 30.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[473].pitch , \rel, 30.0 ], s);


Synth.new('rlpfsawsin', [\hz, ~analist[570].pitch , \rel, 240.0, \atk, 30.0, \sus, 200.0, ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[571].pitch , \rel, 240.0 , \atk, 30.0, \sus, 200.0, ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[572].pitch , \rel, 240.0 , \atk, 30.0, \sus, 200.0, ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[573].pitch , \rel, 240.0 , \atk, 30.0, \sus, 200.0, ], s);


Synth.new('rlpfsawsin', [\hz, ~analist[670].pitch , \rel, 240.0, \atk, 30.0, \sus, 200.0, ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[671].pitch , \rel, 240.0 , \atk, 30.0, \sus, 200.0, ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[672].pitch , \rel, 240.0 , \atk, 30.0, \sus, 200.0, ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[673].pitch , \rel, 240.0 , \atk, 30.0, \sus, 200.0, ], s);

Synth.new('rlpfsawsin', [\hz, ~analist[680].pitch , \rel, 240.0, \atk, 30.0, \sus, 200.0, ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[690].pitch , \rel, 240.0 , \atk, 30.0, \sus, 200.0, ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[700].pitch , \rel, 240.0 , \atk, 30.0, \sus, 200.0, ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[710].pitch , \rel, 240.0 , \atk, 30.0, \sus, 200.0, ], s);



Synth.new('rlpfsawsin', [\hz, ~analist[320].pitch , \rel, 300.0], s);
Synth.new('rlpfsawsin', [\hz, ~analist[310].pitch , \rel, 300.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[300].pitch , \rel, 300.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[290].pitch , \rel, 300.0 ], s);


Synth.new('rlpfsawsin', [\hz, ~analist[220].pitch , \rel, 300.0], s);
Synth.new('rlpfsawsin', [\hz, ~analist[200].pitch , \rel, 300.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[180].pitch , \rel, 300.0 ], s);
Synth.new('rlpfsawsin', [\hz, ~analist[160].pitch , \rel, 300.0 ], s);




~analist[50].pitch
~analist.size;



s.record;


q = 0;


~zr = Routine { inf.do {
	q = ((q + 10) % 99);
	Synth.new('rlpfsawsin', [\hz, ~analist[170 + q ].pitch , \rel, 300.0, \amp, 0.03, \atk, 120.0], s);
	4.0.wait;
	Synth.new('rlpfsawsin', [\hz, ~analist[171 + q ].pitch , \rel, 300.0, \amp, 0.03, \atk, 120.0], s);
 4.0.wait;
	Synth.new('rlpfsawsin', [\hz, ~analist[200 + q ].pitch , \rel, 300.0, \amp, 0.03, \atk, 120.0 ], s);
	4.0.wait;
	Synth.new('rlpfsawsin', [\hz, ~analist[201 + q ].pitch , \rel, 300.0, \amp, 0.03, \atk, 120.0 ], s);
	4.0.wait;
	Synth.new('rlpfsawsin', [\hz, ~analist[250 + q ].pitch , \rel, 300.0, \amp, 0.03, \atk, 120.0 ], s);
	4.0.wait;
	Synth.new('rlpfsawsin', [\hz, ~analist[251 + q ].pitch , \rel, 300.0, \amp, 0.03, \atk, 120.0 ], s);
	4.0.wait;
	Synth.new('rlpfsawsin', [\hz, ~analist[400 + q ].pitch , \rel, 300.0, \amp, 0.03, \atk, 120.0 ], s);
	4.0.wait;
	Synth.new('rlpfsawsin', [\hz, ~analist[401 + q ].pitch , \rel, 300.0, \amp, 0.03, \atk, 120.0 ], s);
	4.0.wait;
	Synth.new('rlpfsawsin', [\hz, ~analist[450 + q ].pitch , \rel, 300.0, \amp, 0.03, \atk, 120.0 ], s);
	4.0.wait;
	Synth.new('rlpfsawsin', [\hz, ~analist[451 + q ].pitch , \rel, 300.0, \amp, 0.03, \atk, 120.0 ], s);
	4.0.wait;
	Synth.new('rlpfsawsin', [\hz, ~analist[500 + q ].pitch , \rel, 300.0, \amp, 0.03, \atk, 120.0 ], s);
	4.0.wait;
	Synth.new('rlpfsawsin', [\hz, ~analist[501 + q ].pitch , \rel, 300.0, \amp, 0.03, \atk, 120.0 ], s);
	4.0.wait;
	(500.wait);
} }.play;


s.stopRecording


~hzl.do({ arg hz; hz.post; ", ".postln; });

~bbuf.plot;