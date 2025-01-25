1 loop: ["machine/bass", 0] dur: 4 a: 1

Ndef(\m01).clear;

(
Ndef(\m01, {
    var buffer = Buffer.alloc(s, ~degree.size, 1, {|b| b.setnMsg(0, ~degree.scramble) });

    var freq = DegreeToKey.kr(
        buffer.bufnum,
        in: \in.kr(4).clip(0, 12),
        octave: 12,
        mul: 1,
        add: ~key
    );

    var sig = Gendy1.ar(
        ampdist: \ampdist.kr(0),
        durdist: \durdist.kr(2),
        adparam: 2,
        ddparam: 2,
        minfreq: freq.midicps * 0.99,
        maxfreq: freq.midicps * 0.99,
        durscale: \durscale.kr(0),
        initCPs: \initCPs.kr(10)
    );

    sig = Resonz.ar(
        sig,
        freq: MouseY.kr(50, 200),
        bwr: \bwr.kr(0.1)
    );

    sig = CombN.ar(
        sig,
        maxdelaytime: \maxdelaytime.kr(0.1),
        delaytime: \delaytime.kr(0.01) + MouseX.kr(-0.002, 0.002),
        decaytime: \decaytime.kr(5),
    );

    Pan2.ar(sig, 0.0);
}).play.edit;
)

Ndef(\m01).set(\minfreq, 1)
Ndef(\m01).set(\delaytime, 0.0126)
Ndef(\m01).set(\in, 5)