List<String> soundTypeToFileName(SfxType type) {
  switch (type) {
    case SfxType.tileTap:
      return const [
        'tap_1.wav', 
        'tap_2.wav', 
        'tap_3.wav', 
        'tap_4.wav',
        'tap_5.wav',
        'tap_6.wav',
      ];

    case SfxType.glassBreak:
      return const [
        'glass_break_1.wav', 
        'glass_break_2.wav',
      ];

    case SfxType.tileFreeze:
      return const [
        'freeze_1.wav',
        'freeze_2.wav',
        'freeze_3.wav',
        'freeze_4.wav',
      ];
    case SfxType.tileThaw:
      return const [
        'thaw_1.wav',
        'thaw_2.wav',
      ];

    case SfxType.tileKill:
      return const [
        'tile_kill_1.wav',
        'tile_kill_1.wav',
      ];

    case SfxType.tileUndo:
      return const [
        'tile_undo_1.wav', 
        'tile_undo_2.wav',
      ];

    case SfxType.tileSwap:
      return const [
        'tile_swap_1.wav', 
        'tile_swap_2.wav',
      ];

    case SfxType.crossword:
      return const [
        // 'special_2.wav',
        // 'special_2_2.wav',
        "crossword_1.wav",
        "crossword_1.wav",
      ];   

    case SfxType.streak:
      return const [
        // 'special_2.wav',
        // 'special_2_2.wav',
        "streak_1.wav",
        "streak_1.wav",
      ];   


    case SfxType.scoreTally:
      return const [
        'score_tally.wav',
        'score_tally.wav',
      ];

    case SfxType.scoreTallyEnd:
      return const [
        'score_tally_end.wav',
        'score_tally_end.wav',
      ];   

    case SfxType.newRank:
      return const [
        'new_rank.wav',
        'new_rank.wav',
      ];  

    case SfxType.ding:
      return const [
        'score_tally_end_2.wav',
        'score_tally_end_2.wav',
      ];  


    case SfxType.coins:
      return const [
        'coins.wav',
        'coins.wav',
      ]; 

    case SfxType.gameOver:
      return const [
        'game_over.wav',
        'game_over.wav',
      ];  

    case SfxType.missionAccomplished:
      return const [
        'mission_accomplished.wav',
        'mission_accomplished.wav',
      ];   

    case SfxType.perkSelect:
      return const [
        'perk_select.wav',
        'perk_select.wav',
      ];                                         
  }
}

enum SfxType {
  tileTap, 
  glassBreak, 
  tileFreeze,
  tileThaw,
  tileKill, 
  tileUndo, 
  tileSwap,
  crossword,
  streak,
  scoreTally,
  scoreTallyEnd,
  newRank,
  ding,
  coins,
  gameOver,
  missionAccomplished,
  perkSelect
}
