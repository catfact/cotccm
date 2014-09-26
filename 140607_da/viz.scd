
~txtfont = Font("Courier", 42);
~txtcolor = Color.white;
//~txtpoint = 0@0;
~postxt = List.new; //[ "cotccm", "121208"]; 
//~postxt.addFirst(["test1", "test2"]);

w.drawFunc = { |v|		
	var x=0;
	var y=0;
	~postxt.do({ |str|
		//		str.postln;
		str.drawAtPoint(x@y, ~txtfont, ~txtcolor);	
		y = y + 40;
		if (y > w.bounds.height, {y = 0; x = x + 500; });
	});
};

~post = { arg txt;
	~postxt = (~postxt.addFirst(txt));
	AppClock.sched(0, { w.refresh; nil });
};

/*
w.drawFunc = { |v|
	"aa hah ah aaa".drawAtPoint(~txpoint, ~txfont, ~txcolor);
};
w.refresh
*/

/*
~tfield = TextField(w, w.bounds);

w.bounds


~tfield.stringColor_(Color.white);
~tfield.string_("zazaza");

w.refresh;
	//w.close;
*/

/*
w = Window.new.front;

a = TextField(w, Rect(10, 10, 150, 20));

a.string = "hi there";

a.action = {arg field; field.value.postln; };*
*/

//~post.value();

~post.value("cotccm");
~post.value("121208");


//~post.value( Array.fill(100, { |i| (1 / i).asString }); );