// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_board.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_bonus_items.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_ended_overlay.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_floating_step.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_overlay.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_pause_overlay.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_random_letters.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_scoreboard.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_step.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_time_widget.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialScreen1 extends StatefulWidget {
  const TutorialScreen1({super.key});

  @override
  State<TutorialScreen1> createState() => _TutorialScreen1State();
}

class _TutorialScreen1State extends State<TutorialScreen1>
    with TickerProviderStateMixin {
  late AnimationState _animationState;
  late AnimationController _textGlowController;
  late Animation<double> _textGlowAnimation;
  late SettingsController settings;
  late GamePlayState gamePlayState;

  late ColorPalette palette;
  late TutorialState tutorialState;
  late bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationState = Provider.of<AnimationState>(context, listen: false);
    tutorialState = Provider.of<TutorialState>(context, listen: false);
    settings = Provider.of<SettingsController>(context, listen: false);
    palette = Provider.of<ColorPalette>(context, listen: false);
    gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    initializeAnimations(palette);



  }

  void initializeAnimations(
    ColorPalette palette,
  ) {
    _textGlowController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    final List<TweenSequenceItem<double>> glowSequence = [
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 0.3,
            end: 1.0,
          ),
          weight: 0.5),
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 1.0,
            end: 0.3,
          ),
          weight: 0.5),
    ];
    _textGlowAnimation =
        TweenSequence<double>(glowSequence).animate(_textGlowController);

    _textGlowController.forward();
    _textGlowController.addListener(() {
      if (_textGlowController.isCompleted) {
        _textGlowController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _textGlowController.dispose();
    super.dispose();
  }

  Color getColor(ColorPalette palette, Animation animation,
      Map<String, dynamic> currentStep, String widgetId) {
    final bool active = currentStep['targets'].contains(widgetId);
    late Color res = palette.textColor2;
    if (active) {
      res = Color.fromRGBO(palette.textColor2.red, palette.textColor2.green,
          palette.textColor2.blue, animation.value);
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {

    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {
        final Map<String, dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);

        return SafeArea(
            child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: palette.optionButtonBgColor,
                title: Text(
                  Helpers().translateText(gamePlayState.currentLanguage, "Demonstration"),
                  style: TextStyle(color: palette.textColor2),
                ),
                actions: <Widget>[
                  AnimatedBuilder(
                    animation: _textGlowAnimation,
                    builder: (context, child) {
                      return TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  Helpers().translateText(gamePlayState.currentLanguage, "Start Game!"),
                                ),
                                content: Text(
                                    'Are you sure you want to skip the tutorial?'),
                                actions: <TextButton>[
                                  TextButton(
                                      onPressed: () {
                                        FirestoreMethods().updateParameters(
                                            (settings.userData.value
                                                as Map<String, dynamic>)['uid'],
                                            'hasSeenTutorial',
                                            true);

                                        Helpers()
                                            .getStates(gamePlayState, settings);

                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const GameScreen()),
                                        );
                                      },
                                      child: Text("Yes")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("No"))
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'Skip Tutorial',
                          style: TextStyle(
                              color: getColor(palette, _textGlowAnimation,
                                  currentStep, 'skip_tutorial')),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _textGlowAnimation,
                    builder: (context, child) {
                      return IconButton(
                        color: palette.optionButtonBgColor,
                        onPressed: () {
                          // if (currentStep['step'] == 36) {
                          //   tutorialState.setSequenceStep(tutorialState.sequenceStep-14);
                          // }
                          TutorialHelpers().executePreviousStep(tutorialState, animationState);
                          if (tutorialState.sequenceStep == 6) {
                            tutorialState.tutorialCountDownController.restart(
                              duration: 5,
                            );
                            tutorialState.tutorialCountDownController.pause();                       
                            // tutorialState.tutorialCountDownController.restart();
                          }
                          debugPrint(tutorialState.sequenceStep.toString());
                        },
                        icon: Icon(
                          Icons.replay_circle_filled_sharp,
                          color: getColor(palette, _textGlowAnimation, currentStep, 'back_step')
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: palette.screenBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      child: Column(
                        children: [
                          // Column(
                          //   children: [
                          const TutorialTimerWidget(),
                          TutorialScoreboard(animation: _textGlowAnimation),
                          TutorialBonusItems(animation: _textGlowAnimation),
                          const Expanded(flex: 5, child: SizedBox()),
                          TutorialRandomLetters(animation: _textGlowAnimation),
                          // const Expanded(child: SizedBox()),
                          TutorialBoard(animation: _textGlowAnimation),
                          const Expanded(child: SizedBox()),
                          Container(
                            padding: EdgeInsets.only(bottom: 10.0),
                            color: palette.screenBackgroundColor,
                            child: AnimatedBuilder(
                              animation: _textGlowAnimation,
                              builder: (context, child) {
                                return InkWell(
                                  child: Icon(
                                    Icons.pause_circle,
                                    shadows: TutorialHelpers().getTextShadow(
                                        currentStep,
                                        palette,
                                        'pause',
                                        _textGlowAnimation),
                                    size: 26,
                                    color: getColor(
                                        palette,
                                        _textGlowAnimation,
                                        currentStep,
                                        'pause'), //palette.textColor2,
                                  ),
                                  onTap: () {
                                    if (currentStep['callbackTarget'] ==
                                        'pause') {
                                      tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
                                      animationState.setShouldRunTutorialNextStepAnimation(true);
                                      animationState.setShouldRunTutorialNextStepAnimation(false);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          // spaceForSteps(currentStep),
                          // tutorialState.sequenceStep  >2  ? const SizedBox() : const SizedBox(height: 100,),
                          // currentStep['isGameStarted']  !currentStep['isGameEnded'] ? const SizedBox(height: 100,) : const SizedBox(),
                          //   ],
                          // ),
                          // TutorialPauseOverlay(),
                          // const TutorialStep(),
                        ],
                      ),
                    ),
                  ),
                  TutorialPauseOverlay(
                    animation: _textGlowAnimation,
                  ),
                  // const TutorialOverlay(),
                ],
              ),
              // bottomNavigationBar:   currentStep['isGameStarted'] && !currentStep['isGameEnded'] ? const SizedBox() : const TutorialStep(),
              // bottomNavigationBar:TutorialStep(), // displayTextBox(currentStep),

              // const TutorialStep() :
              // bottomNavigationBar: NavigationBar(destinations: const []),
            ),
            TutorialEndedOverlay(),
            PreGameOverlay(),
            TutorialFloatingStep(
              width: MediaQuery.of(context).size.width,
              // tutorialState: tutorialState,
            )
          ],
        ));
      },
    );
  }
}

Widget spaceForSteps(Map<String, dynamic> currentStep) {
  Widget res = const SizedBox();
  if (currentStep['isGameStarted']) {
    if (currentStep['isGameEnded']) {
      res = const SizedBox(
        height: 100,
      );
    } else {
      res = const SizedBox();
    }
  } else {
    res = const SizedBox(
      height: 100,
    );
  }
  return res;
}

// Widget displayTextBox(Map<String,dynamic> currentStep) {
//   Widget res = const SizedBox();

//   if (currentStep['isGameStarted']) {

//     if (currentStep['isGameEnded']) {
//       res = const SizedBox();
//     } else {
//       res = const TutorialStep();
//     }
//   } else {
//     res = const SizedBox();
//   }
//   return res;
// }

// class GameSummaryScreen extends StatelessWidget {
//   const GameSummaryScreen({super.key});

//   @override
//   Key? get key => null;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TutorialState>(builder: (context, tutorialState, child) {
//       return DialogWidget(
//           key, "Game Summary", TutorialSummaryContent(tutorialState), null);
//     });
//   }
// }

// class TutorialSummaryContent extends StatefulWidget {
//   final TutorialState tutorialState;
//   // final GameState gameState;
//   const TutorialSummaryContent(this.tutorialState,
//       // this.gameState,
//       {super.key});

//   @override
//   State<TutorialSummaryContent> createState() => _TutorialSummaryContentState();
// }

// class _TutorialSummaryContentState extends State<TutorialSummaryContent> {
//   // late bool displayWords;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   displayWords = false;
//   // }

//   // void toggleDisplay() {
//   //   setState(() {
//   //     displayWords = !displayWords;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     late ColorPalette palette =
//         Provider.of<ColorPalette>(context, listen: true);

//     return Consumer<TutorialState>(
//       builder: (context, tutorialState, child) {
//         if (tutorialState.sequenceStep == 42) {
//           return ShowWordsView(
//             palette: palette,
//             tutorialState: tutorialState,
//             // toggleDisplay: toggleDisplay,
//           );         
//         } else if (tutorialState.sequenceStep == 41) {
//           return TutorialSummaryView(
//             palette: palette,
//             tutorialState: tutorialState,
//             // curentHighscore: Helpers().getCurrentHighScore(settings),
//             // toggleDisplay: toggleDisplay
//           );
//         } else {
//           return SizedBox();
//         }
//         // return tutorialState.sequenceStep == 42 
//         //     ? ShowWordsView(
//         //         palette: palette,
//         //         tutorialState: tutorialState,
//         //         toggleDisplay: toggleDisplay,
//         //       )
//         //     : TutorialSummaryView(
//         //         palette: palette,
//         //         tutorialState: tutorialState,
//         //         // curentHighscore: Helpers().getCurrentHighScore(settings),
//         //         toggleDisplay: toggleDisplay);
//       },
//     );
//   }
// }

// class ShowWordsView extends StatefulWidget {
//   final ColorPalette palette;
//   final TutorialState tutorialState;
//   // final VoidCallback toggleDisplay;

//   const ShowWordsView(
//       {super.key,
//       required this.palette,
//       required this.tutorialState,
//       // required this.toggleDisplay
//     });

//   @override
//   State<ShowWordsView> createState() => _ShowWordsViewState();
// }

// class _ShowWordsViewState extends State<ShowWordsView> {
//   // late bool displayWords;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 // "All ${widget.gamePlayState.summaryData['uniqueWords'].length} Unique Words",
//                 "0",
//                 style: const TextStyle(fontSize: 24),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SizedBox(
//               width: double.infinity,
//               child: Table(
//                 columnWidths: const {
//                   0: FixedColumnWidth(1),
//                   1: FixedColumnWidth(200),
//                 },
//                 children: [
//                   TableRow(children: [Text("caca")])
//                 ],
//               ),
//             ),
//           ),
//           InkWell(
//             // onTap: widget.toggleDisplay,
//             child: Row(
//               children: [
//                 const Expanded(flex: 1, child: SizedBox()),
//                 Icon(Icons.arrow_upward,
//                     size: 20, color: widget.palette.textColor2),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Text(
//                   "Hide",
//                   style: TextStyle(
//                     fontSize: 24,
//                     color: widget.palette.textColor2,
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class TutorialSummaryView extends StatefulWidget {
//   final ColorPalette palette;
//   final TutorialState tutorialState;
//   // final int curentHighscore;
//   // final VoidCallback toggleDisplay;
//   const TutorialSummaryView(
//       {super.key,
//       required this.palette,
//       required this.tutorialState,
//       // required this.curentHighscore,
//       // required this.toggleDisplay
//       });

//   @override
//   State<TutorialSummaryView> createState() => _TutorialSummaryViewState();
// }

// class _TutorialSummaryViewState extends State<TutorialSummaryView> {
//   @override
//   Widget build(BuildContext context) {
//     late TutorialState tutorialState = Provider.of<TutorialState>(context, listen: false);
//     late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
//     final Map<String, dynamic> currentStep =
//         TutorialHelpers().getCurrentStep2(tutorialState);

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(children: [
//         const Expanded(child: SizedBox()),
//         Table(
//           columnWidths: const <int, TableColumnWidth>{
//             0: FlexColumnWidth(1),
//             1: FlexColumnWidth(5),
//             2: FlexColumnWidth(2),
//           },
//           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//           children: <TableRow>[
//             tableRowItem(
//                 "Score",
//                 // widget.gamePlayState.currentLevel.toString(),
//                 (currentStep['points'] ?? 0).toString(),
//                 Icon(Icons.emoji_events,
//                     size: 22, color: widget.palette.textColor2),
//                 widget.palette),
//             tableRowItem(
//                 "Duration",
//                 "--",
//                 Icon(Icons.timer, size: 22, color: widget.palette.textColor2),
//                 widget.palette),
//             tableRowItem(
//                 "Level",
//                 "Level 1",
//                 Icon(Icons.bar_chart,
//                     size: 22, color: widget.palette.textColor2),
//                 widget.palette),
//           ],
//         ),
//         const Expanded(child: SizedBox()),
//         Text(
//           "Summary",
//           style: TextStyle(color: widget.palette.textColor2, fontSize: 24),
//         ),
//         Table(
//           columnWidths: const <int, TableColumnWidth>{
//             0: FlexColumnWidth(1),
//             1: FlexColumnWidth(5),
//             2: FlexColumnWidth(2),
//           },
//           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//           children: <TableRow>[
//             tableRowItem(
//                 "Longest Streak",
//                 4.toString(),
//                 Icon(Icons.bolt, size: 22, color: widget.palette.textColor2),
//                 widget.palette),
//             tableRowItem(
//                 "Cross Words",
//                 1.toString(),
//                 Icon(Icons.close, size: 22, color: widget.palette.textColor2),
//                 widget.palette),
//             tableRowItem(
//                 "Most Points",
//                 276.toString(),
//                 Icon(Icons.star, size: 22, color: widget.palette.textColor2),
//                 widget.palette),
//             tableRowItem(
//                 "Most Words",
//                 3.toString(),
//                 Icon(Icons.my_library_books,
//                     size: 22, color: widget.palette.textColor2),
//                 widget.palette),
//           ],
//         ),
//         const Expanded(child: SizedBox()),
//         // widget.gamePlayState.summaryData.isEmpty
//         //     ? const SizedBox()
//         InkWell(
//           onTap: () {
//             tutorialState.setSequenceStep(tutorialState.sequenceStep+1);
//             animationState.setShouldRunTutorialNextStepAnimation(true);
//             animationState.setShouldRunTutorialNextStepAnimation(false);
//           }, // widget.toggleDisplay,
//           child: Text("View points summary"),
//               // TextSpan(
//               //   text: 'View all ',
//               //   style: TextStyle(
//               //       fontSize: 20,
//               //       color: widget.palette.textColor3,
//               //       fontStyle: FontStyle.italic),
//               //   children: <TextSpan>[
//               //     TextSpan(
//               //         text: widget.gamePlayState.summaryData['uniqueWords'].length.toString(),
//               //         style: TextStyle(
//               //             decoration: TextDecoration.underline,
//               //             decorationColor: widget.palette.textColor3,
//               //             decorationThickness: 1.0)),
//               //     const TextSpan(text: ' words'),
//               //   ],
//               // ),
//               // ),
//         ),
//         const Expanded(child: SizedBox()),
//       ]),
//     );
//   }
// }

// TableRow tableRowItem(
//     String textBody, String data, Icon icon, ColorPalette palette) {
//   return TableRow(children: [
//     Center(
//       child: icon,
//     ),
//     Text(
//       textBody,
//       style: TextStyle(color: palette.textColor2, fontSize: 20),
//     ),
//     Align(
//       alignment: Alignment.centerRight,
//       child: Text(
//         data,
//         style: TextStyle(color: palette.textColor2, fontSize: 20),
//         textAlign: TextAlign.right,
//       ),
//     ),
//   ]);
// }
