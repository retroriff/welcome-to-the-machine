(
Ndef(\m31, {
    LFSaw.ar(
        freq: ([28, 40] + LFNoise0.ar(t / 2).range(1, 1)).midicps,
        iphase: 0,
        mul: LFSaw.kr(t / 2).range(0, 0.3)
    ) * -3.dbamp;
});
)


(
Ndef(\m32, {
    var sig1 = LFSaw.ar(
        freq: [53, 65].midicps + LFNoise0.ar(t * 4).range(1, 12),
        mul: LFSaw.kr(t / 4).range(0.01, 0.3)
    );

    var sig2 = LFPulse.ar(t / 8).range(0.2, 1);

    sig1 * sig2 * -4.dbamp;
});
)


(
Ndef(\m33, {
    SinOscFB.ar(
        freq: [52, 64].midicps + 12,
        feedback: LFSaw.kr(t / 4).range(0.01, 1),
        mul: LFSaw.kr(t * 4).range(0, -7.dbamp)
    );
});
)
