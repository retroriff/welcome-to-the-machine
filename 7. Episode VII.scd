(
var chan, currentNote, keyNote, isPlaying, midiNote, octaves, scale;

if (MIDIClient.initialized == false)
{ MIDIClient.init };

m = MIDIOut.new(0);
m.latency = 0;

keyNote = 52;
scale = Scale.minor.degrees;
octaves = (4..5);
~chan = 0;

~stopNote = {
    if (currentNote.notNil) {
        m.noteOff(~chan, currentNote);
        currentNote = nil;
    };
};

~stopNote.value;

Mouse(\a, { |mouse, x, y|
    var msgArgs;

    var calculateNoteFromXPosition = { |xPosition|
        var totalDegrees = scale.size * octaves.size;
        var degreeIndex = (xPosition.linlin(0, 1, 0, totalDegrees)).round.clip(0, totalDegrees - 1);
        var octaveIndex = (degreeIndex / scale.size).floor;
        var scaleDegree = scale.wrapAt(degreeIndex % scale.size);
        (octaves.at(octaveIndex) * 12) + scaleDegree + (keyNote % 12);
    };

    var newNote = calculateNoteFromXPosition.(x);
    var velocity = (y.round(0.001) * 100).asInteger;

    if (currentNote != newNote) {
        if (currentNote.notNil) {
            // m.noteOff(~chan, currentNote);
        };

        // m.noteOn(~chan, newNote, velocity);
        currentNote = newNote;

        if (~machine.notNil) {
            msgArgs = [
                "track", "0",
                "midinote", newNote,
                "chord", ~chord.asString,
                "scale", ~scale.asString,
            ];
            ~machine.sendMsg("/machine", *msgArgs);
            // msgArgs.postln;
        } {
            "🔴 Machine's net address is not set".postln;
        };
    };
});
)

(
Mouse(\a).free;
~stopNote.value;
~machine.sendMsg("/machine", "track", Nil);
"Kill'Em All 🔴🔨";
)
