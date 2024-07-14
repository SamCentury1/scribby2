import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {

  late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
  late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
  late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              palette.screenGradientBackgroundColor1,
              palette.screenGradientBackgroundColor2
            ]
          )
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Helpers().translateText(gamePlayState.currentLanguage, "Sorry, an Internet connection is required when first using the app.", settingsState),
                  style: TextStyle(
                    color: palette.textColor2,
                    fontSize: 32,
                  ),
                ),
                SizedBox(height: 30,),
                Text(
                  Helpers().translateText(
                    gamePlayState.currentLanguage, 
                    "This is because - the app requires a dictionary which is imported from a cloud storage location", 
                    settingsState
                  ),
                  style: TextStyle(
                    color: palette.textColor2,
                    fontSize: 28,
                  ),                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}