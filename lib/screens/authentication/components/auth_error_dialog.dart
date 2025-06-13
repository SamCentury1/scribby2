import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class AuthErrorDialog extends StatelessWidget {
  final String errorTitle;
  final List<String> errors;
  const AuthErrorDialog({
    super.key,
    required this.errorTitle,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen:false);
    late SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    late double scalor = Helpers().getScalor(settings);
    final double sizeFactor = scalor;
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0 * sizeFactor)),
          color: palette.dialogBg1
        ),
        child: Padding(
          padding:  EdgeInsets.fromLTRB(22.0 * sizeFactor,8.0 * sizeFactor,22.0 *sizeFactor, 8.0 * sizeFactor,),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  errorTitle,
                  style: TextStyle(
                    color: palette.text1,
                    fontSize: 32 * sizeFactor,
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0 * sizeFactor),
                child: Divider(thickness: 1.0 *sizeFactor, color: palette.text1,),
              ),

              Column(
                children: displayErrors(errors, palette, sizeFactor),
              ),              

              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(8.0 * sizeFactor),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: palette.text2
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12.0 * sizeFactor, 4.0 * sizeFactor, 12.0 * sizeFactor, 4.0 * sizeFactor),
                        child: Text(
                          "Okay",
                          style: TextStyle(
                            color: palette.text1,
                            fontSize: 22 * sizeFactor,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}

List<Widget> displayErrors(List<String> errors, ColorPalette palette, double scalor) {
  List<Widget> errorTextWidgets = [];
  for (String error in errors) {
    late Widget errorTextWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,      
      children: [
        Text(
          error,
          style: TextStyle(
            color: palette.text1,
            fontSize: 22 * scalor,
            fontWeight: FontWeight.w300
          ),
          textAlign: TextAlign.start,
        ),
        Divider(thickness: 0.5 * scalor, color: palette.dialogBg1 ,)
      ],
    );
    errorTextWidgets.add(errorTextWidget);
  }
  return errorTextWidgets;
}