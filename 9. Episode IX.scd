(
~m91 = Ndef(\m91);
~m91[0] = {
    var lfo1 = LFPulse.ar(t / 2).range(0.5, 1);
    var lfo2 = SinOscFB.ar(t * 8).range(0.5, 1);
    var in = SinOscFB.ar(
        freq: [52, 57].midicps * lfo1 * lfo2,
        feedback: SinOsc.kr(t / 16, 0).max(0),
        mul: 1
    ).tanh * 0.7;
    HPF.ar(in, freq: 150);
};
)

(
~m92 = Ndef(\m92);
~m92[0] = {
    Mix.fill(10, {
        Ringz.ar(
            in: WhiteNoise.ar(0.001) !2,
            freq: XLine.kr(
                start: 50.midicps * 4,
                end: 40.midicps * 8,
                dur: 60
            ),
            decaytime: 0.6,
            mul: 0.4
        );
    });
};
)

(
~m93 = Ndef(\m93);
~m93[0] = {
    var freq = SinOscFB.ar(
        freq: [1, 1.1] * 52.midicps * 4,
        feedback: 0.5,
        mul: 0.2
    );

    var trig = Trig.ar(LFPulse.ar(t / 4), dur: 0.2).lag;

    CombC.ar(
        in: freq * trig,
        maxdelaytime: t * 1.1,
        delaytime: t / 8,
        decaytime: t
    ) * 0.8;
};
)

