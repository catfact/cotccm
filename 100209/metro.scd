s = Server.local;
s.quit; s.boot;


SystemClock.sched(0.0, {

SynthDef.new(\metro, {arg out=0, amp=0.25, lpfhz=600, ringhz=100, impulsehz=1.0, ringtime=2.0;
	Out.ar(out, Pan2.ar(LPF.ar(Ringz.ar(Impulse.ar(impulsehz), ringhz, ringtime), lpfhz)) );
}).load(s);

~metro = Synth.new(\metro, [
	\impulsehz, 1.0 / 1.2, //1.15,
	\ringhz, (55.midicps / 4.0),
	\ringtime, 6.0,
	\lpfhz, 300
]);

nil  });
	
	
~metro.set(\lpfhz, 300);
~metro.set(\amp, 0.125);
~metro.free;

~metro = { Pan2.ar(LPF.ar(Ringz.ar(Impulse.ar(1.0 / 1.2), 220), 600)) * (-12.dbamp)  }.play;
~metro.free;

~