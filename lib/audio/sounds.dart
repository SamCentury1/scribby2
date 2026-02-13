List<String> soundTypeToFileName(SfxType type) {
  switch (type) {
    case SfxType.tileTap:
      return const [
        'tap_1.wav',
        'tap_2.wav',
        'tap_3.wav',
        'tap_4.wav',
      ];     

    case SfxType.glassBreak:
      return const [
        'glass_break_1.wav',
        'glass_break_2.wav',
      ];       

    case SfxType.wordFound:
      return const [
        'word_found_1.wav',
        'word_found_2.wav',
        'word_found_3.wav',
      ];                                         
  }

}


enum SfxType {
  tileTap,
  glassBreak,
  wordFound
}