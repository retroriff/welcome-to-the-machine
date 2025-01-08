// Play with freq: SinOsc.kr(t).range(62, 100).midicps
// Play with tempo: 16

Ndef(\m51).set(\freq, 50);
Ndef(\m51).set(\tempo, 16);

(
Ndef(\m51, {
    RLPF.ar(
        in: LFPulse.ar([28, 40].midicps, iphase: 0.15),
        freq: SinOsc.kr(t / \tempo.kr(1)).range(62, \freq.kr(67).clip(67, 120)).midicps,
        mul: LFPulse.kr(t * 4).range(0, 1).lag(0.1),
    );
});
)

Ndef(\m51).play;
Ndef(\m51).stop;

Ndef(\m52).play;
Ndef(\m52).stop;

(
Ndef(\m52, {
    var decay = \decay.kr(1.01);
    var freq = 28.midicps;
    var pulse = LFPulse.ar(t / 2, iphase: 0.5).range(1, 2);
    var bass = SinOsc.ar(freq * decay * pulse);
    var saw = LFSaw.ar(freq * decay * pulse);

    var env = EnvGen.kr(Env.perc(0.01, 1), gate: Impulse.kr(t));
    var out = Mix(LPF.ar([bass, saw], 140)) * env * -2.dbamp;
    out ! 2;
});
)


(
var collection = [ 0, 7, 5, 3, 7, 5, 0, 3, 3, 0, 5, 7, 3, 5, 7, 0 ];
var buffer = Buffer.loadCollection(s, collection);

("🎲" + collection).postln;

Ndef(\m53, {
	var env, gate = 1, index, pitch, sig, freq;

    index = Stepper.kr(
        trig: Impulse.kr(t * 4),
        reset: 0,
        max: BufFrames.kr(buffer) - 1,
        step: \step.kr(1);
    );

    pitch = Index.kr(buffer, index) + [40, 52];
    freq = pitch.midicps;

    sig = VarSaw.ar(freq) * -14.dbamp;
    sig = BLowPass4.ar(sig, MouseX.kr(500, 5000), rq: 0.1);
    sig = Splay.ar(sig);
});
)

\m53 in: 20;

Ndef(\m53).set(\step, 1);

Fx new: \m53 delay: 0.3 gverb: 0.6;
Fx new: \m52 delay: 0.3 gverb: 0.7;
Fx.activeEffects

1 play: ["machine/metal", 1] dur: 2 amp: 0.4