FadeIn(\m63, 0)
FadeOut(\m62)


(
~m61 = Ndef(\m61);
~m61[0] = {
    RLPF.ar(
        in: LFPulse.ar([28, 40].midicps, 0.15),
        freq: SinOsc.kr(t).range(300, 400),
        rq: LFNoise0.kr(t / 8).range(0.1, 0.9),
        mul: LFPulse.kr(t * 4).range(0, 0.5).lag(0.1)
    ) * 1.4;
}
)

(
~m62 = Ndef(\m62);
a = Buffer.loadCollection(s, [0, 4, 7, 11]);

~m62[0] = {
	var index, sig, pch, freq;
	index = LFDNoise0.kr(t / 4).range(0, 1);
    index = (index * BufFrames.kr(a));
    pch = (Index.kr(a, index) + 40).lag;
	freq = pch.midicps;
	sig = VarSaw.ar(freq, mul: 0.2!2);
	sig = CombN.ar(sig, 0.31, 0.31, 2, 1);
}
)


(
~m63 = Ndef(\m63);
b = Buffer.loadCollection(s, [0, 4, 7, 11]);

~m63[0] = {
    var freq = Index.kr(
        bufnum: b,
        in: LFSaw.kr(t / 4).range(0, 5)
    );
    VarSaw.ar(
        freq: (freq + 40).midicps,
        mul: 0.3
    );
}
)

