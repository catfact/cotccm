// counter
~mi = 0;
// flag
~reset = 1;

~metro_event = {
	//// play viola loop
	if((~mi % 2) == 0, {
		~vlop_play.value((~mi/2) % 8);
	});
	~mi = ~mi + 1;
};