import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';

class TutorialHelpers {
  Map<String, dynamic> tutorialTileState(
      int index, TutorialState tutorialState) {
    late Map<String, dynamic> tileState = tutorialState.tutorialTileState
        .firstWhere((element) => element['index'] == index);
    return tileState;
  }

  void updateTutorialTileState(TutorialState tutorialState, int targetIndex,
      AnimationState animationState) {
    /// Step one is to update the random letters list array and add to it, the next
    /// chosen letter from the "tutorialettersToAdd" list
    tutorialState.setTutorialRandomLetterList([
      ...tutorialState.tutorialRandomLetterList,
      tutorialState.tutorialLettersToAdd[tutorialState.tutorialTurn]
    ]);

    /// Get the letter to 3 positions from the end of the random letters list
    /// (the 2 final positions are for the random letters to display)
    final String letterSource = tutorialState.tutorialRandomLetterList[
        tutorialState.tutorialRandomLetterList.length - 3];

    /// retrieve the object belonging to the selected index
    late Map<String, dynamic> targetObject =
        tutorialTileState(targetIndex, tutorialState);

    /// update the object to reflect the next in line letter to add
    targetObject.update('letter', (value) => letterSource);
    targetObject.update('active', (value) => false);

    /// create a copy of the tile state and update it with the newly updated object
    late List<Map<String, dynamic>> newTileState =
        tutorialState.tutorialTileState;
    newTileState[newTileState.indexWhere(
        (element) => element['index'] == targetIndex)] = targetObject;

    /// increment the turn by one
    tutorialState.setTutorialTurn(tutorialState.tutorialTurn + 1);

    /// display the new board
    tutorialState.setTutorialTileState(newTileState);

    /// run the animation for the new letter
    animationState.setShouldRunAnimation(true);

    /// increment the sequence step of the tutorial by one
    tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
  }
}
