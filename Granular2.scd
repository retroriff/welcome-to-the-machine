(
~files = PathName(u +/+ "/Samples/Live Coding/machine/").files;
~bufs = ~files.collect { |file| Buffer.readChannel(s, file.fullPath, channels: [0]) };
)

(
Tdef(\t12, {
    loop {
        var posSpeed = exprand(1, 10).round / 10;

        Synth.new(\gs, [
            \amp, (posSpeed == 1).if { 0.05 } { exprand(0.1, 0.5) },
            \baseDur, 0.2,
            \buf, ~bufs.choose,
            \dens, 40.midicps,
            \pos, 0,
            \posSpeed, posSpeed,
            \sus, 3,
        ]);

        exprand(0.1, 8).wait;
    }
}).play
)


(
Tdef(\t13, {
    loop {
        (2..5).do({
            Synth.new(\gs, [
                \amp, exprand(0.25, 0.6),
                \buf, ~bufs[1],
                \dens, [0.25, 0.5, 1, 2, 4, 8].choose,
                \dur, exprand(0.001, 0.055),
                \panHz, exprand(0.1, 1),
                \panRand, 0.8,
                \pos, [0.98, 0.21, 0.398, 0.89].choose,
                \posSpeed, 0,
                \rate, [-2, 0, 1].choose.midiratio,
                \sync, 1,
                \atk, 1,
                \sus, 1,
                \rel, 3,
            ]);
        });

        exprand(0.5, 4).round(0.5).wait;
    };
}).play;
)