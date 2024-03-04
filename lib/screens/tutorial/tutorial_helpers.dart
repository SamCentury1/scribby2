import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_screen_1.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialHelpers {
  // Map<String, dynamic> tutorialTileState(int index, TutorialState tutorialState) {
  //   late Map<String, dynamic> tileState = tutorialState.tutorialTileState.firstWhere((element) => element['index'] == index);
  //   return tileState;
  // }

  // void updateTutorialTileState(TutorialState tutorialState, int targetIndex, AnimationState animationState,  List<Map<String,dynamic>> steps) {
  //   /// Step one is to update the random letters list array and add to it, the next
  //   /// chosen letter from the "tutorialettersToAdd" list
  //   tutorialState.setTutorialRandomLetterList([
  //     ...tutorialState.tutorialRandomLetterList,
  //     tutorialState.tutorialLettersToAdd[tutorialState.tutorialTurn]
  //   ]);

  //   /// Get the letter to 3 positions from the end of the random letters list
  //   /// (the 2 final positions are for the random letters to display)
  //   final String letterSource = tutorialState.tutorialRandomLetterList[tutorialState.tutorialRandomLetterList.length - 3];

  //   /// retrieve the object belonging to the selected index
  //   late Map<String, dynamic> targetObject = tutorialTileState(targetIndex, tutorialState);

  //   /// update the object to reflect the next in line letter to add
  //   targetObject.update('letter', (value) => letterSource);
  //   targetObject.update('active', (value) => false);

  //   /// create a copy of the tile state and update it with the newly updated object
  //   late List<Map<String, dynamic>> newTileState = tutorialState.tutorialTileState;

  //   newTileState[newTileState.indexWhere((element) => element['index'] == targetIndex)] = targetObject;

  //   /// increment the turn by one
  //   tutorialState.setTutorialTurn(tutorialState.tutorialTurn + 1);

  //   /// display the new board
  //   tutorialState.setTutorialTileState(newTileState);

  //   /// run the animation for the new letter
  //   animationState.setShouldRunAnimation(true);
  //   animationState.setShouldRunAnimation(false);

  //   /// increment the sequence step of the tutorial by one
  //   tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);

  //   /// listens for whether to animate any of the scoreboard items
  //   listenForScoreItems(tutorialState, steps, animationState);
  // }

  // void placeIntoReserves(BuildContext context, TutorialState tutorialState, Map<String, dynamic> reserveSpot, List<Map<String,dynamic>> steps) {
  //   late AnimationState animationState = context.read<AnimationState>();

  //   if (reserveSpot["body"] == "") {
  //     animationState.setShouldRunAnimation(true);

  //     tutorialState.setTutorialRandomLetterList([
  //       ...tutorialState.tutorialRandomLetterList,
  //       tutorialState.tutorialLettersToAdd[tutorialState.tutorialTurn]
  //     ]);

  //     final String letterSource = tutorialState.tutorialRandomLetterList[tutorialState.tutorialRandomLetterList.length - 3];

  //     reserveSpot.update('body', (value) => letterSource);

  //     late List<Map<String, dynamic>> newReserveState = tutorialState.reserveTiles;

  //     newReserveState[newReserveState.indexWhere((element) => element['id'] == reserveSpot['id'])] = reserveSpot;

  //     /// increment the turn by one
  //     tutorialState.setTutorialTurn(tutorialState.tutorialTurn + 1);

  //     /// display the new board
  //     tutorialState.setReserveTiles(newReserveState);

  //     /// run the animation for the new letter
  //     animationState.setShouldRunAnimation(true);
  //     animationState.setShouldRunAnimation(false);

  //     /// increment the sequence step of the tutorial by one
  //     tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);

  //     /// listens for whether to animate any of the scoreboard items
  //     listenForScoreItems(tutorialState, steps, animationState);

  //     // tutorialState.countDownController.restart(
  //     //     duration:
  //     //         GameLogic().getCountdownDuration(tutorialState.currentLevel));

  //     animationState.setShouldRunAnimation(false);
  //   }
  // }

  // void dropTile(BuildContext context, int targetIndex, TutorialState tutorialState, List<Map<String,dynamic>> steps) async {
  //   late AnimationState animationState = context.read<AnimationState>();
  //   // late AudioController audioController = context.read<AudioController>();

  //   final String letterSource = tutorialState.draggedReserveTile["body"];

  //   late Map<String, dynamic> targetObject = tutorialTileState(targetIndex, tutorialState);

  //   /// update the object to reflect the next in line letter to add
  //   targetObject.update('letter', (value) => letterSource);
  //   targetObject.update('active', (value) => false);

  //   late Map<String, dynamic> draggedTile = tutorialState.draggedReserveTile;
  //   draggedTile.update("body", (value) =>"");

  //   late List<Map<String, dynamic>> newReserveState = tutorialState.reserveTiles;
  //   newReserveState[newReserveState.indexWhere((element) => element['id'] == draggedTile['id'])] = draggedTile;

  //   late List<Map<String, dynamic>> newTileState = tutorialState.tutorialTileState;
  //   newTileState[newTileState.indexWhere((element) => element['index'] == targetIndex)] = targetObject;

  //   /// increment the turn by one
  //   tutorialState.setTutorialTurn(tutorialState.tutorialTurn + 1);

  //   /// display the new board
  //   tutorialState.setTutorialTileState(newTileState);

  //   /// display the new reserve tile state
  //   tutorialState.setReserveTiles(newReserveState);

  //   // /// run the animation for the new letter
  //   // animationState.setShouldRunAnimation(true);

  //   /// increment the sequence step of the tutorial by one
  //   tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);

  //   /// listens for whether to animate any of the scoreboard items
  //   listenForScoreItems(tutorialState, steps, animationState);
  // }

  /// This function helps determine whether any of the bonus items (streak,
  /// multi_word, or cross_word) needs to have their animation executed
  void listenForScoreItems(
      TutorialState tutorialState, AnimationState animationState) {
    // final Map<String,dynamic> step = steps[tutorialState.sequenceStep];
    final Map<String, dynamic> step = tutorialState.tutorialStateHistory2
        .firstWhere((element) => element['step'] == tutorialState.sequenceStep);
    // final Map<String,dynamic> previousStep = steps[tutorialState.sequenceStep-1];

    /// STREAK

    if (step['streak'] == 2) {
      animationState.setShouldRunTutorialStreakEnterAnimation(true);
      animationState.setShouldRunTutorialStreakEnterAnimation(false);
    }
    if (step['streak'] == 0) {
      animationState.setShouldRunTutorialStreakExitAnimation(true);
      animationState.setShouldRunTutorialStreakExitAnimation(false);
    }

    /// NEW WORDS
    if (step['newWords'] >= 1) {
      animationState.setShouldRunTutorialMultiWordEnterAnimation(true);
      animationState.setShouldRunTutorialMultiWordEnterAnimation(false);
    }
    if (step['newWords'] == 0) {
      animationState.setShouldRunTutorialMultiWordExitAnimation(true);
      animationState.setShouldRunTutorialMultiWordExitAnimation(false);
    }

    /// CROSSWORD
    if (step['crossword'] >= 1) {
      animationState.setShouldRunTutorialCrosswordEnterAnimation(true);
      animationState.setShouldRunTutorialCrosswordEnterAnimation(false);
    }
    if (step['crossword'] == 0) {
      animationState.setShouldRunTutorialCrosswordExitAnimation(true);
      animationState.setShouldRunTutorialCrosswordExitAnimation(false);
    }
  }

  void executePreviousStep( TutorialState tutorialState, AnimationState animationState) {
    // late AnimationState animationState =
    //     Provider.of<AnimationState>(context, listen: false);
    late Map<String, dynamic> currentStep = getCurrentStep2(tutorialState);

    if (currentStep['step'] > 0) {
      // if (currentStep['step'] == 36) {
      //   tutorialState.setSequenceStep(currentStep['step']-14);
      //   animationState.setShouldRunTutorialPreviousStepAnimation(true);
      //   animationState.setShouldRunTutorialPreviousStepAnimation(false);        
      // } else {
        tutorialState.setSequenceStep(currentStep['step'] - 1);
        animationState.setShouldRunTutorialPreviousStepAnimation(true);
        animationState.setShouldRunTutorialPreviousStepAnimation(false);        
      // }
    }

    print(tutorialState.sequenceStep);
  }

  // void saveStateHistory(TutorialState tutorialState, List<Map<String,dynamic>> steps) {
  //   final Map<String,dynamic> currentStep = steps.firstWhere((element) => element['step'] == tutorialState.sequenceStep);

  //   currentStep['random_letter_state'] = tutorialState.tutorialRandomLetterList;
  //   currentStep['reserve_state'] = tutorialState.reserveTiles;
  //   currentStep['tile_state'] = tutorialState.tutorialTileState;
  //   currentStep['randomLetter1'] = tutorialState.tutorialLettersToPlace[tutorialState.sequenceStep ];
  //   currentStep['randomLetter2'] = tutorialState.tutorialLettersToPlace[tutorialState.sequenceStep + 1];

  //   // List<Map<String,dynamic>> currentHistory = tutorialState.tutorialStateHistory;
  //   // currentHistory.a

  //   // tutorialState.setTutorialStateHistory([...currentHistory, currentStep]);
  // }

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

  void reactToTileTap(TutorialState tutorialState, AnimationState animationState, Map<String, dynamic> currentStep) {
    final Map<String, dynamic> nextStep = tutorialState.tutorialStateHistory2
        .firstWhere( (element) => element['step'] == tutorialState.sequenceStep + 1);

    animationState.setShouldRunTutorialNextStepAnimation(true);
    tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
    listenForScoreItems(tutorialState, animationState);
    animationState.setShouldRunTutorialNextStepAnimation(false);

    if (nextStep['isTapped']) {
      animationState.setShouldRunAnimation(true);
      animationState.setShouldRunAnimation(false);
    }
  }

  List<String> translateLetter(String language, List<String> letterIds) {
    final Map<String,dynamic> correspondingLetters = tutorialLetters[language];
    late List<String> newLetters = [];
    for (String letterId in letterIds) {
      print(letterId);
      String letter = correspondingLetters[letterId];
      print("should be converted to $letter");
      newLetters.add(letter);
    }


    return newLetters;
  }


  // List<Map<String, dynamic>> getCopyOfTutorialStates(TutorialState tutorialState, List<Map<String, dynamic>> steps) {

  //   late List<Map<String, dynamic>> boardTemplate = [];
  //   for (Map<String,dynamic> item in tutorialBoard_1) {
  //     late Map<String,dynamic> newMap = {}; 
  //     item.forEach((key, value) {
  //       newMap[key] = value;
  //     });     
  //     boardTemplate.add(newMap);
  //   }
  //   late List<Map<String, dynamic>> states = [];

  //   for (Map<String,dynamic> item in steps) {
  //     late Map<String,dynamic> newMap = {}; 
  //     item.forEach((key, value) {
  //       newMap[key] = value;
  //     });      
  //     newMap['tileState'] = boardTemplate;
  //     states.add(newMap);
  //   }
  //   return states;
  // }

  void getFullTutorialStates3(TutorialState tutorialState, List<Map<String, dynamic>> steps, String currentLanguage) {
    late List<Map<String, dynamic>> states = [];

    late List<String> letters = translateLetter(currentLanguage,tutorialState.tutorialLettersToAdd);

    // late List<Map<String, dynamic>> newReserves = tutorialState.reserveTiles;    

    for (var currentStep in steps) {

      List<Map<String, dynamic>> boardStateCopy = tutorialState.tutorialBoardState
          .map((map) => Map<String, dynamic>.from(map))
          .toList();      


      List<Map<String, dynamic>> reservesStateCopy = tutorialState.reserveTiles
          .map((map) => Map<String,dynamic>.from(map))
          .toList();

      // if (currentStep['isTapped'] || currentStep['autoPlace']) {
      //   tutorialState.setTutorialMove(tutorialState.tutorialMove + 1);
      // }



      for (var letterToUpdate in currentStep['board']) {

        if (letterToUpdate['tile'] != null) {
          late Map<String,dynamic> targetLetterObject =  reservesStateCopy.firstWhere((element) => element['id'] == letterToUpdate['index']);
          String letterString = tutorialLetters[currentLanguage][letterToUpdate['letter']];

          targetLetterObject.update('body', (value) => letterString);

        } else {
          late Map<String,dynamic> targetLetterObject =  boardStateCopy.firstWhere((element) => element['index'] == letterToUpdate['index']);
          String letterString = tutorialLetters[currentLanguage][letterToUpdate['letter']];

          targetLetterObject.update('letter', (value) => letterString);

          if (letterToUpdate['active'] != null) {
            targetLetterObject.update('active', (value) => letterToUpdate['active']);
          }

          if (letterToUpdate['alive'] != null) {
            targetLetterObject.update('alive', (value) => letterToUpdate['alive']);
          }
        }


        // boardAtStep[boardAtStep.indexWhere((element) => element['index'] == letterToUpdate['index'])] == targetLetterObject;
      }
    
      String translatedText = translateTutorialStep(currentLanguage, currentStep['text']);

      currentStep.update('text', (value) => translatedText);
      // currentStep['random_letter_3'] = letters[tutorialState.tutorialMove];
      // currentStep['random_letter_2'] = letters[tutorialState.tutorialMove + 1];
      // currentStep['random_letter_1'] = letters[tutorialState.tutorialMove + 2];
      currentStep['random_letter_3'] = letters[currentStep['turn']];
      currentStep['random_letter_2'] = letters[currentStep['turn'] + 1];
      currentStep['random_letter_1'] = letters[currentStep['turn'] + 2];      
      currentStep['tileState'] = boardStateCopy;
      currentStep['reserves'] = reservesStateCopy;

      // print(currentStep['tileState']);
      // log(currentStep.toString());
      tutorialState.setTutorialBoardState(boardStateCopy);
      tutorialState.setReserveTiles(reservesStateCopy);

      states.add(currentStep);
      
    }

    tutorialState.setTutorialStateHistory2(states);

    for (Map<String,dynamic> item in states) {
      log("===========================================================${item.toString()}================================================================");
    }    



  }



  // void getFullTutorialStates2(TutorialState tutorialState, List<Map<String, dynamic>> steps, String currentLanguage) {
  //   late List<Map<String, dynamic>> states = [];
  //   late List<String> letters = translateLetter(currentLanguage,tutorialState.tutorialLettersToAdd);

  //   late List<Map<String, dynamic>> newBoard = tutorialBoard_1;
  //   late List<Map<String, dynamic>> newReserves = tutorialState.reserveTiles;

  //   // late int move = 0;

  //   for (int i = 0; i < steps.length; i++) {
  //     late Map<String, dynamic> currentStep = steps[i];
  //     late List<Map<String, dynamic>> boardAtStep = [];
  //     late List<Map<String, dynamic>> reservesAtStep = [];

  //     if (currentStep['isTapped'] || currentStep['autoPlace']) {
  //       // move = move + 1;
  //       tutorialState.setTutorialMove(tutorialState.tutorialMove + 1);

  //       late String targetType = currentStep['input'].split("_")[0];
  //       late int targetIndex = int.parse(currentStep['input'].split("_")[1]);
  //       late String letterSource = letters[tutorialState.tutorialMove];

  //       if (targetType == 'tile') {
  //         /// create a new board where the state reflects that tile getting populated with a letter;

  //         late Map<String, dynamic> tileState =
  //             newBoard.firstWhere((element) => element['index'] == targetIndex);

  //         for (int j = 0; j < newBoard.length; j++) {
  //           final bool alive =
  //               currentStep['autoPlace'] ? false : newBoard[j]['alive'];
  //           final bool active =
  //               currentStep['tilesInWord'].contains(newBoard[j]['index']);

  //           if (newBoard[j]['index'] == targetIndex) {
  //             boardAtStep.add({
  //               "index": newBoard[j]['index'],
  //               "tileId": newBoard[j]['tileId'],
  //               "row": newBoard[j]['row'],
  //               "column": newBoard[j]['column'],
  //               "letter": letterSource,
  //               "active": active,
  //               "alive": alive, // newBoard[j]['alive'],
  //             });
  //           } else {
  //             boardAtStep.add({
  //               "index": newBoard[j]['index'],
  //               "tileId": newBoard[j]['tileId'],
  //               "row": newBoard[j]['row'],
  //               "column": newBoard[j]['column'],
  //               "letter": newBoard[j]['letter'],
  //               "active": active,
  //               "alive": newBoard[j]['alive'], // newBoard[j]['alive'],
  //             });
  //           }
  //         }

  //         newBoard = boardAtStep;
  //         reservesAtStep = steps[i - 1]['reserves'];

  //         // tileState.update('letter', (value) => letterSource);
  //         // tileState.update('active', (value) => false);
  //         // boardAtStep[boardAtStep.indexWhere((element) => element['index'] == targetIndex)] = tileState;
  //       } else if (targetType == 'reserve') {
  //         late Map<String, dynamic> reserveState =
  //             newReserves.firstWhere((element) => element['id'] == targetIndex);

  //         // reserveState.update('body', (value) => letterSource);
  //         // newReserves[newReserves.indexWhere((element) => element['id'] == targetIndex)] = reserveState;

  //         for (int j = 0; j < newReserves.length; j++) {
  //           if (newReserves[j]['id'] == targetIndex) {
  //             // reserveState.update('body', (value) => letterSource);
  //             reservesAtStep
  //                 .add({"id": newReserves[j]['id'], "body": letterSource});
  //           } else {
  //             reservesAtStep.add(newReserves[j]);
  //           }
  //         }

  //         newReserves = reservesAtStep;
  //         boardAtStep = steps[i - 1]['tileState'];

  //         // print(  "turn $i === reserves:  $newReserves");
  //       }
  //     } else {
  //       if (currentStep['tilesToRemove'].isNotEmpty) {
  //         for (int j = 0; j < newBoard.length; j++) {
  //           if (currentStep['tilesToRemove'].contains(newBoard[j]['index'])) {
  //             boardAtStep.add({
  //               "index": newBoard[j]['index'],
  //               "tileId": newBoard[j]['tileId'],
  //               "row": newBoard[j]['row'],
  //               "column": newBoard[j]['column'],
  //               "letter": "",
  //               "active": false,
  //               "alive": newBoard[j]['alive'],
  //             });
  //           } else {
  //             boardAtStep.add(newBoard[j]);
  //           }
  //         }
  //         newBoard = boardAtStep;
  //         reservesAtStep = steps[i - 1]['reserves'];
  //       }

  //       if (currentStep['isDrag']) {

  //         // late String dragTileType = currentStep['dragSource'].split("_")[0];
  //         late int dragTileIndex =
  //             int.parse(currentStep['dragSource'].split("_")[1]);
  //         late Map<String, dynamic> reserveObject = steps[i - 1]['reserves']
  //             .firstWhere((element) => element['id'] == dragTileIndex);
  //         late String letterSource = reserveObject['body'];

  //         late String targetType = currentStep['input'].split("_")[0];
  //         late int targetIndex = int.parse(currentStep['input'].split("_")[1]);
  //         // late String letterSource = letters[tutorialState.tutorialMove];

  //         for (int j = 0; j < newBoard.length; j++) {
  //           // final bool alive =  currentStep['autoPlace'] ? false : newBoard[j]['alive'];
  //           final bool active =
  //               currentStep['tilesInWord'].contains(newBoard[j]['index']);
  //           if (newBoard[j]['index'] == targetIndex) {
  //             // tileState.update('letter', (value) => letterSource);
  //             // tileState.update('active', (value) => false);
  //             boardAtStep.add({
  //               "index": newBoard[j]['index'],
  //               "tileId": newBoard[j]['tileId'],
  //               "row": newBoard[j]['row'],
  //               "column": newBoard[j]['column'],
  //               "letter": letterSource,
  //               "active": active,
  //               "alive": newBoard[j]['alive'],
  //             });
  //           } else {
  //             boardAtStep.add({
  //               "index": newBoard[j]['index'],
  //               "tileId": newBoard[j]['tileId'],
  //               "row": newBoard[j]['row'],
  //               "column": newBoard[j]['column'],
  //               "letter": newBoard[j]['letter'],
  //               "active": active,
  //               "alive": newBoard[j]['alive'],
  //             });
  //             // boardAtStep.add(newBoard[j]);
  //           }
  //         }

  //         for (int j = 0; j < newReserves.length; j++) {
  //           if (newReserves[j]['id'] == dragTileIndex) {
  //             reservesAtStep.add({
  //               "id": dragTileIndex,
  //               "body": "",
  //             });
  //           } else {
  //             reservesAtStep.add(newReserves[j]);
  //           }
  //         }

  //         newBoard = boardAtStep;
  //         newReserves = reservesAtStep;
  //         // reservesAtStep = steps[i-1]['reserves'];
  //       } else {
  //         if (tutorialState.sequenceStep > 2) {
  //           boardAtStep = steps[i - 1]['tileState'];
  //           reservesAtStep = steps[i - 1]['reserves'];
  //         }
  //       }
  //     }

  //     String translatedText = translateTutorialStep(currentLanguage, currentStep['text']);

  //     // currentStep['translatedText'] = translatedText; 
  //     currentStep.update('text', (value) => translatedText);
  //     currentStep['random_letter_3'] = letters[tutorialState.tutorialMove];
  //     currentStep['random_letter_2'] = letters[tutorialState.tutorialMove + 1];
  //     currentStep['random_letter_1'] = letters[tutorialState.tutorialMove + 2];
  //     currentStep['tileState'] = newBoard;
  //     currentStep['reserves'] = newReserves;

  //     // print(currentStep['tileState']);
  //     // log(currentStep.toString());

  //     states.add(currentStep);
  //   }
  //   // log(states.toString());
  //   // log(states.toString());
  //   tutorialState.setTutorialStateHistory2(states);
  // }

  // void getFullTutorialStates(TutorialState tutorialState, List<Map<String,dynamic>> steps) {
  //   for (int i=0; i < steps.length; i++) {

  //     int sequenceStep = i;
  //     final int currentTurn = tutorialState.tutorialGameTurn;

  //     /// get the first step in the states
  //     late Map<String,dynamic> currentStep = steps.firstWhere((element) => element['step'] == sequenceStep);

  //     /// find out if this step requires a tile to be added to the board
  //     // if (currentStep['autoPlace']) {
  //     //   /// add the letter to the board
  //     //   addLetterToTileState(tutorialState, currentStep);

  //     // }
  //     if (currentStep['input'] != null) {
  //         List<String> input = currentStep['input'].split("_");
  //         String inputTargetType = input[0];
  //         int index = int.parse(input[1]);
  //         late String letterSource;
  //         if (currentStep['inputType'] == 'auto') {
  //           letterSource = "";
  //         } else {
  //           letterSource = tutorialState.tutorialLettersToPlace[tutorialState.tutorialGameTurn];
  //         }

  //         if (inputTargetType == "tile") {
  //           late Map<String, dynamic> targetObject = tutorialTileState(index, tutorialState);
  //           targetObject.update('letter', (value) => letterSource);
  //           targetObject.update('active', (value) => false);
  //           late List<Map<String, dynamic>> newTileState = tutorialState.tutorialTileState;
  //           newTileState[newTileState.indexWhere((element) => element['index'] == index)] = targetObject;
  //           tutorialState.setTutorialTileState(newTileState);
  //           tutorialState.setTutorialGameTurn(tutorialState.tutorialGameTurn+1);
  //         } else if (inputTargetType == 'reserve') {
  //           late List<Map<String, dynamic>> reserves = tutorialState.reserveTiles;
  //           late Map<String, dynamic> reserveSpot = reserves.firstWhere((element) => element['id'] == index);
  //           reserveSpot.update('body', (value) => letterSource);
  //           reserves[reserves.indexWhere((element) => element['id'] == reserveSpot['id'])] = reserveSpot;
  //           tutorialState.setReserveTiles(reserves);
  //         }
  //     }

  //     currentStep['random_letter_state'] = tutorialState.tutorialRandomLetterList;
  //     currentStep['reserve_state'] = tutorialState.reserveTiles;
  //     currentStep['tile_state'] = tutorialState.tutorialTileState;
  //     currentStep['randomLetter1'] = tutorialState.tutorialLettersToPlace[tutorialState.tutorialGameTurn ];
  //     currentStep['randomLetter2'] = tutorialState.tutorialLettersToPlace[tutorialState.tutorialGameTurn + 1];

  //     List<Map<String,dynamic>> currentHistory = tutorialState.tutorialStateHistory;
  //     // tutorialState.setSequenceStep(tutorialState.sequenceStep+1);

  //     tutorialState.setTutorialStateHistory([...currentHistory, currentStep]);
  //   }
  // }

  // Map<String,dynamic> getCurrentStep(TutorialState tutorialState) {
  //   int step = tutorialState.sequenceStep;
  //   List<Map<String,dynamic>> tutorialStateHistory = tutorialState.tutorialStateHistory;
  //   final Map<String,dynamic> currentStep = tutorialStateHistory.firstWhere(
  //     (element) => element['step'] == step
  //   );
  //   return currentStep;
  // }

  // Map<String,dynamic> getPreviousStep(TutorialState tutorialState) {
  //   int step = tutorialState.sequenceStep;
  //   List<Map<String,dynamic>> tutorialStateHistory = tutorialState.tutorialStateHistory;
  //   if (tutorialState.sequenceStep <= 0) {
  //     step = tutorialState.sequenceStep;
  //   } else {
  //     step = tutorialState.sequenceStep-1;
  //   }
  //   final Map<String,dynamic> currentStep = tutorialStateHistory.firstWhere(
  //     (element) => element['step'] == step
  //   );
  //   return currentStep;
  // }

  Map<String, dynamic> getCurrentStep2(TutorialState tutorialState) {
    int step = tutorialState.sequenceStep;
    List<Map<String, dynamic>> tutorialStateHistory2 =
        tutorialState.tutorialStateHistory2;
    final Map<String, dynamic> currentStep =
        tutorialStateHistory2.firstWhere((element) => element['step'] == step);
    return currentStep;
  }

  Map<String, dynamic> getPreviousStep2(TutorialState tutorialState) {
    int step = tutorialState.sequenceStep;
    List<Map<String, dynamic>> tutorialStateHistory2 = tutorialState.tutorialStateHistory2;
    if (tutorialState.sequenceStep <= 0) {
      step = tutorialState.sequenceStep;
    } else {
      step = tutorialState.sequenceStep - 1;
    }
    final Map<String, dynamic> currentStep =
        tutorialStateHistory2.firstWhere((element) => element['step'] == step);
    return currentStep;
  }

  Map<String, dynamic> getNextStep2(TutorialState tutorialState) {
    int step = tutorialState.sequenceStep;
    List<Map<String, dynamic>> tutorialStateHistory2 = tutorialState.tutorialStateHistory2;

    step = tutorialState.sequenceStep >= (tutorialState.tutorialStateHistory2.length - 1)
      ? tutorialState.sequenceStep
      : tutorialState.sequenceStep + 1;

    final Map<String, dynamic> stepDetails = tutorialStateHistory2.firstWhere((element) => element['step'] == step);
    return stepDetails;
  }  

  Color getGlowAnimationColor(Map<String, dynamic> currentStep,
      ColorPalette palette, dynamic widgetId, Animation animation) {
    late Color color = const Color.fromRGBO(0, 0, 0, 0);
    if (currentStep["callbackTarget"] == widgetId) {
      color = Color.fromRGBO(palette.textColor2.red, palette.textColor2.green,
          palette.textColor2.blue, animation.value);
    } else {
      color = palette.textColor2;
    }
    return color;
  }

  BoxShadow getBoxShadow(Map<String, dynamic> currentStep, ColorPalette palette,
      dynamic widgetId, Animation animation) {
    // final Map<String, dynamic> stepDetails = tutorialState.tutorialStateHistory2.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
    BoxShadow res = const BoxShadow(
        color: Colors.transparent, blurRadius: 0, spreadRadius: 0);
    if (currentStep['targets'].contains(widgetId)) {
      res = BoxShadow(
        color: Color.fromRGBO(
          palette.focusedTutorialTile.red, 
          palette.focusedTutorialTile.green,
          palette.focusedTutorialTile.blue, 
          (animation.value * 0.5)
        ),
        blurRadius: 10.0 * (animation.value * 0.5),
        spreadRadius: 10.0 * (animation.value * 0.5),
      );
    }
    return res;
  }

  List<Shadow> getTextShadow(Map<String, dynamic> currentStep,
      ColorPalette palette, dynamic widgetId, Animation animation) {
    late List<Shadow> res = const [
      Shadow(offset: Offset.zero, blurRadius: 0, color: Colors.transparent)
    ];

    if (currentStep['targets'].contains(widgetId)) {
      Color color = Color.fromRGBO(
          palette.textColor2.red,
          palette.textColor2.green,
          palette.textColor2.blue,
          animation.value * 1);
      res = <Shadow>[
        Shadow(offset: const Offset(0.0, 0.0), blurRadius: 20, color: color),
      ];
    }
    return res;
  }

  void navigateToTutorial(BuildContext context) {
    late TutorialState tutorialState = Provider.of<TutorialState>(context, listen: false);
    late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);


      // TutorialHelpers().saveStateHistory(tutorialState, tutorialDetails);
      getFullTutorialStates3(tutorialState, tutorialDetails, gamePlayState.currentLanguage);
      // getFullTutorialStates2(tutorialState, tutorialDetails, gamePlayState.currentLanguage);
      // TutorialHelpers().getFullTutorialStates(tutorialState, tutorialDetails);
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const TutorialScreen1()
        )
      );
      

  }


  String translateDemoWord(String language, String originalText) {
    return tutorialWords[language][originalText];
  }

  String translateTutorialStep(String language, String originalString,) {
    String res = "";

    
    String translatedBody = Helpers().translateText(language, originalString);
    late Map<String,dynamic> dynamicLetters = tutorialLetters[language];
    dynamicLetters.forEach((key, value) {
      translatedBody = translatedBody.replaceAll(key, value);
    });

    late Map<String,dynamic> dynamicWords = tutorialWords[language]; 
    dynamicWords.forEach((key, value) {
      translatedBody = translatedBody.replaceAll(key, value);
    });    

    late Map<String,dynamic> dynamicPoints = tutorialPoints[language]['points'];
    dynamicPoints.forEach((key, value) {
      translatedBody = translatedBody.replaceAll(key, value);
    }); 

    late Map<String,dynamic> dynamicNewPoints = tutorialPoints[language]['newPoints'];
    dynamicNewPoints.forEach((key, value) {
      translatedBody = translatedBody.replaceAll(key, value);
    });        

    return translatedBody;
  }  

}
