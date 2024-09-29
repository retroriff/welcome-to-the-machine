(
/**
* @author: Eli Fieldsteel
* @url: https://github.com/elifieldsteel/SuperCollider-Tutorials/blob/master/full%20video%20scripts/25_script.scd
*/

SynthDef.new(\gs, {
    |sync = 1, dens = 20, baseDur = 0.1, durRand = 1, buf = 0, rate = 1,
    pos = 0, posSpeed = 1, posRand = 0, grainEnv = (-1), pan = 0, panHz = 0.1, panRand = 0,
    atk = 1, sus = 2, rel = 1, c0 = 1, c1 = (-1), amp = 1, out = 0|

    var densCtrl, durCtrl, env, panCtrl, posCtrl, sig;

    // Density control (sync selects between Dust and Impulse)
    densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);

     // Duration control (adds randomness to base duration)
    durCtrl = baseDur * LFNoise1.kr(100).exprange(1 / durRand, durRand);

    // Envelope generation
    env = EnvGen.ar(
        Env.new(
            levels: [0, 1, 1, 0],
            times: [atk, sus, rel],
            curve: [c0, 0, c1]
        ),
        doneAction: 2);

    // Panning control
    panCtrl = pan + LFNoise1.kr(panHz).bipolar(panRand);

    // Position control (based on Phasor and noise randomness)
    posCtrl = Phasor.ar(
        trig: 0,
        rate: posSpeed * BufRateScale.ir(buf),
        start: 0,
        end: BufSamples.ir(buf)
    );
    posCtrl = posCtrl + LFNoise1.kr(100).bipolar(posRand * SampleRate.ir);
    posCtrl = posCtrl / BufSamples.ir(buf);
    posCtrl = posCtrl + pos;

     // Granular synthesis
    sig = GrainBuf.ar(
        numChannels: 2,
        trigger: densCtrl,
        dur: durCtrl,
        sndbuf: buf,
        rate: rate,
        pos: posCtrl,
        interp: 2,
        pan: panCtrl,
        envbufnum: grainEnv
    );

    Out.ar(out, sig * env * amp);
}).add;
)
