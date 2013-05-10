~beat = 60.0 / 85.0;
~voch_s[0].set(\delaytime, ~beat*2.0, \feedback, -3.dbamp, \amp, 1.0, \in, 1);
~voch_s[1].set(\delaytime, ~beat*4, \feedback, 0.0, \amp, 1.0, \in, 1);

~voch_s[2].set(\delaytime, ~beat*2.0, \feedback, 0.25, \amp, 1.0);
~voch_s[3].set(\delaytime, ~beat*4, \feedback, 0.25, \amp, 1.0);


~voch_s[4].set(\delaytime, ~beat*2.25, \feedback, 0.125, \amp, 1.0, \in, 1);
~voch_s[5].set(\delaytime, ~beat*2.25, \feedback, 0.0625, \amp, 1.0);