d = ~dowse.data;
~durs = d.collect({|ev| ev.dur});
~durs = ~durs.select({|val| val.notNil});
~durs.maxItem



//// 