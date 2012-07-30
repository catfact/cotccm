
postln("gnossienne loop controls");

	///// controls
	~jlstate = Array.fill(~jl_num, { 0 });
	~jli = 0;
	
	/*
	~but_func[2] = { arg state;
		if(state, {
			~jli = (~jli + 1) % ~jl_num;
		});
	};
	*/
	
	~altrates = [3/2, 4/3, 4/3, 4/3, 4/3, 4/3, 4/3, 4/3, 4/3, 4/3, 4/3, 4/3, 4/3];
	~rateidx = 0;
	~but_func[2] = { arg state;
		var rate;
		if(state, {
			~jl_play_s.do({ arg syn, i;
				rate = ~altrates.wrapAt(~rateidx) * ( 2 ** ((i % 2) - 1));
				syn.set(\rate,  rate);
				
			});
			~beet_rbase = rate;
			~rateidx = ~rateidx + 1;
		}, {
			~jl_play_s.do({ arg syn, i;
				syn.set(\rate, 1.0);
				~beet_rbase = 1.0;
			});
		});
	};
	
	~tbaset = 0;
	~but_func[0] = { arg state;
		postln("gnossiene responder");
		("loop button state: " ++ state ++ " , index: " ++ ~jli ++ ", loopstate: " ++ ~jlstate[~jli]).postln;
		if(state, {
			
			~jlstate[~jli].switch(
			0, {
				if((~jli == 0), {
					~tbaset = SystemClock.seconds;
				});
					
				~jl_start_record.value(~jli);
				~jlstate[~jli] = 1;
				~led0_on=0.2; ~led0_off=0.05; ~led0_r.next;
			},
			1, {
				~jl_stop_record.value(~jli);
				~jlstate[~jli] = 2;
				
				if((~jli == 0), {
					~tbaset = SystemClock.seconds - ~tbaset;
					~beet_t = ~tbaset * 0.25;
					~chopr_p = ~tbaset * 0.125;
				});
				
				~led1_on=0.2; ~led1_off=0.05; ~led1_r.next;
				~led0_on=0.02; ~led0_off=1.5; ~led0_r.next;
			},
			
			2, { 
				~jlstate[~jli] = 3;
				~jli = (~jli + 1) % ~jl_num;
			},
			3, {			
				~jl_clear.value(~jli);
				~jlstate[~jli] = 0;
				~led1_on=0.02; ~led1_off=1.5; ~led1_r.next;
				~led0_on=0.02; ~led0_off=1.5; ~led0_r.next;
			});
		});
	};
