(
Ndef(\cello, {
    |atk = 0.01, dec = 0.1, sus = 0.5, rel = 0.4|
    var freq, env, sig, vibrato, width;

    freq = \freq.kr(64);
    vibrato = LFNoise2.kr(t / 16).range(0, 1);
    width = LFNoise2.kr(t).range(0.001, 1);

    sig = VarSaw.ar(freq: ([0, 3, 5] + freq).midicps, width: width, mul: vibrato);
    sig = RLPF.ar(in: sig, freq: freq.midicps * [0.995, 1.005], rq: 1);
    sig = Decimator.ar(sig, rate: 22050, bits: 2);

    Splay.ar(sig * -14.dbamp);
}).fadeTime_(5).play;
)
