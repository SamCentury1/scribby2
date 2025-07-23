import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class HomeScreenDrawerButton extends StatelessWidget {
  final IconData icon;
  final String body;
  final Function()? onPress;
  const HomeScreenDrawerButton({
    super.key,
    required this.icon,
    required this.body,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context);
    return Consumer<SettingsController>(
      builder: (context,settings,child) {
        final double scalor = Helpers().getScalor(settings);

        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: palette.text1,
                width: 1.0 * scalor,
              ),
              bottom: BorderSide(
                color: palette.text1,
                width: 1.0 * scalor,
              ),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              leading: Icon(
                icon,
                color: palette.text1,
                size: 24 * scalor,
              ),
              title: Text(
                body,
                style: palette.mainAppFont(
                  textStyle: TextStyle(
                    color: palette.text1,
                    fontSize: 24 * scalor,
                  ),
                ),
              ),
              splashColor: palette.widget1,
              tileColor: Colors.transparent,
              onTap: onPress,
            ),
          ),
        );


        // return SizedBox(
        //   height: 80*scalor,
        //   width: double.infinity,
        //   child: Padding(
        //     padding: EdgeInsets.all(12.0*scalor),
        
        //     child: ElevatedButton(
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: palette.widget2,
        //         foregroundColor: palette.text2,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.all(Radius.circular(8*scalor))
        //         )
        //       ),
        //       onPressed: onPress,

        //       child: Text(
        //         body,
        //         style: GoogleFonts.lilitaOne(
        //           // color: Colors.white,
        //           fontSize: 36*scalor
        //         ),)
        //     ),                                
        //   )
        // );
      }
    );
  }
}