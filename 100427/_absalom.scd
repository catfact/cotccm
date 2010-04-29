s = Server.local;
s.waitForBoot {
	~del = CfDelay4.new(s);
	

~del.del_s[0].set(\out, 0);
~del.del_s[1].set(\out, 1);
~del.del_s[2].set(\out, 0);
~del.del_s[3].set(\out, 1);

~del.del_s[0].set(\amp, 1.0);
~del.del_s[1].set(\amp, 1.0);
~del.del_s[2].set(\amp, 1.0);
~del.del_s[3].set(\amp, 1.0);

~del.del_s[0].set(\fb, 0.8);
~del.del_s[1].set(\fb, 0.8);
~del.del_s[2].set(\fb, 0.8);
~del.del_s[3].set(\fb, 0.8);

~del.del_s[0].set(\delaytime, 23.0);
~del.del_s[1].set(\delaytime, 19.0);
~del.del_s[2].set(\delaytime, 31.0);
~del.del_s[3].set(\delaytime, 27.0);

}
