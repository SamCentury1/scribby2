import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialBoard extends StatefulWidget {
  const TutorialBoard({super.key});

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
    late double boardWidth = MediaQuery.of(context).size.width * 0.9;
    late double tileSide = boardWidth / 6;

    late ColorPalette palette = Provider.of(context, listen: false);

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
                return Builder(builder: (BuildContext context) {
                  return TutorialTile(
                      // tutorialState: tutorialState,
                      // palette: palette,
                      index: i,
                      tileSide: tileSide);
                });
              }),
            ),
          ),
          Container(
            width: double.infinity,
            height: tileSide,
            color: Colors.purple,
          )
        ],
      );
    });
  }
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
  const TutorialTile(
      {super.key,
      // required this.tutorialState,
      // required this.palette,
      required this.index,
      required this.tileSide});

  @override
  State<TutorialTile> createState() => _TutorialTileState();
}

class _TutorialTileState extends State<TutorialTile>
    with TickerProviderStateMixin {
  late AnimationState animationState;

  late AnimationController _tileGlowController;
  late Animation<double> _tileGlowAnimation;
  late ColorPalette palette;

  @override
  void initState() {
    super.initState();
    animationState = Provider.of<AnimationState>(context, listen: false);
    // palette = Provider.of<ColorPalette>(context, listen: true);

    initializeAnimations();
  }

  void initializeAnimations() {
    // late ColorPalette palette = Provider.of<ColorPalette>(context, listen: true);

    _tileGlowController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));

    final List<TweenSequenceItem<double>> glowSequence = [
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 1.0,
            end: 0.3,
          ),
          weight: 0.5),
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 0.3,
            end: 1.0,
          ),
          weight: 0.5),
    ];
    _tileGlowAnimation =
        TweenSequence<double>(glowSequence).animate(_tileGlowController);

    _tileGlowController.forward();
    _tileGlowController.addListener(() {
      if (_tileGlowController.isCompleted) {
        _tileGlowController.repeat();
      }
    });
  }

  void reactToInput(
      TutorialState tutorialState, AnimationState animationState) {
    TutorialHelpers()
        .updateTutorialTileState(tutorialState, widget.index, animationState);

    late Map<String, dynamic> stepDetails = tutorialDetails
        .firstWhere((elem) => elem['step'] == tutorialState.sequenceStep);

    final snackBar = SnackBar(
      content: Text(stepDetails['text']),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // print("pressed tile: $object");
  }

  Color colorTileBorder(
      Map<String, dynamic> tileObject,
      TutorialState tutorialState,
      ColorPalette palette,
      Animation _tileGlowAnimation) {
    Map<String, dynamic> stepDetails = tutorialDetails
        .firstWhere((element) => element['step'] == tutorialState.sequenceStep);
    Color res = Colors.transparent;

    if (tileObject['index'] == stepDetails['target']) {
      // res = palette.focusedTutorialTile;
      int red = palette.focusedTutorialTile.red;
      int green = palette.focusedTutorialTile.green;
      int blue = palette.focusedTutorialTile.blue;
      res = Color.fromRGBO(red, green, blue, _tileGlowAnimation.value);
      // res = _tileGlowAnimation.value;
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

  Color getBoxShadow(Map<String, dynamic> tileObject,
      TutorialState tutorialState, ColorPalette palette) {
    Map<String, dynamic> stepDetails = tutorialDetails
        .firstWhere((element) => element['step'] == tutorialState.sequenceStep);
    Color res = Colors.transparent;

    // print(stepDetails);
    if (tileObject['index'] == stepDetails['target']) {
      if (tileObject['letter'] == "") {
        res = palette.focusedTutorialTile;
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
    late ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: true);

    late TutorialState tutorialState =
        Provider.of<TutorialState>(context, listen: false);

    late Map<String, dynamic> tileState =
        TutorialHelpers().tutorialTileState(widget.index, tutorialState);

    late AnimationState animationState =
        Provider.of<AnimationState>(context, listen: false);

    late Map<String, dynamic> currentStep = tutorialDetails
        .firstWhere((element) => element['step'] == tutorialState.sequenceStep);
    // late Map<String,dynamic> currentTile = TutorialHelpers().tutorialTileState(widget.index, tutorialState);

    return GestureDetector(
      onTapUp: (details) {
        if (currentStep['target'] == widget.index) {
          reactToInput(tutorialState, animationState);
        } else {}
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: AnimatedBuilder(
          animation: _tileGlowAnimation,
          builder: (context, child) {
            return Container(
              // color: Colors.blueAccent,
              decoration: BoxDecoration(
                  color: palette.screenBackgroundColor,
                  border: Border.all(
                    width: 3,
                    color: colorTileBorder(
                        tileState, tutorialState, palette, _tileGlowAnimation),
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
                style: TextStyle(fontSize: 32, color: palette.tileBgColor),
              )),
            );
          },
        ),
      ),
    );
  }
}
