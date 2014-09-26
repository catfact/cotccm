w = Window("crypt", Window.screenBounds);
q = w.addFlowLayout( 0@0, 0@0 );
w.front;
/*
w.fullScreen(false);
*/


// grain trig rate change
~gr_rate_num = NumberBox(w, Rect(0, 0, 160, 60));
~gr_rate_num.font = Font.new("Arial", 28);
w.view.keyDownAction = {
	arg  view, char, modifiers, unicode, keycode, key;
	var num = switch(char,
		$1, {1},
		$2, {2},
		$3, {3},
		$4, {4},
		$5, {5},
		$6, {6},
		$7, {7},
		$8, {8},
		$9, {9}
	);
	num.postln;
	if(num.notNil, {

	~gr_rate_num.value_(num);
		~gr.do({ arg gr, i;
			gr.grtrig_s.set(\hz, (2 + i) * num / 10);
			gr.grdur_b.set(4.0 / (6 + (i * 2)) / num * 20);
		});
		~gr2.do({ arg gr, i;
			gr.grtrig_s.set(\hz, (4 + (i * 0.5)) * num / 10);

			gr.grdur_b.set(4.0 / (6 + (i * 2)) / num * 20);
		});
	});
};

//// nuttons
q.nextLine;
~clar_dur =24;
~clar_but = Array.fill(64, {
	arg i;
	var but;
	var off = (i / 63) * (~analist.size - 14).floor;
	but = Button(w, Rect(0, 0, 160, 40));
	but.states = [["CLAR_"++off, Color.black, Color.grey],
	["CLAR_"++off, Color.grey, Color.black]];
	but.action = {
		~clar.value(9 + 4.rand, ~clar_dur, off);
	};
});

q.nextLine;
q.nextLine;
//
~flat_dur =24;
~flat_but = Array.fill(64, {
	arg i;
	var but;
	var off = (i / 63) * (~analist.size - 14).floor;
	but = Button(w, Rect(0, 0, 160, 40));
	but.states = [["FLAT_"++off, Color.black, Color.grey],
		["FLAT_"++off, Color.grey, Color.black]];
	but.action = {
		~flat.value(9 + 4.rand, ~flat_dur, off);
	};
});