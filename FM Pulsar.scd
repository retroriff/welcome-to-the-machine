1 i: \fmPulsar degree: [0, 4, 7, 11] dur: [0.15, 0.9] scale: \major octave: [4, 5, 6].stutter(3) root: 0;
2 i: \fmPulsar degree: [0, 3, 7, 14] dur: [2, 4] scale: \minor octave: [4, 5, 6].stutter(3) root: 4;

3 i: \henon dur: 1 amp: Pwhite(0, 0.2) degree: [0, 3, 7, 14] root: 4 octave: 6 rel: Pexprand(0.01, 0.5) args: (a: Pwhite(0, 1.0), b: Pwhite(0, 0.5)) reverb: 0.5;
4 i: \henon dur: 0.25 amp: Pwhite(0.0, 0.7);