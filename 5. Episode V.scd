(
~m51 = Ndef(\m51);
~m51[0] = {
    var sig1 = Saw.ar(
        freq: [1, 1.05] * 64.midicps
    );
    var sig2 = LFPulse.kr(
        freq: SinOscFB.kr(t / 8).range(4, 16),
        width: SinOscFB.kr(t / 8).range(0.2, 1),
    );
    sig1 * sig2 * 0.2;
}
)


(
~m52 = Ndef(\m52);
~m52[0] = {
    var sig1 = LFPulse.kr(
        freq: t * 8,
        iphase: 0,
        width: 0.2,
        mul: SinOscFB.kr(t / 16).range(0.1, 1)
    );
    var sig2 = SinOsc.ar(300);
    sig1 * sig2;
}
)

(
~m53 = Ndef(\m53);
~m53[0] = {
    var sig1 = LFPulse.kr(
        freq: t * 8,
        iphase: 1,
        width: 0.2,
        mul: SinOscFB.kr(t / 16).range(0.1, 0.2)
    );
    var sig2 = SinOsc.ar(freq: [600, 605], mul: 0.2);
    sig1 * sig2;
}
);

(
~m54 = Ndef(\m54);
~m54[0] = {
    LFPulse.ar(
        freq: SinOscFB.kr(freq: t * 4, feedback: 1).range(300, 600),
        iphase: 0,
        width: SinOscFB.kr(t).range(0, 1),
        mul: SinOsc.kr(t / 4).range(0.2, 1) * 0.1
    );
}
)
)