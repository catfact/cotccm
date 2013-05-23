~swp.value(110 * 2/3 * 16, 300);
~swp.value(110 / 3, 1);

~flt.set(\rq, 0.05);

~flt_recstart.value;
~flt_recstop.value(0);

~fltl_buf[0].plot;

~flt_recstart.value;
~flt_recstop.value(1);

~flt_recstart.value;
~flt_recstop.value(2);

~flt_recstart.value;
~flt_recstop.value(4);

~flt_recstart.value;
~flt_recstop.value(5);

~flt_recstart.value;
~flt_recstop.value(6);

~flt_recstart.value;
~flt_recstop.value(7);

~fltr_buf.plot;