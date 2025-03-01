"init.scd".loadRelative;

(
Tdef(\m01, {
  loop {
    (1..8).choose.do({
      var octaves = [0.25, 0.5, 1, 2].choose;
      var rate = (~degree.choose + ~key).midicps * octaves;

      4.do({
        Synth.new(\gs, [
          \amp, exprand(0.05, 0.55),
          \atk, exprand(1, 4),
          \baseDur, 0.02,
          \buf, ~buf,
          \dens, rate * rrand(-0.15, 0.15).midiratio,
          \pan, rrand(-0.8, 0.8),
          \pos, (3..6).choose / 10,
          \posSpeed, 0,
          \rel, exprand(3, 6),
        ]);
      });

      exprand(0.1, 8).wait;
    });
  };
});
)

(
Ndef(\m02, {
  var degree = \degree.kr(~degree);
  var buffer = LocalBuf.newFrom(degree);
  var writer = degree.collect { |deg, i| BufWr.kr(deg, buffer, i) };
  var key = \key.kr(~key);

  var freq = DegreeToKey.kr(
    bufnum: buffer,
    in: MouseX.kr(0, 12),
    octave: 12,
    mul: 1,
    add: key
  );

  var drone5ths = RLPF.ar(
    in: LFPulse.ar([key, key + 7].midicps, iphase: 0.15),
    freq: SinOsc.kr(0.1, mul: 10, add: key + 12).midicps,
    rq: 0.1,
    mul: 0.05
  );

  var lowFreqDetuning = LFNoise1.kr([3, 3], mul: 0.04);

  var osc1 = SinOsc.ar((freq + lowFreqDetuning).midicps, mul: 0.1);
  var osc2 = Impulse.ar(freq.midicps, phase: 2);

  osc1 = CombN.ar(
    in: (osc1 + drone5ths) * MouseY.kr(0.5, 1),
    maxdelaytime: 0.31,
    delaytime: 0.31,
    decaytime: 2,
    mul: 2,
    add: osc1
  );

  osc2 = Greyhole.ar(
    in: osc2 * MouseY.kr(0, 1),
    delayTime: 2,
    damp: 0.5
  );

  (osc1 + osc2) * \dbamp.kr(-4).dbamp;
});
)

(
Ndef(\m03, {
  var lfo1 = LFPulse.ar(t / 2).range(0.5, 1);
  var lfo222 = SinOscFB.ar(t * 8).range(0.5, 1);
  var randPos = Array.rand(4, 1, 4) / 10;
  var pos = Demand.kr(
    Impulse.kr(t / 8),
    reset: 0,
    demandUGens: Dseq(randPos, inf)
  );

  GrainBuf.ar(
    numChannels: 2,
    trigger: LFPulse.kr(t * 8),
    dur: 0.7,
    sndbuf: ~buf,
    rate: 1,
    pos: pos,
    interp: 2,
    pan: MouseX.kr(-0.7, 0.7),
  );
});
)
