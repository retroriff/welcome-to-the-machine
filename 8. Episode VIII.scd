Ndef(\x).proxyspace.fadeTime = 10;

(
~m91 = Ndef(\m91);
~m91[0] = {
    var trig = Impulse.kr(t);
    Greyhole.ar(
        in: Impulse.ar(t * 4),
        delayTime: 0.1,
        damp: 0.5,
        size: 0.9,
        diff: 0.7,
        feedback: 0.1,
        modDepth: 0.01,
        modFreq: 0.5
    ) * 2;
})
)


(
~m92 = Ndef(\m92);
~m92[0] = {
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
~m93 = Ndef(\m93);
~m93[0] = {
    var waveLength = LFNoise1.kr(t / 16).range(0.05, 0.5);
    var freq = LFNoise1.kr(waveLength).range(300, 2000);
    var mul = LFNoise1.kr(t / 15).range(0.02, 0.6);

    BPF.ar(
        BrownNoise.ar(0.1).dup,
        freq,
        mul: mul,
    );
};
)
