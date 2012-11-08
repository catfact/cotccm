// serial code for arduino with 4 switches, 2 leds
// very simple protocol, state of 4 switches is stored as a byte
// state change triggers serial message
// arduino code at the bottom

//~ard_port = SerialPort("/dev/tty.usbserial-A4001lsj", 57600, crtscts:true);
~ard_port = SerialPort("/dev/ttyUSB0", 57600, crtscts:true);

// button state
~but = Array.fill(4, { false });
// debouncing
~but_time = Array.fill(4, { SystemClock.seconds });

// button responder funtcion
~but_func = Array.fill(4, { arg i; { arg state;
	postln("button " ++ i ++ " state is " ++ state);
} });

// loop on serial read
~ard_but_read = Routine {
	var byte, state, time;
	var bounce = 0.01;
	inf.do({
		while({ byte = ~ard_port.read; byte.notNil }, {
			4.do({ arg i;
				state = (byte & (1 << i)) > 0;
				//				[byte, i, state].postln; 
				if ( state != ~but[i], {
					// state changed, debounce
					time = SystemClock.seconds;
					if( (time - ~but_time[i]) >= bounce, {
						~but_time[i] = time;
						~but[i] = state;
						~but_func[i].value(state);
					});
				});
			});
		});
	});
}.play;


~led = 0;
~ard_led_write = { arg idx, val; 
	if (val == 0, {
		~led = ~led & ((1 << idx).bitNot);
	}, {
		~led = ~led | (1 << idx);
	});
	~ard_port.put(~led);
};

/* test:
~wr = Routine {
	var byte = 0;
	var t = 0.5;
	var mul;
	inf.do({
		byte = byte + 1;
		if (byte > 3, { byte = 0; });
//		[byte & 0x01, byte & 0x02].postln;
	 	p.put(byte);
	 	if (t < 0.1, {
		 	mul = 9/8;
	 	});
	 	if (t >= 0.5, {
		 	mul = 7/8;
	 	});
	 	t = t * mul;
//	 	[t, byte].postln;
		t.wait;
	});
};
*/


/*
// arduino code:

// needs pullup / pulldown (10k works)
const int butPin0 = 2;    
const int butPin1 = 3;    
const int butPin2 = 4;    
const int butPin3 = 5;

const int ledPin0 =  13;  
const int ledPin1 =  12;  

// char as byte array
char butState = 0;
char butStateLast = 0;
char tmp;

void setup() {
  pinMode(ledPin0, OUTPUT);      
  pinMode(ledPin1, OUTPUT);      
  pinMode(butPin0, INPUT);     
  pinMode(butPin1, INPUT);     
  pinMode(butPin2, INPUT);     
  pinMode(butPin3, INPUT);     
  Serial.begin(57600);
}

void loop(){
  // read the state of the pushbutton value:
  butState = 0;
  tmp = digitalRead(butPin0);
  if(tmp > 0) butState |= 0x1;
  tmp = digitalRead(butPin1);
  if(tmp > 0) butState |= 0x2;
  tmp = digitalRead(butPin2);
  if(tmp > 0) butState |= 0x4;
  tmp = digitalRead(butPin0);
  if(tmp > 0) butState |= 0x8;
  
  if (butState != butStateLast) {
     Serial.write(butState);
  }
  butStateLast = butState;
}

void serialEvent() {
  while (Serial.available()) {
    char inByte = (char)Serial.read();
    if (inByte & 0x1) {     
      digitalWrite(ledPin0, HIGH);  
    } 
    else {
      digitalWrite(ledPin0, LOW); 
    }
    
    if (inByte & 0x2) {     
      digitalWrite(ledPin1, HIGH);  
    } 
    else {
      digitalWrite(ledPin1, LOW); 
    }
  }
}
*/