import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
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
        palette.focusedTutorialTile.red,
        palette.focusedTutorialTile.green,
        palette.focusedTutorialTile.blue,
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


  // BoxShadow getBoxShadow(TutorialState tutorialState, ColorPalette palette, String widgetId, Animation animation) {
  //   final Map<String, dynamic> stepDetails = tutorialState.tutorialStateHistory2.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
  //   BoxShadow res = const BoxShadow(color: Colors.transparent, blurRadius: 0, spreadRadius: 0);
  //   if (stepDetails['targets'].contains(widgetId)) {
  //     res = BoxShadow(
  //       color: Color.fromRGBO(
  //         palette.textColor2.red,
  //         palette.textColor2.green,
  //         palette.textColor2.blue,
  //         (animation.value*0.5)
  //       ),
  //       blurRadius: 4.0 * (animation.value*0.6),
  //       spreadRadius: 4.0 * (animation.value*0.6),
  //     );
      
  //   }
  //   return res;
  // }

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


  Color colorTileBg(Map<String, dynamic> tileObject, ColorPalette palette,) {
    late Color color = const Color.fromRGBO(0, 0, 0, 0);
    if (tileObject["body"] == "") {
      color = Colors.transparent;
    } else {
      color = palette.tileBgColor;
    }
    return color;
  }



  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
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
                        width: 3*settingsState.sizeFactor,
                    ), // colorTileBorder(tileObject, palette), width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      TutorialHelpers().getBoxShadow(currentStep, palette, widgetId, animation),

                    ],                    
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.0*settingsState.sizeFactor),
                    child: Container(
                      decoration: getInnerTileBoxDecoration(tutorialState, palette, widgetId, animation),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: tileObject["body"] == "" ? 0 : 22*settingsState.sizeFactor,
                            color: tileObject["body"] == ""
                                ? Colors.transparent
                                : palette.tileTextColor,
                          ),
                          child: Text(
                            tileObject["body"],
                            style: TextStyle(
                              fontSize: 22*settingsState.sizeFactor
                            ),
                          ),
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
