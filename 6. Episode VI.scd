// Play with freq: SinOsc.kr(t).range(62, 100).midicps
(
~m61 = Ndef(\m61);
~m61[0] = {
    RLPF.ar(
        in: LFPulse.ar([28, 40].midicps, iphase: 0.15),
        freq: SinOsc.kr(t).range(62, 67.clip(67, 120)).midicps,
        rq: LFNoise0.kr(t / 8).range(0.1, 0.9),
        mul: LFPulse.kr(t * 4).range(0, 0.5).lag(0.1)
    );
}
)

(
var buffer = Buffer.loadCollection(s, [0, 3, 7, 11]);
~m62 = Ndef(\m62);

~m62[0] = {
	var index, sig, pch, freq;

	index = LFDNoise0.kr(t / 4).range(0, 1);
    index = (index * BufFrames.kr(buffer));
    pch = (Index.kr(buffer, in: index) + [40, 52]).lag;
    freq = pch.midicps;

    sig = VarSaw.ar(freq) * -6.dbamp;
    sig = Splay.ar(sig);

	sig = CombN.ar(
        in: sig,
        maxdelaytime: 0.31,
        delaytime: 0.31,
        decaytime: 2
    );
}
)

(
var buffer = Buffer.loadCollection(s, [0, 3, 7, 11]);

~m63 = Ndef(\m63);
~m63[0] = {
    var freq = Index.kr(
        bufnum: buffer,
        in: LFSaw.kr(t / 4).range(0, 5)
    );

    VarSaw.ar(freq: (freq + [40, 52]).midicps) * -12.dbamp;
}
)
