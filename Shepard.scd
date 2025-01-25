(
SynthDef(\shepard, {
    |amp = 1, dur = 20, direction = 1, freq = 440|

    var partialCount = 4;
    var octRange = 2 ** (partialCount / 2);
    var cycle = 1 / (partialCount * dur);
    var width = if (direction >= 0, 1, 0);
    var fadeIn = Line.kr(0, 1, 5);
    var sig = partialCount.collect { |n|
        var offset = n / partialCount;
        var phase = (3 * pi / 2) + (2 * pi * offset);
        var vol = SinOsc.kr(cycle, phase).range(0, 1);
        var ratio = VarSaw.kr(cycle, offset, width).exprange(1/octRange, octRange);
        SinOsc.ar(freq * ratio) * vol;
    }.sum;
    var drone5ths;

    sig = sig ! 2 * (amp / partialCount) * fadeIn;
    sig = JPverb.ar(sig);
    Out.ar(0, sig);
}).add;

~playShep = #{
    |midinote = 48, chord = ([1, 5/4, 3/2]), direction = (-1), dur = 60, amp = 0.1|
    chord.collect { |intervalRatio|
        (
            instrument: \shepard,
            freq: midinote.midicps * intervalRatio,
            dur: dur,
            direction: direction,
            amp: amp,
    ).play };
};
);

~shep = ~playShep.(chord: [0, 3, 7, 14], direction: 1);

// free all
~shep do: _.free;
)

~example = #{ |a, b| a + b };
~example.value(3, 5); // Outputs: 8

\m01 out: 10
Px.mixer;


(
Ndef(\shepardChord, {
    |midinote = 48, direction = -1, dur = 20, amp = 0.1, staccato = 0.2|

    var partialCount = 4;
    var octRange = 2 ** (partialCount / 2);
    var cycle = 1 / (partialCount * dur);
    var width = if (direction >= 0, 1, 0);
    var fadeIn = Line.kr(0, 1, 5); // Fade in for the overall signal
    var chord = \chord.kr([1, 5/4, 3/2]);

    // Staccato envelope triggered for each cycle
    var staccatoEnv = EnvGen.kr(
        Env.perc(0, staccato), // Short percussive envelope
        doneAction: 2
    );

    var sig = chord.collect { |intervalRatio|
        var freq = midinote.midicps * intervalRatio;

        partialCount.collect { |n|
            var offset = n / partialCount;
            var phase = (3 * pi / 2) + (2 * pi * offset);
            var vol = SinOsc.kr(cycle, phase).range(0, 1); // Volume modulation
            var ratio = VarSaw.kr(cycle, offset, width).exprange(1 / octRange, octRange);
            SinOscFB.ar(freq * ratio) * vol * staccatoEnv; // Apply staccato envelope
        }.sum;
    }.sum;

    sig = sig.dup(2) * (amp / partialCount) * fadeIn; // Stereo signal with fade in
    sig = JPverb.ar(sig); // Add reverb for a fuller sound
}).play;

Ndef(\shepardChord).set(\midinote, 48, \chord, [0, 3, 7], \direction, 1, \dur, 20, \staccato, 0.4);
)