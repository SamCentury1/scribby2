import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class DialogWidget extends StatelessWidget {
  final String title;
  final Widget content;
  final Widget? button;
  // final ButtonStyle button;
  // final VoidCallback? onSelected;
  const DialogWidget(
    Key? key,
    this.title,
    this.content,
    this.button,
    // {this.onSelected}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);

    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                  // width: double.infinity,
                  // height: double.infinity,
                  // color: palette.optionButtonBgColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title,
                          // style: Helpers().customTextStyle(palette.textColor2,28*settingsState.sizeFactor),
                          style: Helpers().customTextStyle(palette.textColor2,gamePlayState.tileSize*0.5),
                          // style: TextStyle(
                          //   fontSize: (32*settingsState.sizeFactor),
                          //   color: palette.textColor2,
                          // ),
                        ),
                      ),
                      Divider(
                        color: palette.textColor2,
                        height: 2,
                      )
                    ],
                  )),
            )),
        Expanded(
            flex: 5,
            child: Container(
                width: double.infinity,
                // color: palette.optionButtonBgColor,
                child: content)),
        button ?? const SizedBox()
      ],
    );
  }
}
