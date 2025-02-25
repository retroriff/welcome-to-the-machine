(
var defaultValues = {
    ~octaves = (4..5);
    ~chan = 1;

    if (~scale.isNil) {
        ~scale = \minor;
        ~key = 52;
    };
};

var initMidi = {
    if (MIDIClient.initialized == false) {
        MIDIClient.init;
    };

    m = MIDIOut.new(0);
    m.latency = 0;
};

var stopNote = {
    if (~currentNote.notNil) {
        m.noteOff(~chan, ~currentNote);
        ~currentNote = nil;
    };
};

initMidi.value;
defaultValues.value;

~playInstrument = { |isMidi, isOsc = true, post|
    stopNote.value;

    Mouse(\a, { |mouse, x, y|
        var msgArgs;

        var calculateNoteFromXPosition = { |xPosition|
            var scaleDegrees = Scale.at(~scale).degrees;
            var totalDegrees = scaleDegrees.size * ~octaves.size;
            var degreeIndex = (xPosition.linlin(0, 1, 0, totalDegrees)).round.clip(0, totalDegrees - 1);
            var octaveIndex = (degreeIndex / scaleDegrees.size).floor;
            var degree = scaleDegrees.wrapAt(degreeIndex % scaleDegrees.size);
            (~octaves.at(octaveIndex) * 12) + degree + (~key % 12);
        };

        var newNote = calculateNoteFromXPosition.(x);

        var velocity = (y.round(0.001) * 100).asInteger;

        var sendMidi = {
            if (~currentNote.notNil) {
                m.noteOff(~chan, ~currentNote);
            };

            m.noteOn(~chan, newNote, velocity);
        };

        var sendOsc = {
            if (~machine.notNil) {
                msgArgs = [
                    "track", "0",
                    "midinote", newNote,
                    "chord", ~chord.asString,
                    "scale", ~scale.asString,
                ];
                ~machine.sendMsg("/machine", *msgArgs);
                
                if (post) {
                    msgArgs.postln;
                } 
            } {
                "🔴 Machine's net address is not set".postln;
            };
        };

        if (~currentNote != newNote) {
            if (isMidi == true)
            { sendMidi.value };

            if (isOsc == true)
            { sendOsc.value };

            ~currentNote = newNote;
        };
    });
};

~replaceInstrument = { |chan|
    stopNote.value;
    ~chan = chan;
};

~stopInstrument = {
    Mouse(\a).free;
    stopNote.value;

    if (~machine.notNil) {
        ~machine.sendMsg("/machine", "track", Nil);
    };

    "Kill'Em All 🔴🔨";
};
)

~playInstrument.();
~stopInstrument.value;
~replaceInstrument.(1);
Px.stop;
