~echo_s[0].set(\svf_mix, 1.0);
~echo_s[0].set(\svf_hz, 220.0);
~echo_s[0].set(\svf_lo, 1.0);
~echo_s[0].set(\svf_res, 0.08);
~echo_s[0].set(\fb, 0.1);

~echo_s[1].set(\svf_mix, 1.0);
~echo_s[1].set(\svf_hz, 220.0 * 5/4);
~echo_s[1].set(\svf_lo, 1.0);
~echo_s[1].set(\svf_res, 0.09);
~echo_s[1].set(\fb, 0.1);

~echo_s[2].set(\svf_mix, 1.0);
~echo_s[2].set(\svf_hz, 110.0 * 4/5 * 4);
~echo_s[2].set(\svf_lo, 1.0);
~echo_s[2].set(\svf_res, 0.1);

~echo_s[3].set(\svf_mix, 1.0);
~echo_s[3].set(\svf_hz, 110.0);
~echo_s[3].set(\svf_lo, 0.4);
~echo_s[3].set(\svf_band, 0.3);
~echo_s[3].set(\svf_res, 0.05);
~echo_s[3].set(\fb, 0.13);



~echo_s[3].set(\svf_mix, 0.0);
~echo_s[4].set(\svf_mix, 0.0);
~echo_s[5].set(\svf_mix, 0.0);
~echo_s[6].set(\svf_mix, 0.0);

~echo_s[4].set(\fb, 0.8);
~echo_s[5].set(\fb, 0.6);
~echo_s[6].set(\fb, 0.8);
~echo_s[7].set(\fb, 0.8);


~echo_s[2].set(\svf_mix, 1.0);
~echo_s[2].set(\svf_hz, 330.0);
~echo_s[2].set(\svf_lo, 1.0);
~echo_s[2].set(\svf_res, 0.8);

~echo_s.do({ arg syn;
	syn.set(\svf_mix, 1.0);
	syn.set(\svf_hz, 330.0);
	syn.set(\svf_lo, 1.0);
	syn.set(\svf_res, 0.2);
	syn.set(\fb, 0.2);
});

~echo_s.do({ arg syn; syn.set(\fb, 0); });

~echo_patch.do({ arg arr; 
	arr.do({ arg syn;
		syn.set(\amp, 0.0);
	});
});

