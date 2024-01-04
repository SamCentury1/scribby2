import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
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
  @override
  void initState() {
    super.initState();
    palette = Provider.of<ColorPalette>(context, listen: false);
    tutorialState = Provider.of<TutorialState>(context, listen: false);
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

  @override
  Widget build(BuildContext context) {
    // late AnimationState animationState =
    //     Provider.of<AnimationState>(context, listen: false);

    // late ColorPalette palette =
    //     Provider.of<ColorPalette>(context, listen: false);

    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {
        return AnimatedOpacity(
          // opacity: !tutorialState.isStep1Complete ? 1.0 : 0.0,
          opacity: tutorialState.sequenceStep > 2 ? 0.0 : 1.0,
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
                tutorialState.sequenceStep > 2
                    ? const SizedBox()
                    : Container(
                        // child: selectView(tutorialState),
                        child: textWidget(palette, tutorialState),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget welcomeText(ColorPalette palette, TutorialState tutorialState) {
//   return Column(
//     children: [
//       const Expanded(flex: 1, child: SizedBox()),
//       Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Column(
//           children: [
//             DefaultTextStyle(
//               style: TextStyle(fontSize: 22, color: palette.textColor2),
//               child: const Text(
//                 "Welcome to Scribby! This tutorial will show you how to play the game",
//               ),
//             ),
//           ],
//         ),
//       ),
//       // Padding(
//       //   padding: const EdgeInsets.all(18.0),
//       //   child: Column(
//       //     children: [
//       //       DefaultTextStyle(
//       //         style: TextStyle(fontSize: 22, color: palette.textColor2),
//       //         child: const Text(
//       //           "This tutorial will show you how to play the game",
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//       Row(
//         children: [
//           const Expanded(child: SizedBox()),
//           TextButton(
//               onPressed: () {
//                 tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
//               },
//               child: Text(
//                 "Okay Got it",
//                 style: TextStyle(fontSize: 22, color: palette.textColor1),
//               ))
//         ],
//       ),
//       const Expanded(flex: 1, child: SizedBox()),
//     ],
//   );
// }

// Widget skipTutorialButton(ColorPalette palette, TutorialState tutorialState) {
//   return Column(
//     children: [
//       const Expanded(flex: 1, child: SizedBox()),
//       Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Column(
//           children: [
//             DefaultTextStyle(
//               style: TextStyle(fontSize: 22, color: palette.textColor2),
//               child: const Text(
//                 "To skip the tutorial at any step, click on 'Skip Tutorial' at the top",
//               ),
//             ),
//           ],
//         ),
//       ),
//       Row(
//         children: [
//           const Expanded(child: SizedBox()),
//           TextButton(
//               onPressed: () {
//                 tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
//               },
//               child: Text(
//                 "Okay Got it",
//                 style: TextStyle(fontSize: 22, color: palette.textColor1),
//               ))
//         ],
//       ),
//       const Expanded(flex: 3, child: SizedBox()),
//     ],
//   );
// }

// Widget navButtonsText(ColorPalette palette, TutorialState tutorialState) {
//   return Column(
//     children: [
//       const Expanded(flex: 1, child: SizedBox()),
//       Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Column(
//           children: [
//             DefaultTextStyle(
//               style: TextStyle(fontSize: 22, color: palette.textColor2),
//               child: const Text(
//                 "Use the controls to go back or forward throughout the tutorial",
//               ),
//             ),
//             Row(
//               children: [
//                 const Expanded(child: SizedBox()),
//                 TextButton(
//                     onPressed: () {
//                       tutorialState.setIsStep1Complete(true);
//                       tutorialState
//                           .setSequenceStep(tutorialState.sequenceStep + 1);
//                     },
//                     child: Text(
//                       "Okay Got it",
//                       style: TextStyle(fontSize: 22, color: palette.textColor1),
//                     ))
//               ],
//             )
//           ],
//         ),
//       ),
//       const Expanded(flex: 3, child: SizedBox()),
//     ],
//   );
// }

Widget textWidget(ColorPalette palette, TutorialState tutorialState) {
  late Map<String, dynamic> sequenceObject = tutorialDetails
      .firstWhere((elem) => elem['step'] == tutorialState.sequenceStep);

  return Column(
    children: [
      const Expanded(flex: 1, child: SizedBox()),
      Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            DefaultTextStyle(
              style: TextStyle(fontSize: 22, color: palette.textColor2),
              child: Text(sequenceObject['text']),
            ),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                TextButton(
                    onPressed: () {
                      tutorialState
                          .setSequenceStep(tutorialState.sequenceStep + 1);
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
