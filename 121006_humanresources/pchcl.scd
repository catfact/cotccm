~rat = [4/3, 1, 4/5, 1, 3/2, 1, 4/6, 1, 5/8, 5/4, 3/4];

//// pitch change

~pit_r = Routine { inf.do { arg i;	
	~voxcl_pitch = ~rat.wrapAt(i);
	~gr[0].grrate_b.set(~rat.wrapAt(i + 1));
	~gr[1].grrate_b.set(~rat.wrapAt(i + 2));
	~gr[2].grrate_b.set(~rat.wrapAt(i + 3));
	~gr[3].grrate_b.set(~rat.wrapAt(i + 4));
	1.0.wait;
} };

~but_func[1] = { arg state;
	if(state, {
		~pit_r.next;
	});
}