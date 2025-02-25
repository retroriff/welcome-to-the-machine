(
var sendOscToAnimatron = {
    n = NetAddr("192.168.1.140", 56101);
    Pbindef(\clock, \dur, 1/4, \amp, 0, \finish, Pfunc{ n.sendMsg("/clock"); }).play;

    if (\Mouse.asClass.notNil) {
        Mouse.start;
        Mouse(\send, { |mouse, x| x.round(0.001).postln });
    };
};


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

var loadBuffer = { |path, channel = 0|
    Buffer.readChannel(s, path.resolveRelative, channels: [channel]);
};

~setChord = { |chord, ndef|
    if (chord.notNil) {
        ~chord = chord;
        ~degree = keysAndScales[~chord][\degree];
        ~key = keysAndScales[~chord][\key];
        ~root = keysAndScales[~chord][\root];
        ~scale = keysAndScales[~chord][\scale];

        if (ndef.notNil) {
            Ndef(ndef).set(\degree, ~degree);
            Ndef(ndef).set(\key, ~key);
        };
    } {
        keysAndScales.keys;
    }
};

~setChord.(\emAdd9);
~buf = loadBuffer.("samples/chords/01.aiff");
~machine = NetAddr("127.0.0.1", 41234);
~voice = loadBuffer.("samples/voice/01.wav");

// sendOscToAnimatron.value;
// Mouse.free;
Px.listen;

"🟢 Welcome to the machine.".postln;"";
)