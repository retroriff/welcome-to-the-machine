// Play with freq: SinOsc.kr(t).range(62, 100).midicps
(
Ndef(\m61, {
    RLPF.ar(
        in: LFPulse.ar([28, 40].midicps, iphase: 0.15),
        freq: SinOsc.kr(t / 16).range(62, 100.clip(67, 120)).midicps,
        mul: LFPulse.kr(t * 4).range(0, 1).lag(0.1)
    );
});
)

\m61 out: 0
\m62 in: 0
\m64 in: 0
\m65 in: 10

(
Ndef(\m62, {
    var decay = \decay.kr(1.01);
    var freq = 28.midicps;
    var env = EnvGen.kr(Env.perc(0.01, 1), gate: Impulse.kr(t));

    // Oscillators
    var bass = LPF.ar(SinOsc.ar(freq * decay, mul: 0.5), 200);
    var saw = LPF.ar(LFSaw.ar(freq * decay, mul: 0.5), 200);

    var out = Mix([bass, saw]) * env;
    out ! 2;
});
)

(
Ndef(\m63, {
    var env, sig;
    sig = Saw.ar(48);
    sig = BPF.ar(sig, (0..30).normalize.linexp(0, 1, 60, 3000), 0.1).sum;
    sig = sig.tanh;
    sig = sig * EnvGen.kr(Env.perc(attackTime: 0.1, releaseTime: 0.8, curve: \sin), gate: Impulse.kr(t / 2));
    sig ! 2;
});
)


(
var collection =[ 12, 19, 15, 19, 12, 17, 15, 17 ];
var buffer = Buffer.loadCollection(s, collection);

("🎲" + collection).postln;

Ndef(\m64, {
	var env, gate = 1, index, pitch, sig, freq;

    index = Stepper.kr(
        trig: Impulse.kr(t * 8),
        reset: 0,
        min: 0,
        max: BufFrames.kr(buffer) - 1,
        step: 1
    );

    pitch = Index.kr(buffer, index) + [40, 52];
    freq = pitch.midicps;

    sig = VarSaw.ar(freq, width: 0.8) * -6.dbamp;
    sig = Splay.ar(sig);
});
)

Fx new: \m63 gverb: 0.5 blp: 0.4;

(
Ndef(\m65, {
    var env, sig;

    env = EnvGen.kr(Env.perc(attackTime: 0.2, releaseTime: 1, curve: \sin), gate: Impulse.kr(t));
    sig = Saw.ar(40.midicps);
    sig = CombC.ar(sig, maxdelaytime: 0.2, delaytime: 1 / 63, decaytime: 0.3);
    sig = RLPF.ar(sig, SinOsc.ar(t * 2).range(100, 1000), rq: 1);
    sig = BHiShelf.ar(sig, 1200, 1, 1);
    sig = BPF.ar(sig, freq: (0..40).normalize.linexp(0, 1, 60, 5000), rq: 0.1).sum;
    sig = sig.tanh;
    sig = sig * -14.dbamp;

    // Fx
    sig = sig + PitchShift.ar(sig, \windowSize.kr(0.2), pitchRatio: 0.2);
    sig = sig + GVerb.ar(sig * -10.dbamp, roomsize: 10, revtime: 3);

    sig = Mix.ar(sig);
    // sig = sig * env;

    sig ! 2;
});
)


Ndef(\m65).fadeTime_(1)
Ndef(\m65).set(\windowSize, 0.6)

\m65.play
