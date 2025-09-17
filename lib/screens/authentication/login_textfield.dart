import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class LoginTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final ColorPalette palette;
  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    SettingsController settings = Provider.of<SettingsController>(context, listen: false);

    final double scalor = Helpers().getScalor(settings);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0*scalor),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: palette.text1),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0 * scalor),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: palette.inputFieldBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: palette.inputFieldBorderColor),
          ),
          focusColor: palette.inputFieldTextColor,
          fillColor: palette.inputFieldBgColor,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: palette.text1,
            fontSize: 18 * scalor,
          )
        ),
      ),
    );
  }
}