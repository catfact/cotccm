// =====================================================================
// SuperCollider Workspace
// =====================================================================
~grstopfirst.value;

~grkill.value
 
~grstartrec.value;
~grstoprec.value;

~grsyn.postln

~grstopplay.value;
~grsyn.first.set(\rate, 1/16);
~grsyn.first.set(\amp, -12.dbamp);
~grsyn.first.set(\amp, 0.0); //, -12.dbamp);
~grbuf[0].normalize;

~grsyn[1].set(\rate, 1.25);
~grsyn[2].set(\rate, 1.5);
~grsyn[2].set(\rate, 1.0);


~cluster_r = Routine { inf.do {
	~do_cluster.value(4, ioff:80, stride:24, amp: (-24.dbamp));
	24.wait;
	~do_cluster.value(4, ioff:400,stride:32,  amp: (-24.dbamp));
	24.wait;
	~do_cluster.value(4, ioff:600, stride:64, amp: (-24.dbamp));
	24.wait;

} }.play;

/*
~norm_buf.normalize;
~cluster_r.stop;
*/


~grsyn[0].set(\trigrate, 2.0, \durbase, 1.0);

~grsyn[0].set(\trigrate, 6.0);
~grsyn[0].set(\trignoise, 0.25);


//~grsyn[0].set(\durmin, 0.5);
//~grsyn[0].set(\durmax, 0.75);
~grsyn[0].set(\durnoise, 0.5);
~grsyn[0].set(\durbase, 4.0);
~grsyn[0].set(\posnoise, 0.50);
~grsyn[0].set(\amp, 1.0);

//~grsyn[0].set(\durmin, 0.5);
//~grsyn[0].set(\durmax, 0.75);
~grsyn[1].set(\rate, 0.25);
~grsyn[1].set(\amp, 1.0);
~grsyn[1].set(\durnoise, 0.25);
~grsyn[1].set(\durbase, 1.0);
~grsyn[1].set(\posnoise, 0.125);

/*
~analist_pitch.size
*/

