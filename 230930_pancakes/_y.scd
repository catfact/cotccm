s = Server.local;
s.options.numInputBusChannels = 4;

~hwInChannels = 1;
//~hwInChannels = 2;
~hwOutChannels = 2;
~hwInChannelOffset = 0;
~hwOutChannelOffset = 0;

s.waitForBoot { Routine {

	// main busses and groups
	c = ZAudioContext.new(s,
		~hwInChannels,
		~hwOutChannels,
		~hwInChannelOffset,
		~hwOutChannelOffset,
	);
	s.sync;

	ZMultiTap.bufferDuration = 64;
	ZMultiTap.sendSynthDefs(s);
	s.sync;

	n = 2;
	z = ZMultiTap.new(n, c);
	s.sync;
	z.synth[\input].set(\pos, 0);
	z.setTapPosition(0, -1);
	z.setTapPosition(1, 1);

	// a volume taper. why not try an s-curve...
	~taper = { arg midi;
		var amp = (midi.linlin(0, 127, 0, pi) - pi).cos + 1 / 2;
		[amp, amp.ampdb].postln;
		amp
	};

	// midi controls
	m = ZSimpleMidiInput.new(connectAll:true);
	m.verbose = true;

	// these CC numbers are quite arbitrary, please change!
	m.cc(0, { arg ccVal;
		z.setTapLevel(0, ~taper.value(ccVal));
	});

	m.cc(1, { arg ccVal;
		z.setTapLevel(1, ~taper.value(ccVal)); });

	m.cc(2, { arg ccVal;
		var delayTime = ccVal.linexp(0, 127, 4, 32.0);
		postln("delay time 1: " ++ delayTime);
		z.setTapDelay(0, delayTime);
	});

	m.cc(3, { arg ccVal;
		// FIXME: do something nicer wit this, like just intonation ratios
		var delayTime = ccVal.linexp(0, 127, 4, 32.0);
		postln("delay time 2: " ++ delayTime);
		z.setTapDelay(1, delayTime);
	});

	m.cc(4, { arg ccVal;
		var position= ccVal.linlin(0, 127, -1, 1);
		postln("pan position 1:" ++ position);
		z.setInputBalance(0, position);
	});

	m.cc(5, { arg ccVal;
		//		var position= ccVal.linlin(0, 127, -1, 1);
		//		postln("pan position 2:" ++ position);
		//		z.setTapPosition(1, position)
		var focus = ccVal.linlin(0, 127, 1, 0);
		postln("shape focus 1: " ++ focus);
		z.setShapeFocus(0, focus);
	});

	~ratioSet = [6/5, 4/3, 3/2, 8/5, 2, 12/5, 3];

	s.sync;

	~noiser = Array.fill(2, { arg i;
		{
			var bus = z.bus[\tap][i].index;
			var aenv = EnvGen.ar(Env.asr(4, 1, 12, \welch), \gate.kr(0));
			var noise = BrownNoise.ar * \level.kr(-12.dbamp);
			var input = In.ar(bus);
			ReplaceOut.ar(bus, (aenv * noise) + ((1-aenv)*input));
		}.play(z.group[\tap], addAction:\addAfter);
	});

	m.cc(6, { arg ccVal;
		var ratioIndex = ccVal.linlin(0, 127, 0, ~ratioSet.size-1);
		var ratio = ~ratioSet[ratioIndex];
		postln("slew ratio : " ++ ratio);
		n.do({ arg i;
			z.synth[\tap][i].set(\delayTimeSlewUp, ratio + 1);
			z.synth[\tap][i].set(\delayTimeSlewDown, ratio - 1);

		});
	});


	~lfo1 = ZMapLfo_Cubic.new;
	~lfo2 = ZMapLfo_Cubic.new;
	~lfo1.a = 3.7;
	~lfo1.x = 0.7;
	~lfo2.a = 3.9;
	~lfo2.x = 0.9;

	~lfo1.interpolationMode = 2;
	~lfo2.interpolationMode = 2;

	~lfo_update_period = 0.05;
	~lfo1.increment = ~lfo_update_period / 12;
	~lfo2.increment = ~lfo_update_period / 12;

	~lfo_update_thread = Routine { inf.do {
		var shapeSelectValue = ~lfo1.tick.linlin(-1, 1, 0, ZMultiTap.numChebyBufs-1);
		var shapeFocusValue= ~lfo2.tick.linlin(-1, 1, 1, 0);
		//		[shapeSelectValue, shapeFocusValue].postln;
		z.setShapeSelect(0, shapeSelectValue);
		z.setShapeFocus(0, shapeFocusValue);
		~lfo_update_period.wait;
	} }.play;

	/*
	~lfo_update_thread.stop;
	*/

	//	{ FreqScope.new(400, 200, z.bus[\tap][1].index, server: s); }.defer;


	//	{ z.bus[\tap][1].scope; }.defer;

	s.sync;

	m.cc(7, { arg ccVal;
		if (ccVal > 0, {
			~noiser[0].set(\gate, 1);
		}, {
			~noiser[0].set(\gate, 0);
		});
	});

	m.cc(8, { arg ccVal;
		if (ccVal > 0, {
			~noiser[1].set(\gate, 1);
		}, {
			~noiser[1].set(\gate, 0);
		});
	});


	~anaKeys = [\amp, \pitch, \centroid, \flatness, \pcile];
	~anaCount = ~anaKeys.size;
	~anaCount.postln;
	~anaBus = Array.fill(n, { Bus.control(s, ~anaCount) });
	s.sync;
	~anaSynth = Array.fill(n, { arg i;
		{
			var input = In.ar(z.bus[\tap][i].index);
			var amp = Amplitude.kr(input);
			var pitch = Pitch.kr(input);
			var fftBuf = LocalBuf.new(2048);
			var fft = FFT(fftBuf, input);
			var centroid = SpecCentroid.kr(fft);
			var flatness = SpecFlatness.kr(fft);
			var pcile = SpecPcile.kr(fft, \fraction.kr(0.5));
			Out.kr(~anaBus[i].index, [
				amp, pitch, centroid, flatness, pcile
			]);
		}.play(s, addAction:\addToTail);
	});
	s.sync;

	~c0 = Color.gray;
	~c1 = Color.fromHexString("FFC20A");
	~c2 = Color.fromHexString("0C7BDC");

	g = ZGui.new;
	0.1.wait;

	~ana_refresh_period = 1/24; //0.25;
	~anaValues = Array.fill(n, { Dictionary.new });
	~anaCapture = Routine { inf.do {
		n.do ({ arg i;
			~anaBus[i].getn(~anaCount, {
				arg values;
				~anaCount.do({ arg ki;
					var k = ~anaKeys[ki];
					~anaValues[i][k] = values[ki];
					//postln("" ++ i ++ ": " ++ ~anaValues[i]);
					//					[
					//	~anaValues[i][\centroid],
					//	~anaValues[i][\flatness],
					//					~anaValues[i][\pcile]
					//			].postln;
					{ g.win.refresh; }.defer;
				});
			});
		});
		//(1/15).wait;
		~ana_refresh_period.wait;
	} }.play;
	/*
	-inf.max(-60)
	100.cpsmidi
	8000.cpsmidi*/
	~maxPcileMidi = 10000.cpsmidi;
	~minPcileMidi = 500.cpsmidi;
	{
		g.view.drawFunc = { arg view;
			n.do({ arg i;
				var w = view.bounds.width / 2;
				var h = view.bounds.height;
				var x = i * w;
				var pcile = ~anaValues[i][\pcile];
				var amp = ~anaValues[i][\amp];
				var timbreColor;
				var timbreBlend;
				timbreBlend = pcile.cpsmidi.linlin(~minPcileMidi, ~maxPcileMidi, 0.0, 1.0);
				///				[pcile, timbreBlend].postln;
				timbreColor = ~c1.blend(~c2, timbreBlend);
				Pen.color_(Color.black.blend(timbreColor, amp.ampdb.max(-60).linlin(-60, 0, 0.0, 1.0)));
				Pen.addRect(Rect(x, 0, w, h));
				Pen.perform(\fill);

			});
		}
	}.defer;


//	1.wait;
//	g.win.fullScreen;


}.play }

