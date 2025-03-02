~machine.sendMsg("/machine", "track", 5);

(
Ndef(\m51, {
  |amp = 0.6, freq = 120, tempo = 16|

  RLPF.ar(
    in: Pulse.ar([28, 40].midicps),
    freq: SinOsc.kr(t / tempo, phase: -1).range(62, freq.clip(67, 120)).midicps,
    mul: LFPulse.kr(t * 4).range(0, amp).lag(0.1),
  );
}).quant_(16);
)

5 name: \bass chan: 2 dur: 1 octave: [2, 3] degree: 2 amp: 1;

(
Ndef(\m52, {
  var decay = \decay.kr(1.01);
  var freq = 28.midicps;
  var pulse = LFPulse.ar(t / 2, iphase: 0.5).range(1, 2);
  var bass = SinOsc.ar(freq * decay * pulse, mul: 0.4);
  var saw = LFSaw.ar(freq * decay * pulse, mul: 0.4);

  var env = EnvGen.kr(Env.perc(0.01, 1), gate: Impulse.kr(t));
  var out = Mix(LPF.ar([bass, saw], freq: 140)) * env;
  out ! 2;
});
)

( // 🎛️
var collection = [0, 3, 5, 7].stutter(2).scramble.mirror2;
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

  sig = VarSaw.ar(freq, mul: \amp.kr(0.3));
  sig = BLowPass4.ar(sig, MouseX.kr(500, 5000), rq: 0.1);
  sig = Splay.ar(sig) * -6.dbamp;
}).play;
)

Fx new: \m53 delay: 0.3 gverb: 0.5;

// On the run
[4, 7, 9, 7, 14, 12, 14, 16]
1 i: \ch dur: 0.25;
Fx(\1).blp(1);
2 i: \oh dur: 2 amp: 1.2 off: 1;
