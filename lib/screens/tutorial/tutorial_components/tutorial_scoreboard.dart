
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
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
    final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) { 
        
        // final Map<String,dynamic> currentStep = tutorialDetails.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
        final Map<String,dynamic> currentStep =  TutorialHelpers().getCurrentStep2(tutorialState);

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all((4.0)*settingsState.sizeFactor),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: widget.animation,
                    builder: (context, child) {
                      return scoreWidget(palette, widget.animation, currentStep, 'points', language, settingsState.sizeFactor);
                    },
                  ),

                  AnimatedBuilder(
                    animation: widget.animation,
                    builder: (context, child) {
                      return newPointsWidget(palette, widget.animation, currentStep, 'new_points', language, settingsState.sizeFactor);
                    },
                  ),
                  const Expanded(flex: 1, child: SizedBox()),

                  AnimatedBuilder(
                    animation: widget.animation,
                    builder: (context, child) {
                      return newWordsWidget(palette, widget.animation, currentStep, 'new_words', settingsState.sizeFactor);
                    },
                  ),

                  AnimatedBuilder(
                    animation: widget.animation,
                    builder: (context, child) {
                      // int current = _highlightComponentAnimation.value;
                      return wordsWidget(palette, widget.animation, currentStep, 'words',settingsState.sizeFactor);
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


Widget scoreWidget(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId, String language, double sizeFactor) {
  return Container(
    // height: 30,
    decoration: BoxDecoration(
      color: palette.screenBackgroundColor,
      border: Border.all(
        color: getColor(palette, animation, currentStep, widgetId),
        width: (3*sizeFactor)
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        TutorialHelpers().getBoxShadow(currentStep, palette, 'points', animation)
      ]
    ),
    child: Padding(
      padding: EdgeInsets.all(8.0*sizeFactor),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: getColor(palette, animation, currentStep, widgetId),
            shadows: TutorialHelpers().getTextShadow(currentStep, palette, widgetId, animation),
            size: 22*sizeFactor
          ),
          // Expanded(flex: 1, child: Center(),),
          const SizedBox(
            width: 15,
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (22*sizeFactor),
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


Widget newPointsWidget(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId, String language, double sizeFactor) {
  return Container(
    child: Padding(
      padding: EdgeInsets.all((8.0*sizeFactor)),
      child:AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: (22*sizeFactor),
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
Widget newWordsWidget(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId, double sizeFactor) {
  return Container(
    child: Padding(
      padding: EdgeInsets.all(8.0*sizeFactor),
      child:AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: (22*sizeFactor),
          color: getColor(palette, animation, currentStep, widgetId),
          shadows: TutorialHelpers().getTextShadow(currentStep, palette, widgetId, animation)
        ),
        child: Text(
          "+${currentStep['newWords']}",
          style: TextStyle(
            fontSize: 22*sizeFactor
          ),
        ),
      ),
    ),
  );
}


Widget wordsWidget(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId, double sizeFactor) {
  return Container(
    // height: 30,
    decoration: BoxDecoration(
      color: palette.screenBackgroundColor,
      // color: const Color.fromRGBO(0, 0, 0, 0),
      border: Border.all(
        color: getColor(palette, animation, currentStep, widgetId),
        width: (3*sizeFactor)
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        TutorialHelpers().getBoxShadow(currentStep, palette, 'words', animation)
      ]      
    ),
    child: Padding(
      padding: EdgeInsets.all(8.0*sizeFactor),
      child: Row(
        children: [
          Icon(
            Icons.library_books,
            color: getColor(palette, animation, currentStep, widgetId),
            shadows: TutorialHelpers().getTextShadow(currentStep, palette, widgetId, animation),
            size: 22*sizeFactor,
          ),
          const SizedBox(
            width: 15,
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (22*sizeFactor),
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
