import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TutorialDraggableTile extends StatelessWidget {
  final Map<String, dynamic> tileState;
  final double tileSide;
  final Animation animation;
  const TutorialDraggableTile({
    super.key, 
    required this.tileState,
    required this.tileSide,
    required this.animation,
  });

 

  Color getColor(Map<String, dynamic> tileObject, ColorPalette palette, Animation animation, Map<String,dynamic> currentStep) {
    final String reserveId = "reserve_${tileObject['id']}";
    final bool active = currentStep['targets'].contains(reserveId);
    late Color res = Colors.transparent;
    if (active) {
      res = Color.fromRGBO(
        palette.textColor2.red,
        palette.textColor2.green,
        palette.textColor2.blue,
        animation.value  
      );
    } else {
      if (tileObject["body"] == "") {
        res = Color.fromRGBO(
          palette.textColor3.red,
          palette.textColor3.green,
          palette.textColor3.blue,
          0.5 
        );
      } else {
        res = const Color.fromRGBO(0, 0, 0, 0);
      }      
    }
    return res;
  }


  // Color getBoxShadow(Map<String, dynamic> tileObject,TutorialState tutorialState, ColorPalette palette, String widgetId) {
  //   final Map<String, dynamic> stepDetails = tutorialState.tutorialStateHistory2.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
  //   Color res = Colors.transparent;

  //   // print(stepDetails);
  //   if (stepDetails['targets'].contains(widgetId)) {
  //     // if (tileObject['letter'] == "") {
  //       res = Color.fromRGBO(
  //         palette.focusedTutorialTile.red,
  //         palette.focusedTutorialTile.green,
  //         palette.focusedTutorialTile.blue,
  //         0.3
  //       );
  //     // } else {
  //     //   res = Colors.transparent;
  //     // }
  //   } else {
  //     res = Colors.transparent;
  //   }
  //   return res;
  // }

  BoxShadow getBoxShadow(TutorialState tutorialState, ColorPalette palette, String widgetId, Animation animation) {
    final Map<String, dynamic> stepDetails = tutorialState.tutorialStateHistory2.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
    BoxShadow res = const BoxShadow(color: Colors.transparent, blurRadius: 0, spreadRadius: 0);
    if (stepDetails['targets'].contains(widgetId)) {
      res = BoxShadow(
        color: Color.fromRGBO(
          palette.textColor2.red,
          palette.textColor2.green,
          palette.textColor2.blue,
          (animation.value*0.5)
        ),
        blurRadius: 4.0 * (animation.value*0.6),
        spreadRadius: 4.0 * (animation.value*0.6),
      );
      
    }
    return res;
  }

  BoxDecoration getInnerTileBoxDecoration(TutorialState tutorialState, ColorPalette palette, String widgetId, Animation animation) {
    final Map<String, dynamic> stepDetails = tutorialState.tutorialStateHistory2.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
    final Map<String,dynamic> reserveObject = stepDetails['reserves'].firstWhere((element) => element['id'] == int.parse(widgetId.split("_")[1]));
    BoxDecoration res = BoxDecoration(
      color: palette.screenBackgroundColor
    );

    if (stepDetails['targets'].contains(widgetId)) {
      if (reserveObject['body'] != "") {
        res = BoxDecoration(
          color: palette.tileBgColor
        );
      } else {
        res = BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: palette.screenBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: palette.screenBackgroundColor, blurRadius: 2, spreadRadius: 2,
            )
          ]
        );
      }   
    } else {
      if (reserveObject['body'] != "") {
        res = BoxDecoration(
          color: palette.tileBgColor
        );
      } 
    }
    return res;
  }
  // Color colorTileBorder(Map<String, dynamic> tileObject,Map<String, dynamic> stepDetails,ColorPalette palette,Animation animation) {
  //   // Map<String, dynamic> stepDetails = tutorialDetails.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
  //   final String reserveId = "reserve_${tileObject['id']}";
  //   // final int tileId = int.parse(tileObject['id'])
  //   // final bool active = stepDetails['targets'].contains(reserveId);
  //   Color res = Colors.transparent;
  //   if (stepDetails['targets'].contains(reserveId)) {
  //     int red = palette.focusedTutorialTile.red;
  //     int green = palette.focusedTutorialTile.green;
  //     int blue = palette.focusedTutorialTile.blue;
  //     res = Color.fromRGBO(red, green, blue, animation.value);
  //   } else {
  //     if (tileObject['letter'] == "") {
  //       int red = palette.tileBgColor.red;
  //       int green = palette.tileBgColor.green;
  //       int blue = palette.tileBgColor.blue;
  //       res = Color.fromRGBO(red, green, blue, 0.5);
  //     } else {
  //       if (!tileObject['alive']) {
  //         res = Colors.transparent;
  //       } else {
  //         res = palette.tileBgColor;
  //       }
  //     }
  //   }
  //   return res;
  // }  

  Color colorTileBg(Map<String, dynamic> tileObject, ColorPalette palette,) {
    late Color color = const Color.fromRGBO(0, 0, 0, 0);
    if (tileObject["body"] == "") {
      color = Colors.transparent;
    } else {
      color = palette.tileBgColor;
    }
    return color;
  }

  // Color colorTileBorder(Map<String, dynamic> tileObject, ColorPalette palette) {
  //   late Color color = const Color.fromRGBO(0, 0, 0, 0);

  //   if (tileObject["body"] == "") {
  //     color = palette.tileBgColor;
  //   } else {
  //     color = const Color.fromRGBO(0, 0, 0, 0);
  //   }
  //   return color;
  // }

  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    // final AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
    final int tileId = tileState['id']; 
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {
        final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
        final Map<String,dynamic> tileObject = currentStep['reserves'].firstWhere((element) => element['id'] == tileId);
        final widgetId = "reserve_${tileState['id']}";
        return GestureDetector(
          // onTapUp: (details) {
          //   if (currentStep['callbackTarget'] == widgetId) {
          //     // reactToInput(tutorialState, animationState);
          //     TutorialHelpers().reactToTileTap(tutorialState, animationState);
          //   } else {}
            
          // },
          child: AnimatedBuilder(
            animation: animation,
            builder: (context,child) {
              return Container(
                  width: tileSide,
                  height: tileSide,
                  decoration: BoxDecoration(
                    color: colorTileBg(tileObject, palette),
                    border: Border.all(
                        color: getColor(tileObject,palette, animation, currentStep),
                        // color: colorTileBorder(tileObject,currentStep,palette, animation ),
                        width: 3,
                    ), // colorTileBorder(tileObject, palette), width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      getBoxShadow(tutorialState, palette, widgetId, animation),
                      // BoxShadow(
                      //   // color: getBoxShadow(tileState, tutorialState, palette, widgetId),
                      //   spreadRadius: 3,
                      //   blurRadius: 4,
                      // ),
                    ],                    
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: getInnerTileBoxDecoration(tutorialState, palette, widgetId, animation),
                      // decoration: BoxDecoration(
                      //   borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      //   color: palette.screenBackgroundColor,
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: palette.screenBackgroundColor, blurRadius: 2, spreadRadius: 2,
                      //     )
                      //   ]
                      // ),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: tileObject["body"] == "" ? 0 : 26,
                            color: tileObject["body"] == ""
                                ? Colors.transparent
                                : palette.tileTextColor,
                          ),
                          child: Text(tileObject["body"]),
                        ),
                      ),
                    ),
                  ));
            },
          ),
        );
      },
    );
  }
}
