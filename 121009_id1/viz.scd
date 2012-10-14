//p.free;

p = EmacsBuffer.new;
~plabels = [\freq, \wait];
~txt = Dictionary.new;

~plabels.do({ 
	arg lab;
	~txt.put(lab ++ '_lab', EmacsText(p, lab ++ ' _ ' , 10));
	~txt.put(lab, EmacsText(p, "", 10));
	p.newline;
});

~txtv = { arg key, val;
	key.postln;
	~txt[key].postln;
	~txt[key].string = val;
};


/*

w = Window.new.front;

w.view.background_(Color.white);

w.drawHook = {

"abababababa\n\n\n".scramble.draw

};

w.refresh


*/