(
Ndef(\m91, {
    var lfo1 = LFPulse.ar(t / 2).range(0.5, 1);
    var lfo2 = SinOscFB.ar(t * 8).range(0.5, 1);
    var in = SinOscFB.ar(
        freq: [52, 57].midicps * lfo1 * lfo2,
        feedback: SinOsc.kr(t / 16, 0).max(0),
        mul: 1
    ).tanh * -3.dbamp;

    RHPF.ar(in, freq: \freq.kr(150), rq: \rq.kr(1));
});
)

(
Ndef(\m92, {
    Mix.fill(10.exprand, {
        Ringz.ar(
            in: WhiteNoise.ar(0.001) ! 2,
            freq: 40.midicps * 8,
        );
    });
});
)

(
Ndef(\m93, {
    var freq = SinOscFB.ar(
        freq: [1, 1.1] * 64.midicps,
        feedback: 0.5,
        mul: 0.4
    );

    var trig = Trig.ar(
        in: LFPulse.ar(t / 4),
        dur: 0.2
    ).lag;

    CombC.ar(
        in: freq * trig,
        maxdelaytime: t * 1.1,
        delaytime: t / 8,
        decaytime: t
    ) * -6.dbamp;
});
)
