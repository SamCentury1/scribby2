
List<String> soundTypeToFileName(SfxType type) {
  switch (type) {
    case SfxType.startGame:
      return const [
        'start_game.mp3'
      ];
    case SfxType.finishGame:
      return const [
        'game_over.mp3'
      ];          
    case SfxType.tilePress:
      return const [
        // 'place-tile.mp3',
        'click_1.mp3',
        'click_2.mp3',
        'click_3.mp3',
        'click_4.mp3',
        'click_5.mp3',
        'click_6.mp3',
        
      ];
    case SfxType.wordFound:
      return const [
        // 'word-found.mp3'
        // 'ding.mp3'
        'word_found_3.mp3'
      ];
    case SfxType.streak:
      return const [
        'streak.mp3'
      ];
    case SfxType.crossWord:
      return const [
        'ding_2.mp3'
      ];      
    case SfxType.levelUp:
      return const [
        'level-up.mp3'
      ]; 
    case SfxType.bad:
      return const [
        'bad.mp3'
      ]; 
    case SfxType.highScore:
      return const [
        'high-score.mp3'
      ];    
    case SfxType.superPoints:
      return const [
        'super-points.mp3'
      ];  
    case SfxType.gameOverScoreCount:
      return const [
        'game-over-score-count.mp3'
      ];              
    // case SfxType.placeTile:
    //   return const [
    //     'place-tile.mp3'
    //   ];   

    case SfxType.placeReserve:
      return const [
        'place-reserve.mp3'
      ];

    case SfxType.tada1:
      return const [
        'tada1.mp3'
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
  startGame,
  finishGame,
  tilePress,
  wordFound,
  streak,
  crossWord,
  levelUp,
  bad,
  highScore,
  placeReserve,
  optionSelected,
  superPoints,
  tada1,
  gameOverScoreCount
  // wordFoundStreak,
  // optionSelected,
}