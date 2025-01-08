/*
@author: Alik Rustamoff
@url: https://scsynth.org/t/fm-pulsar-by-rustamoff-modified-version/10483
*/

(
SynthDef("fmPulsar", { |amp|
    var dur, env, freq, sig, out = 0;
    var carfreq, index, modfreq, overlap, trig, vel, vel_;

    freq = \freq.kr(60.midicps) + SinOsc.ar(LFNoise1.kr(0.6 ! 2).range(3, 6));

    vel = \vel.kr(0.6);
    vel_ = vel.clip(0, 1.0).linlin(0, 1, 2.5, 0.75);

    env = EnvGen.kr(
        Env.adsr(
            \att.kr(2.5) * vel_,
            \dec.kr(0.03) * vel_,
            \susl.kr(0.85),
            \rel.kr(6.0),
            curve: \curve.kr(-3.5)
        ),
        gate: \gate.kr(1),
        doneAction:2
    ) * vel;

    trig = Impulse.ar(freq);
    index = env.pow(3.5) * LFNoise2.kr(5.5 ! 2).range(\mIndMin.kr(0.15), \mIndMax.kr(2.5));
    overlap = 1.15 - env.pow(0.55) * LFNoise1.kr(0.35 ! 2).range(\olapMin.kr(1.5), \olapMax.kr(8.5));
    dur = overlap / freq;
    carfreq = freq * \cf.kr(2.5) + LFNoise1.kr(3.5).range(0, 55);
    modfreq = carfreq * \mf.kr(2.5) + LFNoise1.kr(3.5).range(0, 110);

    sig = Mix([
        SinOsc.ar(freq),
        GrainFM.ar(1, trig, dur, carfreq, modfreq, index),
    ]);

    sig = LeakDC.ar(sig * env);
    sig = BLowPass4.ar(sig, freq: 950) * -4.dbamp;
    Out.ar(out, sig * amp);
}).add
)
