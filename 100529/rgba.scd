s = Server.local;
//s.options.inspect;

s.waitForBoot {
	
	~rgba_b = Array.fill(4, { Bus.control(s, 1); });
	
	~rgba_keys = [
		'/cfHistR',
		'/cfHistG',
		'/cfHistB',
		'/cfHistA'
	];
		
	~rgba_responders = ~rgba_keys.collect({arg key, num;
	key.postln;	
	 OSCresponderNode(nil, key, { arg t, r, msg;
//	 	msg[1].postln;
	 	~rgba_b[num].value_(msg[1]);
	 }).add;
	});
	
	//o = OSCresponderNode(nil, '/red', { |t, r, msg| msg[1].postln; });
	//o.add;
	//o.remove; 
	
	~cleanup = {
		~rgba_responders.do({ arg resp; resp.remove; });
		'removed'
	};
	
};

/*
~rgba_b[0].get({ arg val; val.postln; });
~rgba_b[1].get({ arg val; val.postln; });
~rgba_b[2].get({ arg val; val.postln; });
~rgba_b[3].get({ arg val; val.postln; });


~rgba_b

~cleanup.value;

*/