
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/dialogs/game_pause_screens/game_help_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/dialogs/game_pause_screens/game_settings_screen.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TutorialPauseOverlay extends StatefulWidget {
  final Animation animation;
  const TutorialPauseOverlay({
    super.key,
    required this.animation,
  });

  @override
  State<TutorialPauseOverlay> createState() => _TutorialPauseOverlayState();
}

class _TutorialPauseOverlayState extends State<TutorialPauseOverlay> {

  // final PageController _controller = PageController();
  late int currentPage = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = PageController();
  // }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  dynamic convertIconNameToIndex(dynamic iconName) {
    if (iconName == 'help_icon') {
      return 1;
    } else if (iconName == 'settings_icon') {
      return 2;
    } else if (iconName == 'exit_icon') {
      return 3;
    } else if (iconName == 'summary_icon') {
      return 0;
    } else if (iconName == 'exit_button') {
      return 3;
    }else {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    late AnimationState animationState =Provider.of<AnimationState>(context, listen: false);
    late ColorPalette palette =Provider.of<ColorPalette>(context, listen: false);
    // late TutorialState tutorialState = Provider.of<TutorialState>(context, listen: false);
    // late Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);

    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {

        final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);

        return AnimatedOpacity(
          opacity: currentStep['isPaused'] && !currentStep['isGameEnded']
              ? 1.0
              : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !currentStep['isPaused'],
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      // if (tutorialState.isGamePaused) {
                      //   if (tutorialState.isGameStarted) {
                      //     tutorialState.setIsGamePaused(false, 0);
                      //     GameLogic().executeTimerAnimation(animationState);
                      //   }
                      // }
                    },
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),



                        // gamePlayState.isGamePaused ? changeBackToZero() : null;
                Dialog(
                  insetPadding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.65,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                          color: palette.optionButtonBgColor
                          // color: Color.fromARGB(125, 71, 65, 65)
                          ),
                      child: Column(
                        children: <Widget>[
                          // TextButton(onPressed: changeBackToZero, child: Text("change")),
                          Expanded(
                            child: DisplayPauseOverlayWidget(animation: widget.animation),
                            // child: displayWidget(tutorialState, widget.animation)
                            // child: Stack(
                            //   children: [
                                
                            //     TutorialSummaryScreen(animation: widget.animation,),
                            //     const GameHelpScreen(),
                            //     const GameSettings(),
                            //     TutorialExitPage(animation: widget.animation,),                                
                            //   ],
                            // ),
                            // child: PageView(
                            //   // controller: gamePlayState.pageController,
                            //   // controller: _controller,
                            //   onPageChanged: (index) {
                               
                            //     if (index == convertIconNameToIndex(currentStep['callbackTarget'])) {
                            //       setState(() {
                            //         currentPage = index;
                            //       });
                            //     } 
                            //   },
                            //   children: <Widget>[
                            //     TutorialSummaryScreen(animation: widget.animation,),
                            //     // GameSummaryScreen(),
                            //     GameHelpScreen(),
                            //     GameSettings(),
                            //     TutorialExitPage(animation: widget.animation,),

                            //     // GameQuitScreen()
                            //   ],
                            // ),
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            child: AnimatedBuilder(
                              animation: widget.animation,
                              builder: (context, child) {             
                                return BottomNavigationBar(
                                  currentIndex: convertIconNameToIndex(currentStep['callbackTarget']) ?? 0,
                                  onTap: (index) {
                                    // if (index == convertIconNameToIndex(currentStep['callbackTarget'])) {
                                    //   tutorialState.setSequenceStep(tutorialState.sequenceStep+1);
                                    //   setState(() {
                                    //     currentPage = index;
                                    //     // _controller.animateToPage(
                                    //     //   index,
                                    //     //   duration: const Duration(milliseconds: 300),
                                    //     //   curve: Curves.ease,
                                    //     // );
                                    //   });
                                    // } 
                                
                                  },
                                  type: BottomNavigationBarType.shifting,
                                  // type: BottomNavigationBarType.fixed,
                                  selectedItemColor: palette.tileBgColor,
                                  unselectedItemColor: palette.optionButtonTextColor,
                                  items: [
                                    BottomNavigationBarItem(
                                      icon: Icon(
                                        Icons.gamepad,
                                        // color: TutorialHelpers().getGlowAnimationColor(currentStep,palette,'summary_icon', widget.animation),
                                        
                                      ),
                                      label: 'Summary',
                                      backgroundColor: palette.optionButtonBgColor2
                                    ),
                                    BottomNavigationBarItem(
                                      icon: Icon(
                                        Icons.help,
                                        // color: TutorialHelpers().getGlowAnimationColor(currentStep,palette,'help_icon', widget.animation),
                                      ),
                                      label: 'Help',
                                      backgroundColor: palette.optionButtonBgColor2
                                    ),
                                    BottomNavigationBarItem(
                                      icon: Icon(
                                        Icons.settings,
                                        // color: TutorialHelpers().getGlowAnimationColor(currentStep,palette,'settings_icon', widget.animation),
                                      ),
                                      label: 'Settings',
                                      backgroundColor: palette.optionButtonBgColor2
                                    ),
                                    BottomNavigationBarItem(
                                      icon: Icon(
                                        Icons.exit_to_app,
                                        // color: TutorialHelpers().getGlowAnimationColor(currentStep,palette,'exit_icon', widget.animation),
                                      ),
                                      label: 'Quit',
                                      backgroundColor: palette.optionButtonBgColor2
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// Widget displayWidget(TutorialState tutorialState, Animation animation) {
//   late Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
              
                             
//   if (currentStep['callbackTarget'] == 'pause') {
//     return TutorialSummaryScreen(animation: animation,);
//   } else if (currentStep['callbackTarget'] == 'help_icon') {
//     return const GameHelpScreen();
//   } else if (currentStep['callbackTarget'] == 'settings_icon') {
//     return const GameSettings();
//   } else if (currentStep['callbackTarget'] == 'exit_icon') {
//     return TutorialExitPage(animation: animation,);  
//   } else {
//     return TutorialSummaryScreen(animation: animation,);
//   }

// }

class DisplayPauseOverlayWidget extends StatefulWidget {
  final Animation animation;
  const DisplayPauseOverlayWidget({
    super.key,
    required this.animation,
    });

  @override
  State<DisplayPauseOverlayWidget> createState() => _DisplayPauseOverlayWidgetState();
}

class _DisplayPauseOverlayWidgetState extends State<DisplayPauseOverlayWidget> {
  @override
  Widget build(BuildContext context) {

    late TutorialState tutorialState = Provider.of<TutorialState>(context, listen: false);
    late Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);


    if (currentStep['callbackTarget'] == 'pause') {
      return TutorialSummaryScreen(animation: widget.animation,);
    } else if (currentStep['targets'].contains('help_icon')) {
      return const GameHelpScreen();
    } else if (currentStep['targets'].contains('settings_icon')) {
      return const GameSettings();
    } else if (currentStep['targets'].contains('exit_icon')) {
      return TutorialExitPage(animation: widget.animation,);  
    } else if (currentStep['targets'].contains('exit_button')) {
      return TutorialExitPage(animation: widget.animation,);  
    } else {
      return TutorialSummaryScreen(animation: widget.animation,);
    }
  }
}


class TutorialSummaryScreen extends StatefulWidget {
  final Animation animation;
  const TutorialSummaryScreen({
    super.key,
    required this.animation
  });

  @override
  State<TutorialSummaryScreen> createState() => _TutorialSummaryScreenState();
}

class _TutorialSummaryScreenState extends State<TutorialSummaryScreen> {


  late bool displayWords;

  @override
  void initState() {
    super.initState();
    displayWords = false;
  }

  void toggleDisplay() {
    setState(() {
      displayWords = !displayWords;
    });
  }

  @override
  Key? get key => null;


  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      key, 
      'Game Summary', 
      displayWords 
        ? TutorialDisplayScoreSummary(toggleDisplay: toggleDisplay,)  
        : TutorialDisplayGameSummary(toggleDisplay: toggleDisplay, animation: widget.animation),
      null
    );
    // return displayWords 
    //   ? TutorialDisplayScoreSummary(toggleDisplay: toggleDisplay,) 
    //   : TutorialDisplayGameSummary(toggleDisplay: toggleDisplay,);
  }
}


class TutorialDisplayScoreSummary extends StatefulWidget {
  final VoidCallback toggleDisplay;
  const TutorialDisplayScoreSummary({
    super.key,
    required this.toggleDisplay
  });

  @override
  State<TutorialDisplayScoreSummary> createState() => _TutorialDisplayScoreSummaryState();
}

class _TutorialDisplayScoreSummaryState extends State<TutorialDisplayScoreSummary> {
  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    late TutorialState tutorialState = Provider.of<TutorialState>(context, listen: false);
    // late Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
    late Map<String,dynamic> gameSummary = tutorialState.tutorialSummaryData; 
    return Column(
      children: [
        Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(5),
            2: FlexColumnWidth(2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: [
                Center(
                  child: Text(
                    "#",
                    style: TextStyle(color: palette.textColor2, fontSize: 20),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Word",
                    style: TextStyle(color: palette.textColor2, fontSize: 20),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Points",
                    style: TextStyle(color: palette.textColor2, fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                ),
              ]
            ),
            for (int i=0; i<gameSummary['summary'].length; i++)
            scoreSummaryTableRow(i,palette,gameSummary['summary'][i]),
          ]
        ),
        const Expanded(child: SizedBox(),),        
        // ElevatedButton(
        //   onPressed: () {}, 
        //   child: Text("view game")
        // )
      ],
    );
  }
}

Widget multiplierIcon(String stat, int turn, int data, ColorPalette palette) {

  Color textColor = turn.isEven ? palette.textColor1 : palette.textColor3;
  late IconData iconItem;
  if (stat == 'wordMultiplier') {
    iconItem = Icons.bookmark;
  } else if (stat == 'crosswordMultiplier') {
    iconItem = Icons.close;
  } else if (stat == 'streakMultiplier') {
    iconItem = Icons.bolt;
  }

  return SizedBox(
    width: 35,
    child: Stack(
      children: [
        Icon(
          iconItem,
          size: 16,
          color: textColor,
        ),
        Positioned(
          left: 14.0,
          top:-3,
          child: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:"x",
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor
                    )
                ),
                TextSpan(
                  text: data.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor
                  )
                ),
              ],
            ),
          ),          
        )
    
      ],
    ),
  );
}

TableRow scoreSummaryTableRow(int index, ColorPalette palette, Map<String,dynamic> data) {

  Color textColor = data['turn'].isEven ? palette.textColor1 : palette.textColor3;

  return TableRow(children: [
    Center(
      child: Text(
        (index+1).toString(),
        style: TextStyle(
          color: textColor,
          fontSize: 20
        ),
      ),
    ),
    Row(
      children: [
        Text(
          data['word'],
          style: TextStyle(
            color: textColor,
            fontSize: 20,
          ),
        ),
        SizedBox(width: 10,),
        Expanded(child: SizedBox()),
        data['wordMultiplier'] > 1 ? multiplierIcon('wordMultiplier',data['turn'], data['wordMultiplier'], palette) : const SizedBox(),
        data['crosswordMultiplier'] > 1 ? multiplierIcon('crosswordMultiplier',data['turn'], data['crosswordMultiplier'], palette) : const SizedBox(),
        data['streakMultiplier'] > 1 ? multiplierIcon('streakMultiplier',data['turn'], data['streakMultiplier'], palette) : const SizedBox(),
      ],
    ),
    Align(
      alignment: Alignment.centerRight,
      child: Text(
        data['points'].toString(),
        style: TextStyle(color: textColor, fontSize: 20),
        textAlign: TextAlign.right,
      ),
    ),
  ]);
}


class TutorialDisplayGameSummary extends StatefulWidget {
  final VoidCallback toggleDisplay;
  final Animation animation;
  const TutorialDisplayGameSummary({
    super.key,
    required this.toggleDisplay,
    required this.animation
  });    

  @override
  State<TutorialDisplayGameSummary> createState() => _TutorialDisplayGameSummaryState();
}

class _TutorialDisplayGameSummaryState extends State<TutorialDisplayGameSummary> {
  @override

  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    late TutorialState tutorialState = Provider.of<TutorialState>(context, listen: false);
    late Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(children: [
        const Expanded(child: SizedBox()),
        Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(5),
            2: FlexColumnWidth(2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            tableRowItem(
                "Score",
                // widget.gamePlayState.currentLevel.toString(),
                // (widget.gamePlayState.summaryData['points'] ?? 0).toString(),
                tutorialState.tutorialSummaryData['score'].toString(),
                Icon(Icons.emoji_events,
                    size: 22, color: palette.textColor2),
                palette),
            tableRowItem(
                "Words",
                // widget.gamePlayState.currentLevel.toString(),
                // (widget.gamePlayState.summaryData['points'] ?? 0).toString(),
                tutorialState.tutorialSummaryData['words'].toString(),
                Icon(Icons.book_sharp,
                    size: 22, color: palette.textColor2),
                palette),                
            tableRowItem(
                "Duration",
                // GameLogic().formatTime(widget.gamePlayState.duration.inSeconds),
                "--",
                Icon(Icons.timer, size: 22, color: palette.textColor2),
                palette),
            tableRowItem(
                "Level",
                // widget.gamePlayState.currentLevel.toString(),
                "1",
                Icon(Icons.bar_chart,
                    size: 22, color: palette.textColor2),
                palette),
          ],
        ),
        const Expanded(child: SizedBox()),
        Text(
          "Summary",
          style: TextStyle(color: palette.textColor2, fontSize: 24),
        ),
        Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(5),
            2: FlexColumnWidth(2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            tableRowItem(
                "Longest Streak",
                // (widget.gamePlayState.summaryData['longestStreak'] ?? 0)
                //     .toString(),
                tutorialState.tutorialSummaryData['longestStreak'].toString(),
                Icon(Icons.bolt, size: 22, color: palette.textColor2),
                palette),
            tableRowItem(
                "Cross Words",
                // (widget.gamePlayState.summaryData['crosswords'] ?? 0)
                //     .toString(),
                tutorialState.tutorialSummaryData['crosswords'].toString(),
                Icon(Icons.close, size: 22, color: palette.textColor2),
                palette),
            tableRowItem(
                "Most Points",
                // (widget.gamePlayState.summaryData['mostPoints'] ?? 0)
                //     .toString(),
                tutorialState.tutorialSummaryData['mostPoints'].toString(),
                Icon(Icons.star, size: 22, color: palette.textColor2),
                palette),
            tableRowItem(
                "Most Words",
                // (widget.gamePlayState.summaryData['mostWords'] ?? 0).toString(),
                tutorialState.tutorialSummaryData['mostWords'].toString(),
                Icon(Icons.my_library_books,
                    size: 22, color: palette.textColor2),
                palette),
          ],
        ),
        const Expanded(child: SizedBox()),
        InkWell(
          onTap: () {
            if (currentStep['callbackTarget'] == 'view_score_summary') {
              tutorialState.setSequenceStep(tutorialState.sequenceStep+1);
              widget.toggleDisplay();
            }
          },
          child: Container(
            padding: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(
              color: palette.textColor2,
              width: 1.0, // Underline thickness
              ))
            ),
            child: AnimatedBuilder(
              animation: widget.animation,
              builder: (context, child) {   
                return Text(
                  "View score summary",
                  style: TextStyle(
                    color: palette.textColor2,
                    fontStyle: FontStyle.italic,
                    fontSize: 22,
                    shadows: TutorialHelpers().getTextShadow(currentStep, palette, 'view_score_summary', widget.animation)
                  ),
                );
              },
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ]),
    );
  }  
}


TableRow tableRowItem(
    String textBody, String data, Icon icon, ColorPalette palette) {
  return TableRow(children: [
    Center(
      child: icon,
    ),
    Text(
      textBody,
      style: TextStyle(color: palette.textColor2, fontSize: 20),
    ),
    Align(
      alignment: Alignment.centerRight,
      child: Text(
        data,
        style: TextStyle(color: palette.textColor2, fontSize: 20),
        textAlign: TextAlign.right,
      ),
    ),
  ]);
}


class TutorialExitPage extends StatefulWidget {
  final Animation animation;
  const TutorialExitPage({
    super.key,
    required this.animation
  });

  @override
  State<TutorialExitPage> createState() => _TutorialExitPageState();
}

class _TutorialExitPageState extends State<TutorialExitPage> {
  late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
  late TutorialState tutorialState = Provider.of<TutorialState>(context,listen: false);
  late Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
  @override
  Key? get key => null;

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      key,
      "Exit",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(flex: 2, child: SizedBox(),),
          Text(
            "Would you like to leave?",
            style: TextStyle(
              color: palette.textColor2,
              fontSize: 22
            ),
          ),
          AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) {              
              return TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette.optionButtonBgColor3,
                  foregroundColor: palette.textColor1,
                  shadowColor: TutorialHelpers().getGlowAnimationColor(currentStep, palette, 'exit_button', widget.animation),
                      // const Color.fromRGBO(123, 123, 123, 0.7),
                  elevation: 3.0,
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.all(4.0),
                  textStyle: const TextStyle(
                    fontSize: 22,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius:BorderRadius.all(Radius.circular(10.0)),
                    
                  ),
                ),
                onPressed: () {}, 
                child: Text(
                  "Exit",
                  style: TextStyle(
                    color: TutorialHelpers().getGlowAnimationColor(currentStep, palette, 'exit_button', widget.animation),
                    shadows: TutorialHelpers().getTextShadow(currentStep, palette, 'exit_button', widget.animation)
                  ),
                )
              );
            },
          ),
      
          const Expanded(flex: 1, child: SizedBox(),),
          Text(
            "Or simply restart?",
            style: TextStyle(
              color: palette.textColor2,
              fontSize: 22
            ),          
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: palette.optionButtonBgColor3,
              foregroundColor: palette.textColor1,
              shadowColor:
                  const Color.fromRGBO(123, 123, 123, 0.7),
              elevation: 3.0,
              minimumSize: const Size(double.infinity, 50),
              padding: const EdgeInsets.all(4.0),
              textStyle: const TextStyle(
                fontSize: 22,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
              ),
            ),            
            onPressed: () {}, 
            child: Text("Restart")
          ),       
          const Expanded(flex: 3, child: SizedBox(),),
        ],
      ),
      null
    );
  }
}