(
var sendOscToAnimatron = {
    n = NetAddr("192.168.1.140", 56101);
    Pbindef(\clock, \dur, 1/4, \amp, 0, \finish, Pfunc{ n.sendMsg("/clock"); }).play;

    if (\Mouse.asClass.notNil) {
        Mouse.start;
        Mouse(\send, { |mouse, x| x.round(0.001).postln });
    };
};

var chord = \emAdd9;
var keysAndScales = Dictionary[
    \cMaj7 -> Dictionary[
        \degree -> [0, 4, 7, 11],
        \key -> 48,
        \root -> 0,
        \scale -> \major
    ],
    \emAdd9 -> Dictionary[
        \degree -> [0, 3, 7, 14],
        \key -> 52,
        \root -> 4,
        \scale -> \minor
    ],
    \aMaj -> Dictionary[
        \degree -> [0, 2, 4, 5, 7, 9, 11],
        \key -> 57,
        \root -> 9,
        \scale -> \major
    ],
];
~buf = Buffer.readChannel(s, "samples/Chord1.aiff".resolveRelative, channels:[0]);
~degree = keysAndScales[chord][\degree];
~key = keysAndScales[chord][\key];
~root = keysAndScales[chord][\root];
~scale = keysAndScales[chord][\scale];
~voice = Buffer.readChannel(s, u +/+ "samples/Live Coding/machine/voice/01.wav", channels:[0]);

// sendOscToAnimatron.value;
// Mouse.free;

"🟢 Welcome to the machine.".postln;"";
)

(
Tdef(\t01, {
    loop {
        (1..8).choose.do({
            var octaves = [0.25, 0.5, 1, 2].choose;
            var rate = (~degree.choose + ~key).midicps * octaves;

            4.do({
                Synth.new(\gs, [
                    \amp, exprand(0.05, 0.55),
                    \atk, exprand(1, 4),
                    \baseDur, 0.02,
                    \buf, ~buf,
                    \dens, rate * rrand(-0.15, 0.15).midiratio,
                    \pan, rrand(-0.8, 0.8),
                    \pos, (3..6).choose / 10,
                    \posSpeed, 0,
                    \rel, exprand(3, 6),
                ]);
            });

            exprand(0.1, 8).wait;
        });
    };
}).play;
)

(
Ndef(\m01, {
    var buffer = Buffer.alloc(s, ~degree.size, 1, {|b| b.setnMsg(0, ~degree) });

    var freq = DegreeToKey.kr(
        buffer.bufnum,
        in: MouseX.kr(0, 12),
        octave: 12,
        mul: 1,
        add: ~key
    );

    var drone5ths = RLPF.ar(
        in: LFPulse.ar([~key, ~key + 7].midicps, iphase: 0.15),
        freq: SinOsc.kr(0.1, mul: 10, add: ~key + 12).midicps,
        rq: 0.1,
        mul: 0.05
    );

    var lowFreqDetuning = LFNoise1.kr([3, 3], mul: 0.04);

    var osc1 = SinOsc.ar((freq + lowFreqDetuning).midicps, mul: 0.1);
    var osc2 = Impulse.ar(freq.midicps, phase: 2);

    osc1 = CombN.ar(
        in: (osc1 + drone5ths) * MouseY.kr(0.5, 1),
        maxdelaytime: 0.31,
        delaytime: 0.31,
        decaytime: 2,
        mul: 2,
        add: osc1
    );

    osc2 = Greyhole.ar(
        in: osc2 * MouseY.kr(0, 1),
        delayTime: 2,
        damp: 0.5
    );

    (osc1 + osc2) * \dbamp.kr(-2).dbamp;
});
)

(
Ndef(\m02, {
    var lfo1 = LFPulse.ar(t / 2).range(0.5, 1);
    var lfo2 = SinOscFB.ar(t * 8).range(0.5, 1);
    var randPos = Array.rand(4, 1, 4) / 10;
    var pos = Demand.kr(
        Impulse.kr(t / 8),
        reset: 0,
        demandUGens: Dseq(randPos, inf)
    );

    GrainBuf.ar(
        numChannels: 2,
        trigger: LFPulse.kr(t * 8),
        dur: 0.7,
        sndbuf: ~buf,
        rate: 1,
        pos: pos,
        interp: 2,
        pan: MouseX.kr(-0.7, 0.7),
    );
});
)
