(
b = Buffer.readChannel(s, u +/+ "/Samples/Live Coding/machine/Welcome to the Machine [vocals] 01.wav", channels:[0]);
1 i: \gs dur: Pwhite(1, 10) args: (baseDur: Pkey(\dur), buf: b, dens: 10, pos: (Pwhite(0, 20) / 100), posSpeed: 0, sync: 1);
)


(
~sample = Buffer.readChannel(s, u +/+ "/Samples/Live Coding/machine/Welcome to the Machine [vocals] 03.wav", channels:[0]);

SynthDef(\playSample, {
    var outBus = 0;
    var susLevel = 0.6;
    var releaseTime = LFNoise0.kr(40, 2, 0.2);
    var startPos = LFNoise2.kr(500, 1, 0.0) * ~sample.numFrames;
    var gate = Line.kr(1, 0, 0.005);
    var amp = Linen.kr(gate, 0.01, susLevel, releaseTime, 2);
    var playBuf = PlayBuf.ar(2, ~sample, 1, 1, startPos: startPos, doneAction: 2);
    Out.ar(outBus, playBuf * amp);
}).add
)


(
SynthDef(\sfgrain, {arg bufnum=0, pan=0.0, startPos=0.0, amp=0.1, dur=0.04;
    var grain;
    grain = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), 1, BufFrames.ir(bufnum) * startPos, 0) * (EnvGen.kr(Env.perc(0.01, dur), doneAction: 2) - 0.001);
    Out.ar(0,Pan2.ar(grain, pan))}).add;
)

(
var w, slid, lastval;
lastval = 0.0;
w = Window("My Window", Rect(100,500,200,200));
// A 200 by 200 window appears at screen co-ordinates (100, 500)
slid = Slider(w, Rect(10, 10, 150, 40)); //a basic slider object
slid.action_({lastval = slid.value;}); //this is the callback- the function is called whenever you move the slider

{
    inf.do{ arg i;
        var prop, timestart, timeend;
        prop = (i%300) / 300;
        timestart = prop * 0.8;
        timeend = prop * (0.8 + (0.1 * lastval));
        Synth(\sfgrain,[\bufnum, b.bufnum, \startPos, rrand(timestart,timeend),\amp, exprand(0.005,0.1), \pan, lastval.rand2, \dur, 0.1 + (lastval * 0.5)]);

        // max in this to avoid ever going near 0.0 wait time, which would crash the computer!
        (((lastval*0.2)+0.01).max(0.01)).wait;
    };
}.fork;

w.front;

)


(
{
    var pointer = Phasor.ar(0, SampleDur.ir / BufDur.ir(b) * 0.5);
    var sound = Warp1.ar(1, b, pointer, 1, 0.3, -1, 16, Line.kr(0, 1, 40), 4);
    Pan2.ar(sound, pointer * 2 - 1, 0.25)
}.play
)