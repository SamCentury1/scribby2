import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class PreGameOverlay extends StatefulWidget {
  const PreGameOverlay({super.key});

  @override
  State<PreGameOverlay> createState() => _PreGameOverlayState();
}

class _PreGameOverlayState extends State<PreGameOverlay> {

  double getOpacity(TutorialState tutorialState) {
    late Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
    double res = 0.0;
    if (!currentStep['isGameStarted']) {
      res = 1.0;
    }
    return res;
  }



  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);


    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {
        late Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
        late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
  
        return AnimatedOpacity(
          opacity: getOpacity(tutorialState),
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: currentStep['isGameStarted'],
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      // tutorialState.setIsStep1Complete(true);
                      tutorialState.setSequenceStep(tutorialState.sequenceStep+1);
                    },
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    tutorialState.setSequenceStep(tutorialState.sequenceStep+1);
                  },
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Expanded(flex: 3, child: SizedBox()),
                        Padding(
                          padding: EdgeInsets.all(16.0*settingsState.sizeFactor),
                          child: DefaultTextStyle(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: palette.focusedTutorialTile,
                              fontSize: 28*settingsState.sizeFactor
                            ), 
                            child: Text(
                              Helpers().translateText(
                                gamePlayState.currentLanguage, 
                                "Welcome to Scribby! This interactive tutorial will demonstrate how this game works and how to do well!"
                              ),
                            )
                          ),
                        ),
                        Expanded(flex: 1, child: SizedBox()),
                        Padding(
                          padding: EdgeInsets.all(16.0*settingsState.sizeFactor),
                          child: DefaultTextStyle(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: palette.focusedTutorialTile,
                              fontSize: 25*settingsState.sizeFactor,
                              fontStyle: FontStyle.italic
                            ), 
                            child: Text(
                              Helpers().translateText(
                                gamePlayState.currentLanguage, 
                                "Tap anywhere on the screen to start"
                              ),
                            )
                          ),
                        ),                      
                        Expanded(flex: 3, child: SizedBox()),
                  
                      ],
                    ),
                  ),
                )


              ],
            ),
          ),
        );
      },
    );
  }
}  