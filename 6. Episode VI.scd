(
Ndef(\m61, {
    var degree = \degree.kr(52);
    var tempo =  0.5 / 2;
    var pattern = Dseq(Bjorklund2(5, 8), inf) * tempo;
    var trig = TDuty.ar(pattern);
    var env = Env.perc(0.01, 0.5).ar(gate: trig);

    var detune = \detune.kr(1.1);
    var detuneToggle = Select.kr(detune > 0, [MouseX.kr(1, 1.5), detune]);

    var sig = Saw.ar(
        freq: [degree, degree * detuneToggle].midicps,
        mul: 0.3
    );

    sig = Greyhole.ar(
        in: sig,
        delayTime: 2,
        damp: 0.5,
        size: 0.9,
        diff: 0.707,
        feedback: 0.9
    ) * env;

    CombC.ar(sig, maxdelaytime: 1, delaytime: 0.5, decaytime: 6);
});
)

(
Ndef(\m62, {
    var sig = Klank.ar(
        `[
            Array.rand(12, 800.0, 4000.0),
            Array.fill(12, 0.5),
            Array.rand(12, 0.1, 2)
        ],
        Decay.ar(
            Impulse.ar(t / 2),
            decayTime:  0.03,
            mul: ClipNoise.ar(0.01)
        )
    );

    sig = GVerb.ar(sig, roomsize: 10, revtime: 3, mul: -6.dbamp);

    sig = CombC.ar(
        in: sig,
        maxdelaytime: t,
        delaytime: t / \delaytime.kr(4),
        decaytime: \decaytime.kr(t),
        mul: -6.dbamp
    );

}).fadeTime_(0).play;
)

\m61 in: 10;
Ndef(\m61).set(\detune, 0);
Ndef(\m61).set(\degree, (3..5).choose * 12 + 4);

2 play: ["machine/metal", 1] dur: 2 human: 0.4 reverb: 0.3 delay: 0.3 amp: 0.2 off: 1;
\3 play: ["machine/metal", 0] dur: 34;
