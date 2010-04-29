w = GUI.window.new("103", Rect(0, 0, 640, 480));
w.front;

t = GUI.staticText.new(w, Rect(0, 0, 500, 500));
t.string = "nar";
t.font = Font("Courier", 40);
t.setProperty(\align, \center);
w.view.setProperty(\background, Color.blue);

~gui = { arg theString, theColor;
{
t.string = theString;
w.view.setProperty(\background, theColor);
}.defer;
};