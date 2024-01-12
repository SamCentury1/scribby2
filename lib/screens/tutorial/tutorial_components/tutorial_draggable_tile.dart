import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TutorialDraggableTile extends StatelessWidget {
  final Map<String, dynamic> tileState;
  final double tileSide;
  const TutorialDraggableTile({
    super.key, 
    required this.tileState,
    required this.tileSide
  });

  Color colorTileBg(Map<String, dynamic> tileObject, ColorPalette palette) {
    late Color color = const Color.fromRGBO(0, 0, 0, 0);
    if (tileObject["body"] == "") {
      color = Colors.transparent;
    } else {
      color = palette.tileBgColor;
    }
    return color;
  }

  Color colorTileBorder(Map<String, dynamic> tileObject, ColorPalette palette) {
    late Color color = const Color.fromRGBO(0, 0, 0, 0);

    if (tileObject["body"] == "") {
      color = palette.tileBgColor;
    } else {
      color = const Color.fromRGBO(0, 0, 0, 0);
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {
        return Container(
            width: tileSide,
            height: tileSide,
            decoration: BoxDecoration(
              color: colorTileBg(tileState, palette),
              border: Border.all(
                  color: colorTileBorder(tileState, palette), width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: tileState["body"] == "" ? 0 : 26,
                  color: tileState["body"] == ""
                      ? Colors.transparent
                      : palette.tileTextColor,
                ),
                child: Text(tileState["body"]),
              ),
            ));
      },
    );
  }
}
