SynthDef.new('amp_pause_rec',{
arg in=0, out=0, buf=0, ampthresh=0.5,
uplag=1.0, downlag=1.0, buflen;
var input, inputamp, inrange, off, jump;
input = SoundIn.ar(in);
inputamp = Decay2.kr(Amplitude.kr(input), uplag, downlag);
inrange = (inputamp > ampthresh);
off = LFSaw.kr(0.2, 0, buflen*0.5, buflen*0.5);
jump = Impulse.kr(1/buflen);
//RecordBuf.ar(inputArray, bufnum, offset, recLevel, preLevel, run, loop, trigger) 
RecordBuf.ar(input, buf, off, 1.0, 0.0, inrange, 1, jump);  
Out.kr(out, inrange);
}).send(s);  


SynthDef.new('dustyflipflop',{
arg out=0, pan=0, level=0.5, buf=0,
//shapebuf=0, pregain=1.0,
trigin=0, buflen=1.0,
jumpdensity=0.2, posnoiserate=1.0,
invertpauseswitch=0,
attacktime=1.0, releasetime=1.0, gate=1;

var output, startpos, jumpdust,
rate, negrate, trig, ampenv, amp;

ampenv = Env.asr(attacktime, 1, releasetime);
amp = EnvGen.ar(ampenv, gate:gate, levelScale:level, doneAction:2);

jumpdust = Dust.kr(jumpdensity);
startpos = LFNoise2.kr(posnoiserate, buflen*0.5, buflen*0.5);
trig = In.kr(trigin);
negrate=ToggleFF.kr(trig) * 2 - 1;
negrate = negrate * (ToggleFF.kr(jumpdust) * 2 - 1);
//rate = if(invertpauseswitch == 1, {1 - trig}, {trig}) * negrate;
rate = ((trig * (1-invertpauseswitch)) + ((1-trig)*invertpauseswitch)) * negrate;
//PlayBuf.ar(numChannels,bufnum,rate,trigger,startPos,loop) 
output = PlayBuf.ar(1, buf, rate, jumpdust, startpos, 1);
//output = Shaper.ar(output*pregain, shapebuf) * (1.0/pregain);
Out.ar(out, Pan2.ar(output * amp, pan) * level);
}).send(s);   
      