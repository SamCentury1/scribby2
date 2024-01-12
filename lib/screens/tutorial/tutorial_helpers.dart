import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialHelpers {
  Map<String, dynamic> tutorialTileState(
      int index, TutorialState tutorialState) {
    late Map<String, dynamic> tileState = tutorialState.tutorialTileState
        .firstWhere((element) => element['index'] == index);
    return tileState;
  }

  void updateTutorialTileState(TutorialState tutorialState, int targetIndex, AnimationState animationState,  List<Map<String,dynamic>> steps) {
    /// Step one is to update the random letters list array and add to it, the next
    /// chosen letter from the "tutorialettersToAdd" list
    tutorialState.setTutorialRandomLetterList([
      ...tutorialState.tutorialRandomLetterList,
      tutorialState.tutorialLettersToAdd[tutorialState.tutorialTurn]
    ]);

    /// Get the letter to 3 positions from the end of the random letters list
    /// (the 2 final positions are for the random letters to display)
    final String letterSource = tutorialState.tutorialRandomLetterList[tutorialState.tutorialRandomLetterList.length - 3];

    /// retrieve the object belonging to the selected index
    late Map<String, dynamic> targetObject = tutorialTileState(targetIndex, tutorialState);

    /// update the object to reflect the next in line letter to add
    targetObject.update('letter', (value) => letterSource);
    targetObject.update('active', (value) => false);

    /// create a copy of the tile state and update it with the newly updated object
    late List<Map<String, dynamic>> newTileState = tutorialState.tutorialTileState;

    newTileState[newTileState.indexWhere((element) => element['index'] == targetIndex)] = targetObject;

    /// increment the turn by one
    tutorialState.setTutorialTurn(tutorialState.tutorialTurn + 1);

    /// display the new board
    tutorialState.setTutorialTileState(newTileState);

    /// run the animation for the new letter
    animationState.setShouldRunAnimation(true);
    animationState.setShouldRunAnimation(false);

    /// increment the sequence step of the tutorial by one
    tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);

    /// listens for whether to animate any of the scoreboard items
    listenForScoreItems(tutorialState, steps, animationState);  
  }

  void placeIntoReserves(BuildContext context, TutorialState tutorialState, Map<String, dynamic> reserveSpot, List<Map<String,dynamic>> steps) {
    late AnimationState animationState = context.read<AnimationState>();

    if (reserveSpot["body"] == "") {
      animationState.setShouldRunAnimation(true);

      tutorialState.setTutorialRandomLetterList([
        ...tutorialState.tutorialRandomLetterList,
        tutorialState.tutorialLettersToAdd[tutorialState.tutorialTurn]
      ]);      


      final String letterSource = tutorialState.tutorialRandomLetterList[tutorialState.tutorialRandomLetterList.length - 3];

      reserveSpot.update('body', (value) => letterSource);

      late List<Map<String, dynamic>> newReserveState = tutorialState.reserveTiles;

      newReserveState[newReserveState.indexWhere((element) => element['id'] == reserveSpot['id'])] = reserveSpot;

       
      
      /// increment the turn by one
      tutorialState.setTutorialTurn(tutorialState.tutorialTurn + 1);

      /// display the new board
      tutorialState.setReserveTiles(newReserveState);    

      /// run the animation for the new letter
      animationState.setShouldRunAnimation(true);
      animationState.setShouldRunAnimation(false);

      /// increment the sequence step of the tutorial by one
      tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);       

      /// listens for whether to animate any of the scoreboard items
      listenForScoreItems(tutorialState, steps, animationState);     

      // tutorialState.countDownController.restart(
      //     duration:
      //         GameLogic().getCountdownDuration(tutorialState.currentLevel));

      animationState.setShouldRunAnimation(false);
    }
  }



  void dropTile(BuildContext context, int targetIndex, TutorialState tutorialState, List<Map<String,dynamic>> steps) async {
    late AnimationState animationState = context.read<AnimationState>();
    // late AudioController audioController = context.read<AudioController>();


    final String letterSource = tutorialState.draggedReserveTile["body"];


    late Map<String, dynamic> targetObject = tutorialTileState(targetIndex, tutorialState);

    /// update the object to reflect the next in line letter to add
    targetObject.update('letter', (value) => letterSource);
    targetObject.update('active', (value) => false);


    late Map<String, dynamic> draggedTile = tutorialState.draggedReserveTile;
    draggedTile.update("body", (value) =>"");

    late List<Map<String, dynamic>> newReserveState = tutorialState.reserveTiles;
    newReserveState[newReserveState.indexWhere((element) => element['id'] == draggedTile['id'])] = draggedTile;


    late List<Map<String, dynamic>> newTileState = tutorialState.tutorialTileState;
    newTileState[newTileState.indexWhere((element) => element['index'] == targetIndex)] = targetObject;

    /// increment the turn by one
    tutorialState.setTutorialTurn(tutorialState.tutorialTurn + 1);

    /// display the new board
    tutorialState.setTutorialTileState(newTileState);
    
    /// display the new reserve tile state
    tutorialState.setReserveTiles(newReserveState);

    // /// run the animation for the new letter
    // animationState.setShouldRunAnimation(true);

    /// increment the sequence step of the tutorial by one
    tutorialState.setSequenceStep(tutorialState.sequenceStep + 1); 

    /// listens for whether to animate any of the scoreboard items
    listenForScoreItems(tutorialState, steps, animationState);            
  }


  /// This function helps determine whether any of the bonus items (streak,
  /// multi_word, or cross_word) needs to have their animation executed
  void listenForScoreItems(TutorialState tutorialState, List<Map<String,dynamic>> steps, AnimationState animationState) {
    final Map<String,dynamic> step = steps[tutorialState.sequenceStep];
    final Map<String,dynamic> previousStep = steps[tutorialState.sequenceStep-1];

    /// STREAK
    
    if (step['streak'] == 1) {
      animationState.setShouldRunTutorialStreakEnterAnimation(true);
      animationState.setShouldRunTutorialStreakEnterAnimation(false);      
    } 
    if (step['streak'] == 0) {
      animationState.setShouldRunTutorialStreakExitAnimation(true);
      animationState.setShouldRunTutorialStreakExitAnimation(false);       
    }

    // if (step['targets'].contains('streak')) {
    //   animationState.setShouldRunTutorialStreakEnterAnimation(true);
    //   animationState.setShouldRunTutorialStreakEnterAnimation(false);
    // }
    // if (!step['targets'].contains('streak')) {
    //   if (previousStep['targets'].contains('streak')) {
    //     animationState.setShouldRunTutorialStreakExitAnimation(true);
    //     animationState.setShouldRunTutorialStreakExitAnimation(false);        
    //   }
    // }

    /// MULTI WORD
    // if (step['targets'].contains('multi_word')) {
    //   animationState.setShouldRunTutorialMultiWordEnterAnimation(true);
    //   animationState.setShouldRunTutorialMultiWordEnterAnimation(false);
    // }
    // if (!step['targets'].contains('multi_word')) {
    //   if (previousStep['targets'].contains('multi_word')) {
    //     animationState.setShouldRunTutorialMultiWordExitAnimation(true);
    //     animationState.setShouldRunTutorialMultiWordExitAnimation(false);        
    //   }
    // }  
    if (step['newWords'] >= 1) {
      animationState.setShouldRunTutorialMultiWordEnterAnimation(true);
      animationState.setShouldRunTutorialMultiWordEnterAnimation(false);      
    } 
    if (step['newWords'] == 0) {
      animationState.setShouldRunTutorialMultiWordExitAnimation(true);
      animationState.setShouldRunTutorialMultiWordExitAnimation(false);       
    } 

    /// CROSSWORD
    // if (step['targets'].contains('cross_word')) {
    //   animationState.setShouldRunTutorialCrosswordEnterAnimation(true);
    //   animationState.setShouldRunTutorialCrosswordEnterAnimation(false);
    // }
    // if (!step['targets'].contains('cross_word')) {
    //   if (previousStep['targets'].contains('cross_word')) {
    //     animationState.setShouldRunTutorialCrosswordExitAnimation(true);
    //     animationState.setShouldRunTutorialCrosswordExitAnimation(false);        
    //   }
    // } 
    if (step['crossword'] >= 1) {
      animationState.setShouldRunTutorialCrosswordEnterAnimation(true);
      animationState.setShouldRunTutorialCrosswordEnterAnimation(false);      
    } 
    if (step['crossword'] == 0) {
      animationState.setShouldRunTutorialCrosswordExitAnimation(true);
      animationState.setShouldRunTutorialCrosswordExitAnimation(false);       
    }               
  }


  void killSpot(TutorialState tutorialState, int targetIndex) {
    late Map<String, dynamic> targetObject = tutorialTileState(targetIndex, tutorialState);
    targetObject.update('alive', (value) => false);

    late List<Map<String, dynamic>> newTileState = tutorialState.tutorialTileState;
    newTileState[newTileState.indexWhere((element) => element['index'] == targetIndex)] = targetObject;

    tutorialState.setTutorialTileState(newTileState);

    tutorialState.setSequenceStep(tutorialState.sequenceStep+1);

  }


  void executePreviousStep(TutorialState tutorialState, AnimationState animationState) {
    if (tutorialState.sequenceStep > 0) {
      tutorialState.setSequenceStep(tutorialState.sequenceStep - 1);
      animationState.setShouldRunTutorialPreviousStepAnimation(true);
      animationState.setShouldRunTutorialPreviousStepAnimation(false);
    }
  }


  void saveStateHistory(TutorialState tutorialState, List<Map<String,dynamic>> steps) {
    final Map<String,dynamic> currentStep = steps.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
    
    currentStep['random_letter_state'] = tutorialState.tutorialRandomLetterList;
    currentStep['reserve_state'] = tutorialState.reserveTiles;
    currentStep['tile_state'] = tutorialState.tutorialTileState;
    currentStep['randomLetter1'] = tutorialState.tutorialLettersToPlace[tutorialState.sequenceStep ];
    currentStep['randomLetter2'] = tutorialState.tutorialLettersToPlace[tutorialState.sequenceStep + 1];

    List<Map<String,dynamic>> currentHistory = tutorialState.tutorialStateHistory;
    // currentHistory.a

    tutorialState.setTutorialStateHistory([...currentHistory, currentStep]);
  }

  // void addLetterToRandomLetterList(TutorialState tutorialState) {
  //   int currentStep = tutorialState.sequenceStep;
  //   List<String> currentList = tutorialState.tutorialRandomLetterList;
  //   List<String> lettersToAdd = tutorialState.tutorialLettersToAdd;
  //   tutorialState.setTutorialRandomLetterList([...currentList, lettersToAdd[currentStep]]);    
  // } 


  // void addLetterToTileState(TutorialState tutorialState, Map<String,dynamic> currentStep) {

  //   /// get the tile spot where the letter needs to be displayed in the next step
  //   List<String> input = currentStep['input'].split("_");
  //   String inputTargetType = input[0];
  //   int index = int.parse(input[1]);


  //   /// current random letter 1
  //   late String letterSource = "";

  //   if (inputTargetType == 'tile') {
  //     late Map<String, dynamic> targetObject = tutorialTileState(index, tutorialState);

  //     if (currentStep['inputType'] != 'auto') {
  //       letterSource = tutorialState.tutorialLettersToPlace[currentStep['step']];
  //     } 
  //     /// update the object to reflect the next in line letter to add
  //     targetObject.update('letter', (value) => letterSource);
  //     targetObject.update('active', (value) => false);

  //     /// create a copy of the tile state and update it with the newly updated object
  //     late List<Map<String, dynamic>> newTileState = tutorialState.tutorialTileState;

  //     newTileState[newTileState.indexWhere((element) => element['index'] == index)] = targetObject;

  //     tutorialState.setTutorialTileState(newTileState);
  //   }

  //   if (inputTargetType == 'reserve') {

  //     late List<Map<String, dynamic>> reserves = tutorialState.reserveTiles;
  //     late Map<String, dynamic> reserveSpot = reserves.firstWhere((element) => element['id'] == index);
  //     reserveSpot.update('body', (value) => letterSource);
  //     reserves[reserves.indexWhere((element) => element['id'] == reserveSpot['id'])] = reserveSpot;

  //     tutorialState.setReserveTiles(reserves);   
  //   }
  // }


  void getFullTutorialStates(TutorialState tutorialState, List<Map<String,dynamic>> steps) {
    for (int i=0; i < steps.length; i++) {

      int sequenceStep = i;
      final int currentTurn = tutorialState.tutorialGameTurn;

      /// get the first step in the states
      late Map<String,dynamic> currentStep = steps.firstWhere((element) => element['step'] == sequenceStep);

      /// find out if this step requires a tile to be added to the board
      // if (currentStep['autoPlace']) {
      //   /// add the letter to the board
      //   addLetterToTileState(tutorialState, currentStep);

      // }
      if (currentStep['input'] != null) {
          List<String> input = currentStep['input'].split("_");
          String inputTargetType = input[0];
          int index = int.parse(input[1]);
          late String letterSource;
          if (currentStep['inputType'] == 'auto') {
            letterSource = "";
          } else {
            letterSource = tutorialState.tutorialLettersToPlace[tutorialState.tutorialGameTurn];
          }

          if (inputTargetType == "tile") {
            late Map<String, dynamic> targetObject = tutorialTileState(index, tutorialState);
            targetObject.update('letter', (value) => letterSource);
            targetObject.update('active', (value) => false);
            late List<Map<String, dynamic>> newTileState = tutorialState.tutorialTileState;
            newTileState[newTileState.indexWhere((element) => element['index'] == index)] = targetObject;
            tutorialState.setTutorialTileState(newTileState);          
            tutorialState.setTutorialGameTurn(tutorialState.tutorialGameTurn+1);
          } else if (inputTargetType == 'reserve') {
            late List<Map<String, dynamic>> reserves = tutorialState.reserveTiles;
            late Map<String, dynamic> reserveSpot = reserves.firstWhere((element) => element['id'] == index);
            reserveSpot.update('body', (value) => letterSource);
            reserves[reserves.indexWhere((element) => element['id'] == reserveSpot['id'])] = reserveSpot;
            tutorialState.setReserveTiles(reserves);  
          }
      } 

      currentStep['random_letter_state'] = tutorialState.tutorialRandomLetterList;
      currentStep['reserve_state'] = tutorialState.reserveTiles;
      currentStep['tile_state'] = tutorialState.tutorialTileState;
      currentStep['randomLetter1'] = tutorialState.tutorialLettersToPlace[tutorialState.tutorialGameTurn ];
      currentStep['randomLetter2'] = tutorialState.tutorialLettersToPlace[tutorialState.tutorialGameTurn + 1];

      List<Map<String,dynamic>> currentHistory = tutorialState.tutorialStateHistory;
      // tutorialState.setSequenceStep(tutorialState.sequenceStep+1);

      tutorialState.setTutorialStateHistory([...currentHistory, currentStep]);      
    }
  }

  Map<String,dynamic> getCurrentStep(TutorialState tutorialState) {
    int step = tutorialState.sequenceStep;
    List<Map<String,dynamic>> tutorialStateHistory = tutorialState.tutorialStateHistory;
    final Map<String,dynamic> currentStep = tutorialStateHistory.firstWhere(
      (element) => element['step'] == step
    );
    return currentStep;
  }  

  Map<String,dynamic> getPreviousStep(TutorialState tutorialState) {
    int step = tutorialState.sequenceStep;
    List<Map<String,dynamic>> tutorialStateHistory = tutorialState.tutorialStateHistory;
    if (tutorialState.sequenceStep <= 0) {
      step = tutorialState.sequenceStep;
    } else {
      step = tutorialState.sequenceStep-1;
    }
    final Map<String,dynamic> currentStep = tutorialStateHistory.firstWhere(
      (element) => element['step'] == step
    );
    return currentStep;
  }    

}
