
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialScoreboard extends StatefulWidget {
  final Animation animation;
  const TutorialScoreboard({
    super.key,
    required this.animation
  });

  @override
  State<TutorialScoreboard> createState() => _TutorialScoreboardState();
}

class _TutorialScoreboardState extends State<TutorialScoreboard>
    with TickerProviderStateMixin {
  late ColorPalette palette;

  @override
  void initState() {
    super.initState();
    palette = Provider.of<ColorPalette>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final GamePlayState gamePlayState = context.read<GamePlayState>();
    String language = gamePlayState.currentLanguage;    
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) { 
        
        // final Map<String,dynamic> currentStep = tutorialDetails.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
        final Map<String,dynamic> currentStep =  TutorialHelpers().getCurrentStep2(tutorialState);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: widget.animation,
                    builder: (context, child) {
                      return scoreWidget(palette, widget.animation, currentStep, 'points', language);
                    },
                  ),

                  AnimatedBuilder(
                    animation: widget.animation,
                    builder: (context, child) {
                      return newPointsWidget(palette, widget.animation, currentStep, 'new_points', language);
                    },
                  ),
                  const Expanded(flex: 1, child: SizedBox()),

                  AnimatedBuilder(
                    animation: widget.animation,
                    builder: (context, child) {
                      return newWordsWidget(palette, widget.animation, currentStep, 'new_words');
                    },
                  ),

                  AnimatedBuilder(
                    animation: widget.animation,
                    builder: (context, child) {
                      // int current = _highlightComponentAnimation.value;
                      return wordsWidget(palette, widget.animation, currentStep, 'words');
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

Color getColor(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId) {
  final bool active = currentStep['targets'].contains(widgetId);
  late Color res = palette.tileBgColor;
  if (active) {
    res = Color.fromRGBO(
      palette.tileBgColor.red,
      palette.tileBgColor.green,
      palette.tileBgColor.blue,
      animation.value  
    );
  } else {
    if (widgetId == 'new_points' || widgetId == 'new_words') {
      res = Colors.transparent;
    }
  }
  return res;
}

// BoxShadow getBoxShadow(TutorialState tutorialState, ColorPalette palette, int widgetId, Animation animation) {
//   final Map<String, dynamic> stepDetails = tutorialState.tutorialStateHistory2.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
//   BoxShadow res = const BoxShadow(color: Colors.transparent, blurRadius: 0, spreadRadius: 0);
//   if (stepDetails['targets'].contains(widgetId)) {
//     res = BoxShadow(
//       color: Color.fromRGBO(
//         palette.textColor2.red,
//         palette.textColor2.green,
//         palette.textColor2.blue,
//         (animation.value*0.5)
//       ),
//       blurRadius: 4.0 * (animation.value*0.6),
//       spreadRadius: 4.0 * (animation.value*0.6),
//     );
    
//   }
//   return res;
// }

Widget scoreWidget(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId, String language) {
  return Container(
    // height: 30,
    decoration: BoxDecoration(
      color: palette.screenBackgroundColor,
      border: Border.all(
        color: getColor(palette, animation, currentStep, widgetId),
        width: 3
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        TutorialHelpers().getBoxShadow(currentStep, palette, 'points', animation)
      ]
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: getColor(palette, animation, currentStep, widgetId),
            shadows: TutorialHelpers().getTextShadow(currentStep, palette, widgetId, animation)
          ),
          // Expanded(flex: 1, child: Center(),),
          const SizedBox(
            width: 15,
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: getColor(palette, animation, currentStep, widgetId),
              shadows: TutorialHelpers().getTextShadow(currentStep, palette, widgetId, animation)
            ),
            child: Text(
              translateValue(language, currentStep['points'],'points')
              // currentStep['points'].toString()
            ),
          )
        ],
      ),
    ),
  );
}

String translateValue(String language, String points, String stat) {

  String translatedValue = tutorialPoints[language][stat][points];
  return translatedValue;

}


Widget newPointsWidget(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId, String language) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child:AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          color: getColor(palette, animation, currentStep, widgetId),
          shadows: TutorialHelpers().getTextShadow(currentStep, palette, widgetId, animation)
        ),
        child: Text(
          "+${translateValue(language, currentStep['newPoints'],'newPoints')}"
        ),
      ),
    ),
  );
}
Widget newWordsWidget(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child:AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          color: getColor(palette, animation, currentStep, widgetId),
          shadows: TutorialHelpers().getTextShadow(currentStep, palette, widgetId, animation)
        ),
        child: Text("+${currentStep['newWords']}"),
      ),
    ),
  );
}


Widget wordsWidget(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId) {
  return Container(
    // height: 30,
    decoration: BoxDecoration(
      color: palette.screenBackgroundColor,
      // color: const Color.fromRGBO(0, 0, 0, 0),
      border: Border.all(
        color: getColor(palette, animation, currentStep, widgetId),
        width: 3
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        TutorialHelpers().getBoxShadow(currentStep, palette, 'words', animation)
      ]      
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.library_books,
            color: getColor(palette, animation, currentStep, widgetId),
            shadows: TutorialHelpers().getTextShadow(currentStep, palette, widgetId, animation)
          ),
          const SizedBox(
            width: 15,
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: getColor(palette, animation, currentStep, widgetId),
              shadows: TutorialHelpers().getTextShadow(currentStep, palette, widgetId, animation)
            ),
            child: Text(currentStep['words'].toString()),
          )
        ],
      ),
    ),
  );
}
