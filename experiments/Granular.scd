~buf = Buffer.readChannel(s, u +/+ "/SuperCollider/Tracks/Welcome to the Machine/samples/Shine On You Crazy Diamonds.aiff", channels: [0]);
~buf = Buffer.readChannel(s, u +/+ "/SuperCollider/Tracks/Welcome to the Machine/samples/Chord1.aiff", channels: [0]);
(
SynthDef(\sfgrain, {
    |bufnum = 0, pan = 0.0, startPos = 0.0, amp = 0.1, dur = 0.04|

    var sig = PlayBuf.ar(
        1,
        bufnum,
        BufRateScale.kr(bufnum),
        1,
        BufFrames.ir(bufnum) * startPos, 0) * (EnvGen.kr(Env.perc(0.01, releaseTime: dur),
        doneAction: 2
    ) - 0.001);

    Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
Tdef(\sfgrain, {
    var lastval = 1;

    inf.do { |i|
        var prop = (i % 300) / 300;
        var timestart = prop * 0.8;
        var timeend = prop * (0.8 + (0.1 * lastval));

        Synth(\sfgrain, [
            \bufnum, ~buf.bufnum,
            \startPos, rrand(timestart, timeend),
            \amp, exprand(0.005, 0.1),
            \pan, lastval.rand2,
            \dur, 0.1 + (lastval * 0.5),
        ]);

        // max in this to avoid ever going near 0.0 wait time, which would crash the computer!
        (((lastval * 0.2) + 0.01).max(0.01)).postln.wait;
    };
}).play;
)

