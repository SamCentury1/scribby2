import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
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
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) { 
        
        // final Map<String,dynamic> currentStep = tutorialDetails.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
        final Map<String,dynamic> currentStep =  TutorialHelpers().getCurrentStep(tutorialState);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: widget.animation,
                    builder: (context, child) {
                      return scoreWidget(palette, widget.animation, currentStep, 'points');
                    },
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
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
  }
  return res;
}

Widget scoreWidget(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId) {
  return Container(
    // height: 30,
    decoration: BoxDecoration(
      color: const Color.fromRGBO(0, 0, 0, 0),
      border: Border.all(
        color: getColor(palette, animation, currentStep, widgetId),
        width: 3
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: getColor(palette, animation, currentStep, widgetId),
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
            ),
            child: const Text("0"),
          )
        ],
      ),
    ),
  );
}

Widget wordsWidget(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId) {
  return Container(
    // height: 30,
    decoration: BoxDecoration(
      color: const Color.fromRGBO(0, 0, 0, 0),
      border: Border.all(
        color: getColor(palette, animation, currentStep, widgetId),
        width: 3
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.library_books,
            color: getColor(palette, animation, currentStep, widgetId),
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
            ),
            child: const Text("0"),
          )
        ],
      ),
    ),
  );
}
