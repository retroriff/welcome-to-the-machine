~machine.sendMsg("/machine", "track", 6);

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
}).play;
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

}).fadeTime_(5).play;
)

(
Tdef(\m63, {
    loop {
        var midinote = (~degree + 60);
        var midinote2 = (60..72);

        Ndef(\m63, {
            var freqs = [1, 3, 4, 5, 7];
            var amps = Array.fill(4, 0.05);
            var ringTimes = Array.fill(4, 1);

            Klank.ar(
                `[freqs, amps, ringTimes],
                input: { ClipNoise.ar(0.02) }.dup,
                freqscale: midinote.choose.midicps
            );
        }).fadeTime_(5).play;

        [4, 8, 12, 16].choose.wait;
    }
}).play;
)

(
Ndef(\m64, {
    var note1 = \note1.kr(0.32);
    var randPos = [note1, note1, \note2.kr(0.92), note1];
    var pos = Demand.kr(
        Impulse.kr(t / 1),
        reset: 0,
        demandUGens: Dseq(randPos, inf)
    );

    var pattern = Dseq(Bjorklund2(5, 8), inf) * (0.5 / 4);
    var trig = TDuty.ar(pattern);

    var sig = GrainBuf.ar(
        numChannels: 2,
        trigger: trig,
        dur: Impulse.kr(1).exprange(0.2, 0.4),
        sndbuf: ~voice,
        rate: 1,
        pos: (pos + MouseX.kr(-0.02, 0.02)).clip(0, 1),
        pan: LFNoise1.kr(1).range(-0.5, 0.5),
    );

    var lfo = SinOsc.kr(0.1).exprange(0.05, 0.5);

    CombC.ar(
        in: sig,
        maxdelaytime: 0.5,
        delaytime: 0.2,
        mul: 2
    );
}).play;
)

\m61 in: 10;
Ndef(\m61).set(\detune, 1);
Ndef(\m61).set(\degree, (3..5).choose * 12 + 4);
Ndef(\m64).set(\note2, 0.88)

2 play: ["machine/metal", 1] dur: 2 human: 0.4 reverb: 0.3 delay: 0.3 amp: 0.3;
3 play: ["machine/metal", 0] dur: 0.5 euclid: [2, 5];
