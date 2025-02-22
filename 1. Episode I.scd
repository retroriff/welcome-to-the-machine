~machine.sendMsg("/machine", "track", 1);

(
Ndef(\m11, {
    var freq = \freq.kr(40);
    var trig = ToggleFF.ar(Dust.ar(8));
    var auto = trig.lagud(1, 0.5);

    var out = Saw.ar(freq);
    out = Splay.ar(out);
    out = (out * 3).fold2;
    out = RLPF.ar(out, freq * MouseX.kr(1600, 1000), 1);
    out = (out * 5).fold2;
    out = RLPF.ar(out, freq * MouseY.kr(2, 10) * TRand.ar(1, 4, trig), 0.1);
    out = (out * 1).fold2;
    out = MoogFF.ar(out, auto.linexp(0, 4, 2000, 800), 1);
    out = out + DelayC.ar(
        in: out,
        maxdelaytime: 0.05,
        delaytime: SinOsc.ar(freq: 1, phase: [10, pi]).range(0, 0.4)
    );
    (out).tanh * -5.dbamp;
});
)

(
Ndef(\m12, {
    var in = SinOscFB.ar(
        freq: [100, 101],
        feedback: LFSaw.kr(t / 4).range(0.2, 1),
        mul: LFPulse.kr(t / 2).range(0.2, 1.5),
    );

    HPF.ar(in, freq: 60.midicps);
});
)

Px reverb: 0.4 blp: 0.4;

(
Ndef(\m13, {
    Greyhole.ar(
        in: Impulse.ar(
            freq: t * MouseX.kr(1, 1000),
            mul: MouseY.kr(0, \amp.kr(0.3))
        ),
        delayTime: 2,
        damp: 0.5
    );
});
)
