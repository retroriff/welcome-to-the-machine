(
~playSpeech = { |post|
  Mouse(\a, { |mouse, x, y|
    var msgArgs, newSentiment, newWords, sendOsc;
    var max = 10;

    newWords = (x * max).round.asInteger.clip(1, max).asString;
    newSentiment = (y * max).round.asInteger.asString;

    sendOsc = {
      if (~machine.notNil) {
        msgArgs = [
          "track", "6",
          "sentiment", newSentiment,
          "words", newWords,
        ];

        ~machine.sendMsg("/machine", *msgArgs);

        if (post) {
          msgArgs.postln;
        }
      } {
        "🔴 Machine's net address is not set".postln;
      };
    };

    if (~currentWords != newWords || ~currentSentiment != newSentiment) {
      sendOsc.value;
      ~currentSentiment = newSentiment;
      ~currentWords = newWords;
    };
  });
};

~stopSpeech= {
  Mouse(\a).free;

  if (~machine.notNil) {
    ~machine.sendMsg("/machine", "track", Nil);
  };

  "Kill'Em All 🔴🔨";
};
)

~playSpeech.(true);
~stopSpeech.(true);
