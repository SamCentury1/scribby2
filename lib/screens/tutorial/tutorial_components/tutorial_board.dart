import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_draggable_tile.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialBoard extends StatefulWidget {
  final Animation animation;
  final double boardWidth;
  const TutorialBoard({
    super.key,
    required this.animation,
    required this.boardWidth,
  });

  @override
  State<TutorialBoard> createState() => _TutorialBoardState();
}

class _TutorialBoardState extends State<TutorialBoard> {

  @override
  Widget build(BuildContext context) {

    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);

    // late double boardWidth = (MediaQuery.of(context).size.width )*settingsState.sizeFactor*0.8;
    // late double tileSide = boardWidth / 6;

    // if is FALSE - display overlay to tap into
    bool ignoreReserveOverlay(Map<String, dynamic> reserveState, Map<String,dynamic> currentStep) {
      late bool res = true;
      if (currentStep['dragSource'] == null) {
        res = false;
      }
      return res;
    }

    // double getBoardWidth(double currentScreenWidth, double sizeFactor) {
    //   late double res = currentScreenWidth;
    //   if (currentScreenWidth > 500) {
    //     res = 500;
    //   }
    //   return res * sizeFactor;
    // } 

    return Consumer<TutorialState>(builder: (context, tutorialState, child) {
      final Map<String,dynamic> currentStep = tutorialState.tutorialStateHistory2.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
      late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
      late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
      // late double boardWidth = getBoardWidth(MediaQuery.of(context).size.width,settingsState.sizeFactor*0.8 );
      late double tileSide = widget.boardWidth / 6;
      
      return Column(
        children: [
          SizedBox(
            width: widget.boardWidth,
            height: widget.boardWidth,
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
                      index: i,
                      tileSide: tileSide,
                      animation: widget.animation,
                    );
                });
              }),
            ),
          ),

          SizedBox(height: 10*settingsState.sizeFactor,),
          Consumer<TutorialState>(
            builder: (context, tutorialState, child) {
              return SizedBox(
                width: MediaQuery.of(context).size.width *settingsState.sizeFactor*0.8,
                height: (MediaQuery.of(context).size.width *settingsState.sizeFactor*0.8)/6,
                // color: Colors.purple,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (Map<String, dynamic> reserve in currentStep['reserves'])
                      
                      Stack(
                        children: [

                          Draggable(
                            // data: reserve["body"] == "" ? const SizedBox() : draggedTile(reserve["body"],Colors.red, tileSide), // draggedTile(reserve["body"], Colors.red),
                            data: "reserve_${reserve['id']}" != currentStep['dragSource'] 
                              ? const SizedBox() 
                              : TutorialDraggableTile(tileState:reserve,tileSide:tileSide*0.8, animation: widget.animation,), // d          
                  
                            
                            // The widget being dragged (moves with mouse/finger)
                            // feedback: reserve["body"] =="" ? const SizedBox() : TutorialDraggableTile(tileState:reserve,tileSide:tileSide, animation: widget.animation,), // draggedTile(reserve["body"], const Color.fromARGB(255, 73, 54, 244)),
                            feedback: "reserve_${reserve['id']}" != currentStep['dragSource'] 
                              ? SizedBox()
                              : TutorialDraggableTile(tileState:reserve,tileSide:tileSide*0.8, animation: widget.animation,), // draggedTile(reserve["body"], const Color.fromARGB(255, 73, 54, 244)),
                            
                            // The static reserve tile spot
                            childWhenDragging: 

                                // reserve["body"] != ""

                                "reserve_${reserve['id']}" != currentStep['dragSource'] 
                                    ? TutorialDraggableTile(tileState:reserve,tileSide:tileSide*0.8, animation: widget.animation)
                                    : emptyTile(tileSide, palette),//TutorialDraggableTile(tileState: {"id":reserve["id"],"body": ""},tileSide:tileSide, animation: widget.animation),
                            child: TutorialDraggableTile(tileState:reserve,tileSide:tileSide*0.8, animation: widget.animation), //draggedTile(reserve["body"], Colors.black),
                
                            onDragStarted: () {
                              

                              if ("reserve_${reserve['id']}" == currentStep['dragSource']) {
                                tutorialState.setTutorialDraggedReserveTile(reserve);
                              }
                            },
                            onDragEnd: (details) {


                              if (currentStep['callbackTarget'] == "reserve_${reserve['id']}") {
                                TutorialHelpers().reactToTileTap(tutorialState, animationState, currentStep);
                              }
                            
                              tutorialState.setTutorialDraggedReserveTile({});
                            },
                          ),
                          IgnorePointer(
                            ignoring: ignoreReserveOverlay(reserve,currentStep),
                            child: SizedBox(
                              width: tileSide*0.85,
                              height: tileSide*0.85,
                              child: GestureDetector(
                                onTap: () {

                                  if ("reserve_${reserve['id']}" == currentStep['callbackTarget']) {
                                    TutorialHelpers().reactToTileTap(tutorialState, animationState, currentStep);
                                  }
                                },
                              ),
                            )
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

Widget emptyTile(double tileSide, ColorPalette palette) {
  return Container(
      width: tileSide,
      height: tileSide,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
            color:Color.fromRGBO(
              palette.textColor3.red,
              palette.textColor3.green,
              palette.textColor3.blue,
              0.5 
            ),
            // color: colorTileBorder(tileObject,currentStep,palette, animation ),
            width: 3,
        ), // colorTileBorder(tileObject, palette), width: 3),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: const SizedBox()
  );
}



class TutorialTile extends StatefulWidget {
  final int index;
  final double tileSide;
  final Animation animation;
  const TutorialTile({
    super.key,
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
  // late Animation<double> _tileGlowAnimation;
  late ColorPalette palette;

  @override
  void initState() {
    super.initState();
    animationState = Provider.of<AnimationState>(context, listen: false);
  }

  void reactToInput(TutorialState tutorialState, AnimationState animationState) {
    tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
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
        if (!tileObject['alive']) {
          res = Colors.transparent;
        } else {
          res = palette.tileBgColor;
        }
      }
    }
    return res;
  }


  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: true);

    late TutorialState tutorialState = Provider.of<TutorialState>(context, listen: false);
    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);

    final Map<String,dynamic> currentStep = tutorialState.tutorialStateHistory2.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
    late Map<String, dynamic> tileState = currentStep['tileState'].firstWhere((element) => element['index'] == widget.index);
    late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);

    return GestureDetector(
      onTapUp: (details) {
        if (currentStep['callbackTarget'] == widget.index && currentStep['dragSource'] == null) {
          // reactToInput(tutorialState, animationState);
          TutorialHelpers().reactToTileTap(tutorialState, animationState, currentStep);
        } else {}
      },
      child: Padding(
        padding: EdgeInsets.all(2.0*settingsState.sizeFactor),
        child: AnimatedBuilder(
          animation: widget.animation,
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: colorTileBg(tileState, palette),
                      border: Border.all(
                        width: (3*settingsState.sizeFactor),
                        color: getBorderColor(tileState, palette, widget.animation, currentStep)
                      ),
                      boxShadow: [
                        getBoxShadow(tutorialState, palette, widget.index, widget.animation)
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(10.0))),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.all(4.0*settingsState.sizeFactor),
                      child: Container(
                        // color: Colors.orange,
                        decoration: getInnerTileBoxDecoration(tutorialState, palette, widget.index, widget.animation),
                        child: Center(
                          child: AnimatedBuilder(
                            animation: widget.animation,
                            builder: (context, child) {
                              return Text(
                                tileState['letter'],
                                style: TextStyle(
                                  fontSize: (18*settingsState.sizeFactor), 
                                  color: getTextColor(tileState,palette, widget.animation),
                                  shadows: getTextShadow(tileState,palette, widget.animation),
                                  // color: palette.tileBgColor
                                ),
                              );
                            },
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                DragTarget(
                  onAcceptWithDetails: (details) {
                    if (tutorialState.tutorialDraggedReserveTile.isEmpty) {
                    } else {
                      if ("reserve_${tutorialState.tutorialDraggedReserveTile['id']}" == currentStep['dragSource']) {
                        if (widget.index == currentStep['callbackTarget']) {
                          TutorialHelpers().reactToTileTap(tutorialState, animationState, currentStep);
                        } 
                      } 
                    }
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


BoxDecoration getInnerTileBoxDecoration(TutorialState tutorialState, ColorPalette palette, int widgetId, Animation animation) {
  final Map<String, dynamic> stepDetails = tutorialState.tutorialStateHistory2.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
  final Map<String,dynamic> tileObject = stepDetails['tileState'].firstWhere((element) => element['index'] == widgetId);
  BoxDecoration res = BoxDecoration(
    color: palette.screenBackgroundColor
  );
  if (stepDetails['targets'].contains(widgetId)) {
    if (tileObject['letter'] != "") {
      if (tileObject['alive']) {
        if (tileObject['active']) {
          res = BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            color: palette.screenBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: palette.screenBackgroundColor, blurRadius: 2, spreadRadius: 2,
              )
            ]
          );          
        } else {
          res = BoxDecoration(
            color: palette.tileBgColor
          );
        }
      } else {
        res = BoxDecoration(
          color: palette.optionButtonBgColor2
        );        
      }
    } else {
      res = BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        color: palette.screenBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: palette.screenBackgroundColor, blurRadius: 2, spreadRadius: 2,
          )
        ]
      );
    }   
  } else {
      if (tileObject['alive']) {
        if (tileObject['letter'] != "") {
          res = BoxDecoration(
            color: palette.tileBgColor
          );
        } else {
          res = BoxDecoration(
            color: palette.screenBackgroundColor
          );
        }   
      } else {
        res = BoxDecoration(
          color: palette.optionButtonBgColor2
        );        
      }    
  }
  return res;
}
BoxShadow getBoxShadow(TutorialState tutorialState, ColorPalette palette, int widgetId, Animation animation) {
  final Map<String, dynamic> stepDetails = tutorialState.tutorialStateHistory2.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
  BoxShadow res = const BoxShadow(color: Colors.transparent, blurRadius: 0, spreadRadius: 0);
  if (stepDetails['targets'].contains(widgetId)) {
    res = BoxShadow(
      color: Color.fromRGBO(
        palette.tileBgColor.red,
        palette.tileBgColor.green,
        palette.tileBgColor.blue,
        (animation.value*0.5)
      ),
      blurRadius: 10.0 * (animation.value*0.6),
      spreadRadius: 10.0 * (animation.value*0.6),
    );
    
  }
  return res;
}
Color colorTileBg(Map<String, dynamic> tileObject, ColorPalette palette,) {
  late Color color = const Color.fromRGBO(0, 0, 0, 0);
  if (tileObject["letter"] == "") {
    color = Colors.transparent;
  } else {
    if (!tileObject['alive']) {
      color = palette.optionButtonBgColor2;
    } else {
      if (tileObject['active']) {
        color = Colors.transparent;
      } else {
        color = palette.tileBgColor;
      }
    }
  }
  return color;
}


Color getBorderColor(Map<String, dynamic> tileObject, ColorPalette palette, Animation animation, Map<String,dynamic> currentStep) {
  final bool active = currentStep['targets'].contains(tileObject['index']);
  late Color res = Colors.transparent;
  if (active) {
    // if (tileObject['alive']) {
      res = Color.fromRGBO(
        palette.focusedTutorialTile.red,
        palette.focusedTutorialTile.green,
        palette.focusedTutorialTile.blue,
        animation.value  
      );
  } else {
    if (tileObject["letter"] == "") {
      res = Color.fromRGBO(
        palette.tileBgColor.red,
        palette.tileBgColor.green,
        palette.tileBgColor.blue,
        0.5 
      );
    } else {
      res = const Color.fromRGBO(0, 0, 0, 0);
    }      
  }
  return res;
}
Color getTextColor(Map<String, dynamic> tileObject,ColorPalette palette, Animation animation ) {
  Color res = palette.tileTextColor;
  if (!tileObject['alive']) {
      res = Colors.transparent;
  } else {
    if (tileObject['active']) {
      res = Color.fromRGBO(
        palette.textColor2.red,
        palette.textColor2.green,
        palette.textColor2.blue,
        animation.value  
      );      
    } 
  }
  return res;
}

List<Shadow> getTextShadow(Map<String, dynamic> tileObject,ColorPalette palette, Animation animation ) {
  late List<Shadow> res = const  [Shadow(offset: Offset.zero, blurRadius: 0, color: Colors.transparent)];

  if (tileObject['active']) {
    Color color = Color.fromRGBO(
      palette.textColor2.red,
      palette.textColor2.green,
      palette.textColor2.blue,
      animation.value*1
    );
    res = <Shadow>[
      Shadow(offset: const Offset(0.0,0.0), blurRadius: 10, color: color),
    ];
  }
  return res;
}
