(
~note = 24 + 28;

~m71 = Ndef(\m71);
~m71[0] = {
    var pattern = Dseq(Bjorklund2(5, 8), inf) * 1/4;
    var trig = TDuty.ar(pattern);
    var env = Env.perc(0.01, 0.5).ar(gate: trig);
    var sig = Saw.ar(
        freq: [~note, ~note * \detune.kr(1.1)].midicps,
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
};
)
