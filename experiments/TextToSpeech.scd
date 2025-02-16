(
w = Buffer.readChannel(s, "../samples/speech/01.wav".resolveRelative, channels:[0]);

SynthDef(\slow_playback_with_fx, {
    |buf, rate = 0.8|

    var sig, dur, verb, delay, dist, env;

    // Playback at slower speed
    rate = BufRateScale.ir(buf) * rate;
    sig = PlayBuf.ar(1, buf, rate);

    // Envelope ensures smooth release
    dur = BufDur.kr(buf) / rate;
    dur = dur + 5;  // Add 5 extra seconds to let reverb/delay fade naturally
    env = EnvGen.kr(Env.linen(0.1, dur, 5), doneAction: 2);

    // Fx
    sig = FreeVerb.ar(sig, mix: 0.4, room: 0.5, damp: 0.2);
    sig = CombN.ar(sig, 1, 0.4, 4);

    Out.ar(0, sig * env);
}).add;
)

Synth(\slow_playback_with_fx, [\buf, w]);

(
Ndef(\speech, {
    var dur, env, rate = 0.7, sig;

    sig = GrainBuf.ar(
        numChannels: 2,
        trigger: Dust.ar(400),
        dur: 0.1,
        sndbuf: w,
        rate: 0.7,
        pos: (
            Phasor.ar(0,
                rate: 1 * BufRateScale.ir(w),
                start: 0,
                end: BufSamples.ir(w) - 1
            ) + LFNoise1.ar(100).bipolar(0.0 * SampleRate.ir)
        ) / BufSamples.ir(w),
        mul: 0.4
    );

    // Fx
    sig = FreeVerb.ar(
        sig,
        mix: 0.4,
        room: 0.5,
        damp: 0.2
    );

    sig = CombN.ar(
        sig,
        maxdelaytime: 1,
        delaytime: LFNoise1.kr(t).range(0.01, 0.04),
        decaytime: 2
    );

    dur = BufDur.kr(w) / rate;
    dur = dur + 5;  // Add 5 extra seconds to let reverb/delay fade naturally
    env = EnvGen.kr(Env.linen(0.1, dur, 5), doneAction: 2);

    sig * env;
}).play;
)
