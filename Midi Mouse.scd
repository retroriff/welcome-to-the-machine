(
var midiNote, currentNote = nil, scale, octaves, keyNote, chan;

MIDIClient.init;
m = MIDIOut.new(0);
m.latency = 0;

keyNote = 52;
scale = Scale.iwato.degrees;
octaves = (4..5);
~chan = 0;

~stopNote = {
    if (currentNote.notNil) {
        m.noteOff(~chan, currentNote);
        currentNote = nil;
    };
};

Mouse(\a, { |mouse, x, y|
    var baseNote, degreeIndex, noteIndex, octaveIndex, scaleDegree, totalDegrees, velocity;
    a = x.round(0.0001);

    totalDegrees = scale.size * octaves.size;
    degreeIndex = (a.linlin(0, 1, 0, totalDegrees)).round.clip(0, totalDegrees - 1);
    octaveIndex = (degreeIndex / scale.size).floor;
    scaleDegree = scale.wrapAt(degreeIndex % scale.size);
    baseNote = (octaves.at(octaveIndex) * 12) + scaleDegree + (keyNote % 12);
    velocity = (y.round(0.001) * 100).asInteger;

    if (currentNote != baseNote) {
        if (currentNote.notNil) {
            m.noteOff(~chan, currentNote);
        };

        m.noteOn(~chan, baseNote, velocity);
        currentNote = baseNote;
    };
});
)

(
// Kill'Em All 🔴🔨
Mouse(\a).free;
~stopNote.value;
)
