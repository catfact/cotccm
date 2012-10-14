// patterns


//example:


SynthDescLib.read;


a = Pseq([1, 2, 3], inf);

b = StreamClutch(a);


6.do({ b.next.postln });

b.connected = false;

6.do({ b.next.postln });



//statistical clutch

a = Pseq([1, 2, 3], inf);

b = StreamClutch(a, { 0.5.coin });


12.do({ b.next.postln });



//sound example:

(

var clutch, pat, decicion;

decicion = Pseq([Pn(true,10), Prand([true, false], 10)], inf).asStream;

pat = Pbind(\freq, Pseq([200, [300, 302], 400, 450], inf), \dur, 0.3);

clutch = StreamClutch(pat, decicion);

clutch.asEventStreamPlayer.play;

)


// independant stepping

(

var clutch, pat, decicion;

pat = Pbind(\freq, Pseq([200, [300, 302], 400, 450], inf), \dur, 0.3);

b = StreamClutch(pat);

b.connected = false;

b.asEventStreamPlayer.play;

)