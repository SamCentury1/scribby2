import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';

class FeatureDescriptionCard extends StatelessWidget {
  final double drawerWidth;
  final double scalor;
  final String label;
  final String body;
  final Widget iconImage;
  const FeatureDescriptionCard({
    super.key,
    required this.drawerWidth,
    required this.scalor,
    required this.label,
    required this.body,
    required this.iconImage,
  });

  @override
  Widget build(BuildContext context) {

    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false); 

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: drawerWidth/4,
          height: drawerWidth/4,
          child: iconImage,
        ),
      ),

      title: Text(
        label,
        style: TextStyle(
          color: palette.text1, 
          fontWeight: FontWeight.bold,
          fontSize: 20 * scalor
        ),
      ),
      subtitle: Text(
        body, 
        style: TextStyle(
          color: palette.text1,
          fontSize: 16 * scalor
        ),
      ),
    );
  }
}
