// Play with freq: SinOsc.kr(t).range(62, 100).midicps
(
Ndef(\m61, {
    RLPF.ar(
        in: LFPulse.ar([28, 40].midicps, iphase: 0.15),
        freq: SinOsc.kr(t).range(62, 67.clip(67, 120)).midicps,
        mul: LFPulse.kr(t * 4).range(0, 0.5).lag(0.1)
    );
});
)

(
var collection = [0, 3, 5, 7].stutter(2).scramble.mirror2;
var buffer = Buffer.loadCollection(s, collection);

("🎲" + collection).postln;

Ndef(\m62, {
	var env, gate = 1, index, pitch, sig, freq;

    index = Stepper.kr(
        trig: Impulse.kr(t * 4),
        reset: 0,
        min: 0,
        max: BufFrames.kr(buffer) - 1,
        step: 1
    );

    pitch = Index.kr(buffer, index) + [40, 52];
    freq = pitch.midicps;

    sig = VarSaw.ar(freq) * -10.dbamp;
    sig = Splay.ar(sig);
});
)

Nfx new: \m62 delay: 0.7 gverb: 0.5 blp: 0.4;
