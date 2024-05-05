import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_screen_1.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialHelpers {

  /// This function helps determine whether any of the bonus items (streak,
  /// multi_word, or cross_word) needs to have their animation executed
  void listenForScoreItems(
      TutorialState tutorialState, AnimationState animationState) {

    final Map<String, dynamic> step = tutorialState.tutorialStateHistory2
        .firstWhere((element) => element['step'] == tutorialState.sequenceStep);


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

    late Map<String, dynamic> currentStep = getCurrentStep2(tutorialState);

    if (currentStep['step'] > 0) {

        tutorialState.setSequenceStep(currentStep['step'] - 1);
        animationState.setShouldRunTutorialPreviousStepAnimation(true);
        animationState.setShouldRunTutorialPreviousStepAnimation(false);        

    }

  }

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
      String letter = correspondingLetters[letterId];
      newLetters.add(letter);
    }


    return newLetters;
  }


  void getFullTutorialStates3(TutorialState tutorialState, List<Map<String, dynamic>> steps, String currentLanguage) {
    late List<Map<String, dynamic>> states = [];

    late List<String> letters = translateLetter(currentLanguage,tutorialState.tutorialLettersToAdd);
 

    for (var currentStep in steps) {

      List<Map<String, dynamic>> boardStateCopy = tutorialState.tutorialBoardState
          .map((map) => Map<String, dynamic>.from(map))
          .toList();      


      List<Map<String, dynamic>> reservesStateCopy = tutorialState.reserveTiles
          .map((map) => Map<String,dynamic>.from(map))
          .toList();




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

      currentStep['translated_text'] = translatedText;
      currentStep['random_letter_3'] = letters[currentStep['turn']];
      currentStep['random_letter_2'] = letters[currentStep['turn'] + 1];
      currentStep['random_letter_1'] = letters[currentStep['turn'] + 2];      
      currentStep['tileState'] = boardStateCopy;
      currentStep['reserves'] = reservesStateCopy;

      tutorialState.setTutorialBoardState(boardStateCopy);
      tutorialState.setReserveTiles(reservesStateCopy);

      states.add(currentStep);
      
    }

    tutorialState.setTutorialStateHistory2(states);




  }

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
      color = Color.fromRGBO(
        palette.textColor2.red, 
        palette.textColor2.green,
        palette.textColor2.blue, 
        animation.value);
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
          palette.tileBgColor.red, 
          palette.tileBgColor.green,
          palette.tileBgColor.blue, 
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

  void navigateToTutorial(BuildContext context, String language) {
      late TutorialState tutorialState = context.read<TutorialState>();

      tutorialState.setSequenceStep(0);
      getFullTutorialStates3(tutorialState, tutorialDetails, language);
      
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
