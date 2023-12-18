
List<String> soundTypeToFileName(SfxType type) {
  switch (type) {
    case SfxType.tilePress:
      return const [
        'notification-sound-7062.mp3'
        
      ];
    case SfxType.wordFound:
      return const [
        'game-start-6104.mp3'
      ];
    // case SfxType.wordFoundStreak:
    //   return const [];
    case SfxType.optionSelected:
      return const [
        'click-21156.mp3'
      ];
  }

}


enum SfxType {
  tilePress,
  wordFound,
  optionSelected
  // wordFoundStreak,
  // optionSelected,
}