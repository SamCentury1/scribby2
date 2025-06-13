import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap;
  final String body;
  final ColorPalette palette;
  const LoginButton({
    super.key, 
    required this.onTap, 
    required this.body,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    late SettingsController settings = Provider.of<SettingsController>(context, listen:false);
    final double scalor = Helpers().getScalor(settings);
        
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.0*scalor),
        margin: EdgeInsets.symmetric(horizontal: 25.0*scalor),
        decoration: BoxDecoration(
          color: palette.widget1,
          borderRadius: BorderRadius.circular(8.0*scalor)
        ),
        child: Center(
          child: Text(
            body,
            style: TextStyle(
              color: palette.text1,
              fontWeight: FontWeight.w400,
              fontSize: 18.0 * scalor
            ),
          ),
        ),
      ),
    );
  }
}