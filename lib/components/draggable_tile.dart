import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class DraggableTile extends StatelessWidget {
  final Map<String,dynamic> tileState;
  const DraggableTile({
    super.key,
    required this.tileState
  });



  Color colorTileBg(Map<String,dynamic> tileObject, ColorPalette palette) {
    late Color color = const Color.fromRGBO(0, 0, 0, 0);
    if (tileObject["body"] == "") {
      color = Colors.transparent;
    } else {
      color = palette.tileBgColor;
    }
    return color;
  }

  Color colorTileBorder(Map<String,dynamic> tileObject, ColorPalette palette) {
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
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              width:  50,
              height: 50,
              decoration: BoxDecoration(
                color: colorTileBg(tileState, palette),
                border: Border.all(
                  color: colorTileBorder(tileState, palette),
                  width: 3
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: tileState["body"] == "" ? 0 : 26 ,
                    color: tileState["body"] == "" ?  Colors.transparent : const Color.fromRGBO(0, 0, 0, 1),
                  ),
                  child: Text(
                    tileState["body"]
                  ),
                ),
              )            
            ),
          ),
        );
      },
    );
  }
}