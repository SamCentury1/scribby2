import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: false);

    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Container(
                width: double.infinity,
                height: double.infinity,
                color: palette.optionButtonBgColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 32,
                          color: palette.textColor2,
                        ),
                      ),
                      Divider(
                        color: palette.textColor2,
                        height: 2,
                      )
                    ],
                  ),
                ))),
        Expanded(
            flex: 5,
            child: Container(
                width: double.infinity,
                color: palette.optionButtonBgColor,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: content))),
        button ?? const SizedBox()
      ],
    );
  }
}
