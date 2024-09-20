(
b = Buffer.readChannel(s, "samples/Chord1.aiff".resolveRelative, channels:[0]);

~m01 = Ndef(\m01);
~m01[0] = {
    |amp = 1, sndbuf, envbuf|

    var lfo1 = LFPulse.ar(t / 2).range(0.5, 1);
    var lfo2 = SinOscFB.ar(t * 8).range(0.5, 1);
    var rand = Array.rand(4, 1, 4) / 10;
    var in = GrainBuf.ar(
        2,
        trigger: LFPulse.kr(t * 8),
        dur: 0.7,
        sndbuf: b,
        rate: 1,
        pos: Demand.kr(Impulse.kr(t / 8), 0, Dseq(rand, inf)),
        interp: 2,
        pan: MouseX.kr(-1, 1),
    );

    Greyhole.ar(
        in,
        delayTime: 0.1,
        damp: 0.5,
        size: 0.9,
        diff: 0.7,
        feedback: 0.1,
        modDepth: 0.01,
        modFreq: 1
    );
};
)

(
~keysAndScales = Dictionary[
    \c -> Dictionary[
        \key -> 48,
        \scale -> [ 0, 4, 7, 11]  // CMaj7
    ],
    \e -> Dictionary[
        \key -> 52,
        \scale -> [0, 3, 7, 14]  // Em(add9)
    ],
    \a -> Dictionary[
        \key -> 57,
        \scale -> [0, 2, 4, 5, 7, 9, 11]  // AMaj
    ],
];
)

(
~m02 = Ndef(\m02);
~m02[0] = {
    var note = \e;
    var key = ~keysAndScales[note][\key];
    var scale = ~keysAndScales[note][\scale];

    var buffer = Buffer.alloc(s, scale.size, 1, {|b| b.setnMsg(0, scale) });

    var freq = DegreeToKey.kr(
        buffer.bufnum,
        in: MouseX.kr(0, 15),
        octave: 12,
        mul: 1,
        add: key
    );

    var lowFreqDetuning = LFNoise1.kr([3, 3], 0.04);

    var drone5ths = RLPF.ar(
        in: LFPulse.ar([key, key + 7].midicps, 0.15),
        freq: SinOsc.kr(0.1, 0, 10, key + 12).midicps,
        rq: 0.1,
        mul: 0.05
    );

    var osc1 = SinOsc.ar((freq + lowFreqDetuning).midicps, mul: 0.1);
    var osc2 = Impulse.ar(freq.midicps, phase: 2);

    osc1 = CombN.ar(
        in: (osc1 + drone5ths) * MouseY.kr(0.5, 1),
        maxdelaytime: 0.31,
        delaytime: 0.31,
        decaytime: 2,
        mul: 2,
        add: osc1);

    osc2 = Greyhole.ar(
        in: osc2 * MouseY.kr(0, 1),
        delayTime: 2,
        damp: 0.5
    );

    osc1 + osc2;
}
)

(
~m03 = Ndef(\m03);
~m03[0] = {
    var auto, freq, out, trig;
    freq = \freq.kr(40);
    trig = ToggleFF.ar(Dust.ar(8));
    auto = trig.lagud(1, 0.5);
    out = Saw.ar(freq);
    out = Splay.ar(out);
    out = (out * 3).fold2;
    out = RLPF.ar(out, freq * MouseX.kr(1600, 1000), 1);
    out = (out * 5).fold2;
    out = RLPF.ar(out, freq * MouseY.kr(2, 10) * TRand.ar(1, 4, trig), 0.1);
    out = (out * 1).fold2;
    out = MoogFF.ar(out, auto.linexp(0, 4, 2000, 800), 1);
    out = out + DelayC.ar(out, 0.05, SinOsc.ar(1, [10, pi]).range(0, 0.4));
    out = (out * 3.dbamp).tanh;
    out * 0.3;
});
)
