import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class AuthProviderTile extends StatelessWidget {
  final ColorPalette palette;
  final Function()? onTap;
  final IconData iconData;
  const AuthProviderTile({
    super.key,
    required this.palette,
    required this.onTap,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    late SettingsController settings = Provider.of<SettingsController>(context, listen:false);
    final double scalor = Helpers().getScalor(settings);    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80 * scalor,
        height: 80 * scalor,
        
        // decoration: BoxDecoration(
        //   color: palette.widget1,
        //   gradient: LinearGradient(
        //     colors: [
        //       palette.widget1,
        //       palette.widget2
        //     ],
        //     begin: Alignment.topLeft,
        //     end:Alignment.bottomRight 
        //   ),
        //   borderRadius: BorderRadius.all(Radius.circular(12.0 * scalor))
        // ),

        
        child: IconButton(
          icon: Icon(iconData, size: 50*scalor,),
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 220, 220, 223),
            backgroundColor: const Color.fromARGB(255, 44, 34, 185),
            textStyle: GoogleFonts.lilitaOne(
              fontSize: 24*scalor
            ),                                    
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0 * scalor)),
            ),
            minimumSize: Size(80.0*scalor,80.0*scalor)
          ),           
          // child: Icon(iconData, size: 50 * scalor, color: palette.text1,)
        ),
      ),
    );
  }
}