import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TutorialEndedOverlay extends StatefulWidget {
  const TutorialEndedOverlay({super.key});

  @override
  State<TutorialEndedOverlay> createState() => _TutorialEndedOverlayState();
}

class _TutorialEndedOverlayState extends State<TutorialEndedOverlay> {
  @override
  Widget build(BuildContext context) {

    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {

        final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);

        return AnimatedOpacity(
          opacity: currentStep['isGameEnded']
              ? 1.0
              : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !currentStep['isGameEnded'],
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                    },
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const Expanded(flex: 3, child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: DefaultTextStyle(
                            style: TextStyle(fontSize: 22, color: palette.textColor2,),
                            textAlign: TextAlign.center,
                            child: Text("Congratulations on completing the demo! How would you like to proceed?",),
                          ),                          
                        ),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                      ElevatedButton(
                        onPressed: () {}, 
                        child: Text("Start Game")
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                      ElevatedButton(
                        onPressed: () {}, 
                        child: Text("Restart Tutorial")
                      ),
                      const Expanded(flex: 3, child: SizedBox()),
                  
                    ],
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