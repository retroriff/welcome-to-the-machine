(
Ndef(\m51, {
    var sig1 = Saw.ar(
        freq: [1, 1.05] * 64.midicps
    );

    var sig2 = LFPulse.kr(
        freq: SinOscFB.kr(t / 8).range(4, 16),
        width: SinOscFB.kr(t / 8).range(0.2, 1),
    );

    sig1 * sig2 * -12.dbamp;
});
)


(
Ndef(\m52, {
    var sig1 = LFPulse.kr(
        freq: t * 8,
        iphase: 0,
        width: 0.2,
        mul: SinOscFB.kr(t / 16).range(0.1, 1)
    );

    var sig2 = SinOsc.ar(300);

    sig1 * sig2;
});
)

(
Ndef(\m53, {
    var sig1 = LFPulse.kr(
        freq: t * 8,
        iphase: 1,
        width: 0.2,
        mul: SinOscFB.kr(t / 16).range(0.1, 1)
    );
    var sig2 = SinOsc.ar(freq: [600, 605]);
    var in = sig1 * sig2;

    HPF.ar(in, freq: 64.midicps);
});
);

(
Ndef(\m54, {
    LFPulse.ar(
        freq: SinOscFB.kr(freq: t * 4, feedback: 1).range(300, 600),
        iphase: 0,
        width: SinOscFB.kr(t).range(0, 1),
        mul: SinOsc.kr(t / 4).range(0.2, 1) * -12.dbamp
    );
});
)
