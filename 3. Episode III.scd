(
Ndef(\m31, {
    var sig = LFSaw.ar(
        freq: [28, 40].midicps,
        iphase: 0,
        mul: LFSaw.kr(t / 2).range(0.1, 0.7)
    );

    sig * -12.dbamp;
});
)

Fx(\m31).delay(1).gverb(0.6);

(
Ndef(\m32, {
    var sig1 = LFSaw.ar(
        freq: [52, 64].midicps + LFNoise0.ar(t * 4).range(1, 12),
        mul: LFSaw.kr(t / 4).range(0.01, 0.3)
    );

    var sig2 = LFPulse.ar(t / 8).range(0.2, 1);

    Pan2.ar(
        in: Mix.ar(sig1 * sig2),
        pos: SinOsc.ar(t / 4)
    ) * -4.dbamp;
});
)

(
Ndef(\m33, {
    SinOscFB.ar(
        freq: [52, 64].midicps + 12,
        feedback: LFSaw.kr(t / 4).range(0.01, 1),
        mul: LFSaw.kr(t * 4).range(0, 0.6).lag
    ) * -7.dbamp;
});
)
