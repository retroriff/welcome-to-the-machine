(
~m81 = Ndef(\m81);
~m81[0] = {
    var trig = Impulse.kr(t);
    Greyhole.ar(
        Impulse.ar(t * 4),
        \delayTime.kr(0.1),
        \damp.kr(0.5),
        \size.kr(0.9),
        \diff.kr(0.7),
        \feedback.kr(0.1),
        \modDepth.kr(0.01),
        \modFreq.kr(0.5)
    ) * 2;
})
)

(
~m82 = Ndef(\m82);
~m82[0] = {
    var sig = Impulse.ar(MouseX.kr(1, 1000));
    Greyhole.ar(
        in: sig,
        delayTime: 2,
        damp: 0.5,
        size: 0.9,
        diff: 0.707,
        feedback: 0.9
    ) * 0.3;
})
)

(
~m83 = Ndef(\m83);
~m83[0] = {
    var waveLength = LFNoise1.kr(t / 16).range(0.05, 1);
    var freq = LFNoise1.kr(waveLength).range(300, 2000);
    var mul = LFNoise1.kr(t / 16).range(0.02, 1);

    BPF.ar(
        BrownNoise.ar(0.5).dup,
        freq,
        mul,
    );
};
)
