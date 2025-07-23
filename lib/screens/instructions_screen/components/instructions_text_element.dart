import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';

class InstructionsTextElement extends StatelessWidget {
  final bool isLabel;
  final String body;
  final double scalor;
  const InstructionsTextElement({
    super.key,
    required this.isLabel,
    required this.body,
    required this.scalor
  });


  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context,listen:false);
  
    late TextStyle textStyle = TextStyle(
      color: palette.text1,
      fontWeight: isLabel ? FontWeight.bold : FontWeight.normal,
      fontSize: isLabel ? 26 * scalor : 18 * scalor,
    );

    return Padding(
      padding: EdgeInsets.all(8.0*scalor),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(body,style: textStyle)
      ),
    );
  }
}