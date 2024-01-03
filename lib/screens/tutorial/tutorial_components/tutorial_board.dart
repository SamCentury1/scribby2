import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisExtent: tileSide,
              ),
              children: List<Widget>.generate(36, (int i) {
                return Builder(builder: (BuildContext context) {
                  return tutorialTile(tutorialState, palette, i, tileSide);
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

Widget tutorialTile(TutorialState tutorialState, ColorPalette palette,
    int index, double dimension) {
  // late double dimension2 = MediaQuery.of(context).size.width * 0.8;
  final Map<String, dynamic> tileState =
      TutorialHelpers().tutorialTileState(index, tutorialState);
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Container(
      // color: Colors.blueAccent,
      decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: palette.tileBgColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: Center(
          child: Text(
        tileState['letter'],
        style: TextStyle(fontSize: 32, color: palette.tileBgColor),
      )),
    ),
  );
}
