(
Ndef(\m41, {
    Gbman2DN.ar(
        minfreq: 60.midicps * 8,
        maxfreq: 48.midicps,
        x0: 1.2,
        y0: 2,
        mul: LFSaw.kr(t).range(0, 0.8)
    ) ! 2;
});
)

(
Tdef(\t41, {
    var event = (
        \amp: 0.5,
        \dur: 0.25,
        \root: ~root,
        \scale: ~scale,
        \wave: \saw,
        \vcf: 0,
    );

    Sx new: event play: 10;

    loop {
        var chord = 3.collect { ~degree.choose };
        Sx.qset(\chord, chord, 1);
        16.wait;
    };
}).play;
);

1 loop: ["machine/bass", 0] dur: 4 a: 1
