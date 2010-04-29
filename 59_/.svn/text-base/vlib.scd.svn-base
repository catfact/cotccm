s = Server.local;

/*
s.boot;
*/


//s.waitForBoot{


//===================
// vIn synthdef
// audio IO
SynthDef.new('vIn_1_1', {
arg curve='welch', attacktime = 0.1, releasetime = 0.1,
gate=1, level=1.0, out=0, in=0;
var input, ampenv, amp, output;
input = SoundIn.ar(in);
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
Out.ar(out, input* amp);
}).send(s);

//================ panned
SynthDef.new('vIn_1_2', {
arg curve='welch', attacktime = 0.1, releasetime = 0.1, gate=1, level=1.0, out=0, in=0, pan=0.0;
var input, ampenv, amp, output;
input = SoundIn.ar(in);
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
Out.ar(out, Pan2.ar(input* amp, pan));
}).send(s);


//===================
// vRecord synthdef
// record one channel
SynthDef.new('vRecord_1_1', {
arg curve='welch', attacktime = 0.1, releasetime = 0.1,
gate=1, level=1.0, in=0, buf=0,
offset=0.0, recLevel=1.0, preLevel=0.0,
run=1.0, loop=1.0, trigger=1.0;
var input, ampenv, amp, output;
input = SoundIn.ar(in);
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
RecordBuf.ar(input* amp, buf, offset, recLevel, preLevel, run, loop, trigger);
}).send(s);


//===================
// vRecord synthdef
// hardcoded stereo HW input
SynthDef.new('vRecordStereo', {
arg curve='welch', attacktime = 0.1, releasetime = 0.1, gate=1, level=1.0, out=0,
buf=0, offset=0.0, recLevel=1.0, preLevel=0.0, run=1.0, loop=1.0, trigger=1.0;
var input, ampenv, amp, output;
input = SoundIn.ar([0,1]);
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
RecordBuf.ar(input* amp, buf, offset, recLevel, preLevel, run, loop, trigger);
}).send(s);


//===================
// vRecord synthdef
// hardcoded mono HW input
SynthDef.new('vRecordMono', {
arg in=0, curve='welch', attacktime = 0.1, releasetime = 0.1, gate=1, level=1.0, out=0,
buf=0, offset=0.0, recLevel=1.0, preLevel=0.0, run=1.0, loop=1.0, trigger=1.0;
var input, ampenv, amp, output;
input = SoundIn.ar(in);
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
RecordBuf.ar(input* amp, buf, offset, recLevel, preLevel, run, loop, trigger);
}).send(s);

//=================
// hardKey synthdef
// amplitude follower, outputs kr trig
SynthDef.new('hardKey', {
arg in=0, out=0, level=1.0, attacktime=0.1, releasetime=0.1, gate=1, pregain=1.0,
threshold=0.5;

var input, lagger, output;
input = Amplitude.kr(In.ar(in) * gate * pregain, attacktime, releasetime);
Out.kr(out, (input>threshold) * level); 
}).send(s);

//////
//////
//======================
// - just a 1shot enveloped buffer playback
SynthDef.new('vGrain_1_1', {
arg curve='welch', buf=0, out=0, 
attacktime=0.05, releasetime=0.05, gate=1, level=1.0, 
dur=1.0, pitch=1.0, startpos=0.0,
trig=0;
var player, ampenv, amp;

//player = BufRd.ar(2, buf, Line.ar(startpos, startpos + dur, dur, BufSampleRate.ir(buf)));
player = BufRd.ar(1, buf, Phasor.ar(0, BufRateScale.kr(buf), 0, BufFrames.kr(buf)) + (startpos * BufSampleRate.kr(buf)));

ampenv = Env.linen(
attacktime,// attackTime=0.01, 
dur-attacktime-releasetime,// sustainTime=1.0, 
releasetime,// releaseTime=1.0,
1.0,// level=1.0,
curve//curve
);
amp = EnvGen.ar(
ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
Out.ar(out, player * amp);
}).send(s);
///////
///////


//======================
// vGrain synthdef
// - just a 1shot enveloped buffer playback
SynthDef.new('vGrain_1_1', {
arg curve='welch', buf=0, out=0, 
attacktime=0.05, releasetime=0.05, gate=1, level=1.0, 
dur=1.0, pitch=1.0, startpos=0.0;
var player, ampenv, amp;
player = PlayBuf.ar(
1, //numchannels
buf, // bufnum
pitch, // rate
1.0, // trigger
startpos, // startpos
1.0 // loop
);
ampenv = Env.linen(
attacktime,// attackTime=0.01, 
dur-attacktime-releasetime,// sustainTime=1.0, 
releasetime,// releaseTime=1.0,
1.0,// level=1.0,
curve//curve
);
amp = EnvGen.ar(
ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
Out.ar(out, player * amp);
}).send(s);

//==========================panned
SynthDef.new('vGrain_1_2', {
arg curve='welch', buf=0, out=0,
attacktime=0.05, releasetime=0.05, 
gate=1, level=1.0, pitch=1.0,
pan0=0.0, pan1=0.0, pancurve=0.0,
dur=1.0, startpos=0.0;
var player, ampenv, amp, panenv, pan;
player = PlayBuf.ar(
1, //numchannels
buf, // bufnum
pitch, // rate
1.0, // trigger
startpos, // startpos
1.0 // loop
);
ampenv = Env.linen(
attacktime,// attackTime=0.01, 
dur-attacktime-releasetime,// sustainTime=1.0, 
releasetime,// releaseTime=1.0,
1.0,// level=1.0,
curve//curve
);
amp = EnvGen.ar(
ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
panenv = Env.linen(
attacktime,// attackTime=0.01, 
dur-attacktime-releasetime,// sustainTime=1.0, 
releasetime,// releaseTime=1.0,
1.0,// level=1.0,
pancurve//curve
);
pan = EnvGen.ar(
panenv, // env
gate, //gate
pan1 - pan0, //levelscale
pan0, // levelbias
1.0 //timescale
);
Out.ar(out, Pan2.ar(player * amp, pan));
}).send(s);

//==========================
// grain with panned output and BPF
SynthDef.new('vLagBPFGrain_1_2', {
arg curve='welch', buf=0, out=0,
attacktime=0.05, releasetime=0.05, 
gate=1, level=1.0, pitch=1.0, startpos=0.0,
pan0=0.0, pan1=0.0, pancurve=0.0,
dur=1.0, hz=8000.0, rq=1.0, mix=1.0,
hzlag=1.0, rqlag=1.0, mixlag=1.0;
var player, ampenv, amp, panenv, pan, 
resonz, output;
player = PlayBuf.ar(
1, //numchannels
buf, // bufnum
pitch, // rate
1.0, // trigger
startpos, // startpos
1.0 // loop
);
ampenv = Env.linen(
attacktime,// attackTime=0.01, 
dur-attacktime-releasetime,// sustainTime=1.0, 
releasetime,// releaseTime=1.0,
1.0,// level=1.0,
curve//curve
);
amp = EnvGen.ar(
ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
panenv = Env.linen(
attacktime,// attackTime=0.01, 
dur-attacktime-releasetime,// sustainTime=1.0, 
releasetime,// releaseTime=1.0,
1.0,// level=1.0,
pancurve//curve
);
pan = EnvGen.ar(
panenv, // env
gate, //gate
pan1 - pan0, //levelscale
pan0, // levelbias
1.0 //timescale
);
resonz = Resonz.ar(player * amp, Lag.kr(hz,hzlag),Lag.kr(rq,rqlag));
output=(Lag.kr(mix,mixlag) * resonz) + ((1.0-Lag.kr(mix,mixlag)) * player);
Out.ar(out, Pan2.ar(output * amp, pan));
}).send(s);


//===========
// vShaper
SynthDef.new('vShaper_1_1', {
arg curve='welch', in=0, out=0, buf=0,
pregain=1.0, level=1.0,
attacktime=0.1, releasetime=0.1, gate=1;
var shaper, ampenv, amp;
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
shaper = Shaper.ar(buf, In.ar(in, 1) * pregain, amp);
Out.ar(out, shaper);
}).send(s);

//=================
// pauseEE synthdef  
SynthDef.new('vPause_1_1',
{
arg curve='welch', buf=0, out=0, level=1.0,
attacktime=0.1, releasetime=0.1, gate=1,
rate=1.0, startpos=0.0, loop=0.0,
in=0;
var player, ampenv, amp, trig;
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar(
ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
trig = In.kr(in, 1);
player = PlayBuf.ar(
1, //numChannels, 
buf, //bufnum=0, 
rate, //rate=1.0, 
trig,//trigger=1.0, 
startpos,//startPos=0.0, 
loop//loop = 0.0;
);
Out.ar(out, player * amp);
}).send(s);

//============
// vSine
SynthDef.new ('vSine_0_1', {
arg curve='welch', attacktime = 0.1, releasetime = 0.1,
gate=1, level=0.2, out=0,
hz=220, phase=0.0;
var sine, ampenv, amp, output;
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
sine = SinOsc.ar(hz, phase, amp);
Out.ar(out, sine);
}).send(s);

//============
// vWave
// single wavetable
SynthDef.new ('vWave_0_1', {
arg curve='welch', attacktime = 0.1, releasetime = 0.1,
gate=1, level=0.2, out=0,
buf=0, hz=220, phase=0.0;
var osc, ampenv, amp, output;
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
osc = Osc.ar(buf, hz, phase, amp);
Out.ar(out, osc);
}).send(s);

//============
// vMultiWave
// multi wavetable
SynthDef.new ('vMultiWave_0_1', {
arg curve='welch', attacktime = 0.1, releasetime = 0.1, gate=1, level=0.2, out=0,
buf=0, hz=220, phase=0.0;
var osc, ampenv, amp, output;
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
osc = VOsc.ar(buf, hz, phase, amp);
Out.ar(out, osc);
}).send(s);


//============
// vMultiWave_1shot
// multi wavetable, 1shot
SynthDef.new ('vMultiWave_1shot_0_1', {
arg curve='welch', dur=1.0,
attacktime = 0.1, releasetime = 0.1, gate=1, level=0.2, out=0,
buf=0, hz=220, phase=0.0;
var osc, ampenv, amp, output;
ampenv = Env.linen (
attacktime,// attackTime=0.01, 
dur-attacktime-releasetime,// sustainTime=1.0, 
releasetime,// releaseTime=1.0,
1.0,// level=1.0,
curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
osc = VOsc.ar(buf, hz, phase, amp);
Out.ar(out, osc);
}).send(s);



//============
// vScale
// scale and bias KR
SynthDef.new('vScale_1_1_kr', {
arg curve='lin',in=0, out=0, attacktime=0.11, releasetime=0.1, gate=1,
scale=1.0, bias=0.0;
var scaled, ampenv, amp, output;
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
scale, //levelscale
bias, // levelbias
1.0, //timescale
2 // free self // doneaction
);
scaled = In.ar(in, 1) * amp;
ReplaceOut.ar(out, scaled);
}).send(s);

//==============
// vAmp
SynthDef.new('vAmp_1_1', {
arg in, out;
Out.kr(out, Amplitude.kr(In.ar(in, 1)));
}).send(s);

//==============
// vPitch
SynthDef.new('vPitch_1_1', {
arg in, out;
Out.kr(out, Pitch.kr(In.ar(in, 1)));
}).send(s);



//============
// vLagSine
SynthDef.new ('vLagSine_0_2', {
arg curve='welch', attacktime = 0.1, releasetime = 0.1,
gate=1, level=0.2, out=0,
hz=220, phase=0.0, pan=0,
hzlag = 1.0, panlag = 1.0;
var sine, ampenv, amp, output;
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
level, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
sine = SinOsc.ar(Lag.kr(hz, hzlag), phase, amp);
Out.ar(out, Pan2.ar(sine, Lag.kr(pan, panlag)));
}).send(s);




//============
// vLagMultiWave
SynthDef.new ('vLagMultiWave_0_2', {
arg curve='welch', attacktime = 0.1, releasetime = 0.1,
gate=1, level=0.2, out=0,
hz=220, phase=0.0, pan=0,
hzlag = 1.0, panlag = 1.0, wavelag=1.0,
bufnum=0;
var osc, ampenv, amp, output;
ampenv = Env.asr ( attacktime,
	1.0, // sustainLevel
	releasetime, // releasetime
	curve//curve
);
amp = EnvGen.ar( ampenv, // env
gate, //gate
1.0, //levelscale
0.0, // levelbias
1.0, //timescale
2 // free self // doneaction
);
osc = VOsc.ar(Lag.kr(bufnum, wavelag), Lag.kr(hz, hzlag), phase, amp);
Out.ar(out, Pan2.ar(osc, Lag.kr(pan, panlag)) * level);
}).send(s);

//

SynthDef.new('vDelay_1_1', 
{arg in=0, out=0,maxdelaytime=1.0,delaytime=0.0, amp=1.0;

Out.ar(out, DelayL.ar(In.ar(in, 1), maxdelaytime,delaytime,amp));
}).send(s);



//                                                              