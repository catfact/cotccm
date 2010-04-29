~vla_output_p = Synth.new(\patch, [\in, ~vla_b.index, \out, ~vla_out_b.index], ~out_g, \addToHead);
~vla_output_p.set(\amp, -6.dbamp);

~ezv_output_p = Synth.new(\patch, [\in, ~ezv_b.index, \out, ~ezv_out_b.index, \amp, -20.dbamp], ~out_g, \addToHead);
~ezv_output_p.set(\amp, -16.dbamp);
~ezv_output_p.set(\amp, 0);