(
~m21 = Ndef(\m21);
~m21[0] = {
    var lfo1 = LFSaw.kr(t / 4).range(1, 3).tanh;
    var lfo2 = LFPulse.kr(t / 2).range(0.2, 1);
    var in = Saw.ar(
        freq: [100, 101] * LFPulse.kr(t * 2).range(0.5, 1),
        mul: lfo1 * lfo2 * -4.dbamp;
    );
    HPF.ar(in, freq: 52.midicps);
};
)

(
~m22 = Ndef(\m22);
~m22[0] = {
    SinOscFB.ar(
        freq: [100, 101] * LFPulse.kr(t * 4).range(2, 3.5),
        feedback: LFSaw.kr(t / 3).range(0.1, 1),
        mul: LFPulse.kr(t / 2).range(0.2, 0.5)
    ) * -6.dbamp;
};
)

(
~m23 = Ndef(\m23);
~m23[0] = {
    var lfo1 = LFSaw.kr(t / 4).range(1, 3).tanh;
    var lfo2 = LFPulse.kr(t / 4).range(0.1, 0.5);
    var em = [52, 55, 59];
    var em9 = [55, 59, 54];
    var in = Pulse.ar(
        freq: em9.midicps * LFPulse.kr(t * 4).range(0.5, 1.5),
        width: LFSaw.kr(t / 4).range(0.1, 0.5),
        mul: lfo1 * lfo2 * -3.dbamp;
    );

    HPF.ar(in, freq: 64.midicps);
});
)

(
~m24 = Ndef(\m24);
~m24[0] = {
    Pulse.ar(
        freq: [40, 52].midicps * Gbman2DN.kr(t / 2).range(6, 6),
        width: SinOsc.kr(t / 8).unipolar(1),
        mul: LFPulse.kr(t * 8, iphase: 0).unipolar(0.4) * -6.dbamp;
    );
};
)

(
~m25 = Ndef(\m25);
~m25[0] = {
    var lfo1 = SinOscFB.kr(
        freq: t * 4,
        feedback: 1,
        mul: LFSaw.kr(t * 4).range(0.5, 1)
    ).range(3.5, 5);

    var lfo2 = SinOscFB.kr(freq: t * 4).range(0.5, 0.8);

    SinOscFB.ar(
        freq: [1, 1.01] * 40.midicps * lfo1,
        feedback: LFSaw.kr(t / 3).range(0.1, 1),
        mul: LFPulse.kr(t / 2).range(0.2, 1) * lfo2
    ) * -4.dbamp;
}
)
