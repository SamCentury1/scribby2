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
        
    return ElevatedButton(
      onPressed: onTap,
      
      child: Container(
        padding: EdgeInsets.all(15.0*scalor),
        margin: EdgeInsets.symmetric(horizontal: 25.0*scalor),
        decoration: BoxDecoration(
        //   color: palette.widget1,
          borderRadius: BorderRadius.circular(8.0*scalor)
        ),
        child: Center(
          child: Text(
            body,
          ),
        ),



      ),

      style: ElevatedButton.styleFrom(
        foregroundColor: palette.navigationButtonText2, //const Color.fromARGB(255, 220, 220, 223),
        backgroundColor: palette.navigationButtonBg2, //const Color.fromARGB(255, 44, 34, 185),
        // shadowColor: palette.widgetShadow1,

      
        textStyle: TextStyle(
          fontSize: 24*scalor
        ),                                    
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0 * scalor)),
        ),
      ),       
    );
  }
}