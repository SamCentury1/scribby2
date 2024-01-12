import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_draggable_tile.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialBoard extends StatefulWidget {
  final Animation animation;
  const TutorialBoard({
    super.key,
    required this.animation,
  });

  @override
  State<TutorialBoard> createState() => _TutorialBoardState();
}

class _TutorialBoardState extends State<TutorialBoard> {
  // late double boardWidth = 0;
  // late double tileSide = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   boardWidth = MediaQuery.of(context).size.width * 0.8;
  //   tileSide = boardWidth / 7;
  // }

  @override
  Widget build(BuildContext context) {
    late double boardWidth = MediaQuery.of(context).size.width * 0.7;
    late double tileSide = boardWidth / 6;

    // late ColorPalette palette = Provider.of(context, listen: false);

    return Consumer<TutorialState>(builder: (context, tutorialState, child) {
      return Column(
        children: [
          SizedBox(
            width: boardWidth,
            height: boardWidth,
            // color: Colors.yellow,
            child: GridView(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisExtent: tileSide,
              ),
              children: List<Widget>.generate(36, (int i) {
                return Builder(
                  builder: (BuildContext context) {
                  return TutorialTile(
                      // tutorialState: tutorialState,
                      // palette: palette,
                      index: i,
                      tileSide: tileSide,
                      animation: widget.animation,
                    );
                });
              }),
            ),
          ),
          // const Expanded(flex: 1, child: SizedBox()),
          const SizedBox(height: 10,),
          Consumer<TutorialState>(
            builder: (context, tutorialState, child) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: (MediaQuery.of(context).size.width * 0.7)/6,
                // color: Colors.purple,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (Map<String, dynamic> reserve in tutorialState.reserveTiles)
                      Stack(
                        children: [
                          Draggable(
                            data: reserve["body"] == "" ? const SizedBox() : draggedTile(reserve["body"],Colors.red, tileSide), // draggedTile(reserve["body"], Colors.red),
                            feedback: reserve["body"] =="" ? const SizedBox() : TutorialDraggableTile(tileState:reserve,tileSide:tileSide), // draggedTile(reserve["body"], const Color.fromARGB(255, 73, 54, 244)),
                            childWhenDragging:
                                reserve["body"] == ""
                                    ? TutorialDraggableTile(tileState:reserve,tileSide:tileSide)
                                    : TutorialDraggableTile(tileState: {"id":reserve["id"],"body": ""},tileSide:tileSide),
                            child: TutorialDraggableTile(tileState:reserve,tileSide:tileSide), //draggedTile(reserve["body"], Colors.black),
                
                            onDragStarted: () {
                              if (reserve['body'] =="") {
                                TutorialHelpers().placeIntoReserves(context,tutorialState,reserve,tutorialDetails);
                              } else {
                                tutorialState.setDraggedReserveTile(reserve);
                              }
                            },
                            onDragEnd: (details) {
                              tutorialState.setDraggedReserveTile({});
                            },
                          ),
                        ],
                      )                      
                  ]
                ),
              );
            }
          ),
        ],
      );
    });
  }
}
Widget draggedTile(String letter, Color color, double tileSide) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Container(
      width: tileSide,
      height: tileSide,
      color: color,
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
    ),
  );
}

// Widget tutorialTile(TutorialState tutorialState, ColorPalette palette,
//     int index, double dimension) {
//   // late double dimension2 = MediaQuery.of(context).size.width * 0.8;
//   final Map<String, dynamic> tileState =
//       TutorialHelpers().tutorialTileState(index, tutorialState);
//   return Padding(
//     padding: const EdgeInsets.all(2.0),
//     child: Container(
//       // color: Colors.blueAccent,
//       decoration: BoxDecoration(
//           border: Border.all(
//             width: 3,
//             color: palette.tileBgColor,
//           ),
//           borderRadius: const BorderRadius.all(Radius.circular(10.0))),
//       child: Center(
//           child: Text(
//         tileState['letter'],
//         style: TextStyle(fontSize: 32, color: palette.tileBgColor),
//       )),
//     ),
//   );
// }

class TutorialTile extends StatefulWidget {
  // final TutorialState tutorialState;
  // final ColorPalette palette;
  final int index;
  final double tileSide;
  final Animation animation;
  const TutorialTile(
    {super.key,
      // required this.tutorialState,
      // required this.palette,
    required this.index,
    required this.tileSide,
    required this.animation,
  });

  @override
  State<TutorialTile> createState() => _TutorialTileState();
}

class _TutorialTileState extends State<TutorialTile>
    with TickerProviderStateMixin {
  late AnimationState animationState;

  // late AnimationController _tileGlowController;
  late Animation<double> _tileGlowAnimation;
  late ColorPalette palette;

  @override
  void initState() {
    super.initState();
    animationState = Provider.of<AnimationState>(context, listen: false);
  }

  void reactToInput(TutorialState tutorialState, AnimationState animationState) {
    // late Map<String, dynamic> stepDetails = tutorialDetails.firstWhere((elem) => elem['step'] == tutorialState.sequenceStep);
    TutorialHelpers().updateTutorialTileState(tutorialState, widget.index, animationState, tutorialDetails);

  }

  Color colorTileBorder(Map<String, dynamic> tileObject,TutorialState tutorialState,ColorPalette palette,Animation animation) {
    Map<String, dynamic> stepDetails = tutorialDetails.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
    Color res = Colors.transparent;

    if (stepDetails['targets'].contains(tileObject['index'])) {
      int red = palette.focusedTutorialTile.red;
      int green = palette.focusedTutorialTile.green;
      int blue = palette.focusedTutorialTile.blue;
      res = Color.fromRGBO(red, green, blue, animation.value);
    } else {
      if (tileObject['letter'] == "") {
        int red = palette.tileBgColor.red;
        int green = palette.tileBgColor.green;
        int blue = palette.tileBgColor.blue;
        res = Color.fromRGBO(red, green, blue, 0.5);
      } else {
        res = palette.tileBgColor;
      }
    }
    return res;
  }

  Color getBoxShadow(Map<String, dynamic> tileObject,TutorialState tutorialState, ColorPalette palette, ) {
    Map<String, dynamic> stepDetails = tutorialDetails.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
    Color res = Colors.transparent;

    // print(stepDetails);
    if (stepDetails['targets'].contains(tileObject['index'])) {
      if (tileObject['letter'] == "") {
        res = Color.fromRGBO(
          palette.focusedTutorialTile.red,
          palette.focusedTutorialTile.green,
          palette.focusedTutorialTile.blue,
          0.3
        );
      } else {
        res = Colors.transparent;
      }
    } else {
      res = Colors.transparent;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: true);

    late TutorialState tutorialState = Provider.of<TutorialState>(context, listen: false);

    late Map<String, dynamic> tileState = TutorialHelpers().tutorialTileState(widget.index, tutorialState);

    late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);

    // late Map<String, dynamic> currentStep = tutorialDetails.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
    final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep(tutorialState);
    // late Map<String,dynamic> currentTile = TutorialHelpers().tutorialTileState(widget.index, tutorialState);

    return GestureDetector(
      onTapUp: (details) {
        if (currentStep['targets'].contains(widget.index)) {
          reactToInput(tutorialState, animationState);
        } else {}
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: AnimatedBuilder(
          animation: widget.animation,
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  // color: Colors.blueAccent,
                  decoration: BoxDecoration(
                      color: tileState['alive'] ? palette.screenBackgroundColor : const Color.fromARGB(255, 87, 87, 87),
                      // color:Color.fromARGB(167, 56, 56, 56) ,
                      border: Border.all(
                        width: 3,
                        color: colorTileBorder(tileState, tutorialState, palette, widget.animation),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: getBoxShadow(tileState, tutorialState, palette),
                          spreadRadius: 4,
                          blurRadius: 7,
                        ),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(10.0))),
                  child: Center(
                      child: Text(
                    tileState['letter'],
                    style: TextStyle(fontSize: 26, color: palette.tileBgColor),
                  )),
                ),
                DragTarget(
                  onAccept: (details) {
                    TutorialHelpers().dropTile(context,widget.index, tutorialState, tutorialDetails);
                  }, 
                  builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
                    return draggedTile("", Colors.transparent, widget.tileSide);
                })
              ],
            );
          },
        ),
      ),
    );
  }
}


