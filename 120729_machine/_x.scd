~basepath = "/Users/e/scm/cotccm/120729_machine/";
x = { |p| this.executeFile(~basepath++p); };

s = Server.default;
 
Routine {
	x.value("arduino.scd");

	~but_func[3] = {};

	c = CfAudioContext.new(s, 8, { 

		
		Routine {
			x.value("_defs.scd");
			s.sync;		
			x.value("_jloop.scd");
			x.value("_threshchop.scd");
			x.value("_beet.scd");
						
									1.0.wait;
			x.value("_jloop_ctl_gnossienne.scd");
						
			~led0_on = 0.02;
			~led1_on = 0.04;
			~led0_off = 1.3;
			~led1_off = 1.4;
			
			~led0_r = Routine{inf.do{
				~ard_led_write.value(0, 1);
				~led0_on.wait;
				~ard_led_write.value(0, 0);
				~led0_off.wait;
			}}.play;
			
			
			~led1_r = Routine{inf.do{
				~ard_led_write.value(1, 1);
				~led1_on.wait;
				~ard_led_write.value(1, 0);
				~led1_off.wait;
			}}.play;
					
		}.play;	
		
	});
}.play;
 