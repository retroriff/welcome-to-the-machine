Crossfader(\m03, \m11)
FadeIn(\m13)
FadeOut(\px);

(
~m11 = Ndef(\m11);
~m11[0] = {
    SinOscFB.ar(
        freq: [100, 101],
        feedback: LFSaw.kr(t / 4).range(0.2, 1),
        mul: LFPulse.kr(t / 2).range(0.2, 1),
    );
}
)

(
Px([
    (play: ["fm", \rand], dur: 1/4).beat.weight(0.2).amp(0.2).seed(13),
    (play: ["fm", \rand], dur: 1/4).fill.weight(0.4).amp(0.2).seed(830),
    (play: ["fm", \rand], dur: 1/4).fill.weight(0.4).amp(0.2).seed(450),
], \m12).reverb(0.4).blp;
)

(
~m13 = Ndef(\m13);
~m13[0] = {
    Greyhole.ar(
        in: Impulse.ar(MouseX.kr(1, 1000)),
        delayTime: 2,
        damp: 0.5
    );
};
)
