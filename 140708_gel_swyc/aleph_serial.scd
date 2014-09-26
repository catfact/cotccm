~aleph_port  = SerialPort("/dev/ttyACM0", 57600, crtscts:true);


// button state
~but = Array.fill(4, { false });
// debouncing
~but_time = Array.fill(4, { SystemClock.seconds });
 
// button responder funtcion
~but_func = Array.fill(4, { arg i; { arg state;
	postln("button " ++ i ++ " state is " ++ state);
} });

// loop on serial read
~but_read = Routine {
	var byte, time;
	var state = 0;
	var bounce = 0.01;
	var b0 = false;
	var i = 0; // 1 button only for right now

	inf.do({
		while({ byte = ~aleph_port.read; byte.notNil }, {
			("serial: " ++ byte).postln;
			// magic numbers;
			if(byte == 2, { 
				b0 = true;
			}, {
				if(b0, { 
					// 2nd byte, take as data
					state = (byte > 0);
					//					state.postln;
					if ( state != ~but[i], {
						// state changed, debounce
						time = SystemClock.seconds;
						if( (time - ~but_time[i]) >= bounce, {
							~but_time[i] = time;
							~but[i] = state;
							~but_func[i].value(state);
							postln("debounce ok : " ++ i);
						});
					});
				});
				b0 = false;
			});
			
			
		
			
			
			//			byte.postln;
			//			4.do({ arg i;
			//				state = (byte & (1 << i)) > 0;
			//				[byte, i, state].postln; 

			/*

				if ( state != ~but[i], {
					// state changed, debounce
					time = SystemClock.seconds;
					if( (time - ~but_time[i]) >= bounce, {
						~but_time[i] = time;
						~but[i] = state;
						~but_func[i].value(state);
					});
				});
			//			});
			*/
		});
	});
}.play;



/*
	~but_read.stop;
*/