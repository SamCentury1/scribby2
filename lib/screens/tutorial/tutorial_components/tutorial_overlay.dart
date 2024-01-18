import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialOverlay extends StatefulWidget {
  const TutorialOverlay({super.key});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  // late int view = 0;
  late ColorPalette palette;
  late TutorialState tutorialState;
  late double opacity  = 0.0;
  @override
  void initState() {
    super.initState();
    palette = Provider.of<ColorPalette>(context, listen: false);
    tutorialState = Provider.of<TutorialState>(context, listen: false);
    getOpacity(tutorialState);
  }

  // void nextItem() {
  //   setState(() {
  //     view = view + 1;
  //   });
  //   tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
  // }

  // Widget selectView(TutorialState tutorialState) {
  //   if (tutorialState.sequenceStep == 0) {
  //     return welcomeText(
  //       palette,
  //       tutorialState,
  //     );
  //   } else if (tutorialState.sequenceStep == 1) {
  //     return skipTutorialButton(palette, tutorialState);
  //   } else if (tutorialState.sequenceStep == 2) {
  //     return navButtonsText(palette, tutorialState);
  //   } else {
  //     return const SizedBox();
  //   }
  // }

  double getOpacity(TutorialState tutorialState) {
    late Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
    double res = 0.0;
    if (!currentStep['isGameStarted']) {
      res = 1.0;
    }
    if (currentStep['isGameEnded']) {
      res = 1.0;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    // late AnimationState animationState =
    //     Provider.of<AnimationState>(context, listen: false);

    // late ColorPalette palette =
    //     Provider.of<ColorPalette>(context, listen: false);

    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {

        // late Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
        

        return AnimatedOpacity(
          // opacity: !tutorialState.isStep1Complete ? 1.0 : 0.0,
          // opacity: tutorialState.sequenceStep > 2 ? 0.0 : 1.0,
          opacity: getOpacity(tutorialState),
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: tutorialState.isStep1Complete,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      // tutorialState.setIsStep1Complete(true);
                    },
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                displayCorrectTextWidget(palette, tutorialState, context)
                // getOpacity(tutorialState) < 1 
                //     ? const SizedBox()
                //     : Container(
                //         // child: selectView(tutorialState),
                //         child: textWidget(palette, tutorialState, context),
                //       )
                // tutorialState.sequenceStep > 2
                //     ? const SizedBox()
                //     : Container(
                //         // child: selectView(tutorialState),
                //         child: textWidget(palette, tutorialState),
                //       )
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget displayCorrectTextWidget(ColorPalette palette, TutorialState tutorialState, BuildContext context) {

  final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);

  Widget res = const SizedBox();
  if (currentStep['isGameStarted']) {
    if (currentStep['isGameEnded']) {
      finalTextWidget(palette, tutorialState,);
    }
  } else {
    res = textWidget(palette, tutorialState, context);
  }
  return res;  

}

Widget textWidget(ColorPalette palette, TutorialState tutorialState,  BuildContext context) {
  // late Map<String, dynamic> sequenceObject = tutorialDetails.firstWhere((elem) => elem['step'] == tutorialState.sequenceStep);
  final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
  late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);

  return Column(
    children: [
      const Expanded(flex: 1, child: SizedBox()),
      Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            DefaultTextStyle(
              style: TextStyle(fontSize: 22, color: palette.textColor2),
              child: Text(currentStep['text']),
            ),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                TextButton(
                    onPressed: () {
                      // TutorialHelpers().saveStateHistory(tutorialState, tutorial)

                      // animationState.setShouldRunTutorialNextStepAnimation(true);
                      tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
                      // animationState.setShouldRunTutorialNextStepAnimation(false);
                    },
                    child: Text(
                      "Okay Got it",
                      style: TextStyle(fontSize: 22, color: palette.textColor1),
                    ))
              ],
            )
          ],
        ),
      ),
      const Expanded(flex: 3, child: SizedBox()),
    ],
  );
}


Widget finalTextWidget(ColorPalette palette, TutorialState tutorialState, ) {
  final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);


  return Column(
    children: [
      const Expanded(flex: 1, child: SizedBox()),
      Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            DefaultTextStyle(
              style: TextStyle(fontSize: 22, color: palette.textColor2,),
              textAlign: TextAlign.center,
              child: Text(currentStep['text']),
            ),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                TextButton(
                  onPressed: () {
                    tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
                  },
                  child: Text(
                    "Start Game",
                    style: TextStyle(fontSize: 22, color: palette.textColor1),
                  )
                ),

                TextButton(
                  onPressed: () {
                    tutorialState.setSequenceStep(0);
                  },
                  child: Text(
                    "Restart Tutorial",
                    style: TextStyle(fontSize: 22, color: palette.textColor1),
                  )
                ),                
              ],
            )
          ],
        ),
      ),
      const Expanded(flex: 3, child: SizedBox()),
    ],
  );  
}
