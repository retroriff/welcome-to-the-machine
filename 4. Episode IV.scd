(
~m41 = Ndef(\m41);
~m41[0] = {
    Gbman2DL.ar(
        minfreq: [400, 390],
        maxfreq: 400,
        x0: LFPulse.kr(t / 8).range(0.5, 3),
        y0: LFPulse.kr(t / 8).range(0, 4),
        mul: LFSaw.kr(t * 8).range(0.5, 1) * 2
    )
}
)


(
~m42 = Ndef(\m42);
~m42[0] = {
    var sig1 = Gbman2DN.ar(
        minfreq: 600 !2 * SinOscFB.kr(t * 8, feedback: 0.5).range(0.8, 3),
        maxfreq: 150 * SinOsc.kr(t / 2).range(0.8, 1.2),
        x0: 1.2,
        y0: 2.5,
        mul: LFSaw.kr(t / 4).range(0, 0.3)
    );
    var sig2 = LFSaw.ar(t / 4).range(0, 1.5);
    sig1 * sig2 * 0.7;
}
)


(
~m43 = Ndef(\m43);
~m43[0] = {
    Gbman2DN.ar(
        minfreq: 800 * LFPulse.kr(t / 8).range(2, 2),
        maxfreq: 200,
        x0: 1.2,
        y0: 2,
        mul: LFSaw.kr(t).range(0, 0.8)
    ) !2;
}
)

