import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/functions/game_logic_2.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/game_over_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class GameQuitScreen extends StatefulWidget {
  const GameQuitScreen({super.key});

  @override
  State<GameQuitScreen> createState() => _GameQuitScreenState();
}

class _GameQuitScreenState extends State<GameQuitScreen>
    with TickerProviderStateMixin {
  late bool isPause;

  Key? get key => null;

  @override
  void initState() {
    super.initState();
  }

  VoidCallback quitGameAction(GamePlayState gamePlayState, AnimationState animationState, BuildContext context, SettingsController settings) {
    return () {
      GameLogic().executeGameOver(gamePlayState, context);

      gamePlayState.countDownController.pause();
      gamePlayState.setDidUserQuitGame(true);
      animationState.setShouldRunTimerAnimation(false);
      
      
      gamePlayState.setIsGameOver(true);

      
      Future.delayed(const Duration(milliseconds: 1500), () {
        // animationState.setShouldRunGameEndedAnimation(true);
       gamePlayState.endGame();
       gamePlayState.setTileState(settings.initialTileState.value as List<Map<String,dynamic>>);
       if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const GameOverScreen())
          );        
       }
      });       
    };
  }

  VoidCallback restartGameAction(GamePlayState gamePlayState, BuildContext context, SettingsController settings) {
    return () {
      gamePlayState.restartGame();
      Helpers().getStates(gamePlayState, settings);
      // GameLogic().clearTilesFromBoard(gamePlayState);
      Navigator.of(context).pop();
    };
    
  }

  @override
  Widget build(BuildContext context) {

    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);

    late SettingsController settings = Provider.of<SettingsController>(context, listen: false);

    late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);

    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);

    late Random _rand = Random();
    final int randomShade1 = _rand.nextInt(5);
    final int randomAngle1 = _rand.nextInt(5);
    final int randomShade2 = _rand.nextInt(5);
    final int randomAngle2 = _rand.nextInt(5); 

    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return DialogWidget(
          key,
          Helpers().translateText(gamePlayState.currentLanguage,"Quit Game",settingsState),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                const Expanded(flex: 2, child: SizedBox(),),
                labelItem(gamePlayState, palette, gamePlayState.tileSize*0.35, "Would you like to leave?",settingsState),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ControlDialogWidget(
                          gamePlayState: gamePlayState,
                          palette: palette,
                          settingsState: settingsState,
                          titleText:  "Quit Game",
                          promptText: "Are you sure you want to quit the game?",
                          promptConfirmText: "Yes",
                          action: quitGameAction(gamePlayState, animationState, context, settings),
                        );
                      }
                    );
                  },  
                  child: Container(
                    width: double.infinity,
                    height: gamePlayState.tileSize*0.8,
                    decoration: Decorations().getTileDecoration(gamePlayState.tileSize, palette, randomShade1, randomAngle1),
                    child: Center(
                      child: Text(
                        Helpers().translateText(gamePlayState.currentLanguage,"Exit",settingsState),
                        style: TextStyle(
                          fontSize:gamePlayState.tileSize*0.35,
                          color: palette.fullTileTextColor
                        ),
                      ),
                    ),
                  ),
                ),     
                const Expanded(flex: 1, child: SizedBox(),),

                labelItem(gamePlayState, palette, gamePlayState.tileSize*0.35, "Or simply restart?",settingsState),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ControlDialogWidget(
                          gamePlayState: gamePlayState,
                          palette: palette,
                          settingsState: settingsState,
                          titleText:  "Restart Game",
                          promptText: "Are you sure you want to restart the game?",
                          promptConfirmText: "Yes",
                          action: restartGameAction(gamePlayState, context, settings),
                        );                        
                      }
                    );
                  },  
                  child: Container(
                    width: double.infinity,
                    height: gamePlayState.tileSize*0.8,
                    decoration: Decorations().getTileDecoration(gamePlayState.tileSize, palette, randomShade2, randomAngle2),
                    child: Center(
                      child: Text(
                        Helpers().translateText(gamePlayState.currentLanguage,"Restart",settingsState),
                        style: TextStyle(
                          fontSize:gamePlayState.tileSize*0.35,
                          color: palette.fullTileTextColor
                        ),
                      ),
                    ),
                  ),
                ),                
                    
                const Expanded(flex: 3, child: SizedBox(),),                   
              ],
            ),
          ),
          null
        );
      },
    );
  }
}

ButtonStyle buttonStyle(ColorPalette palette, double tileSize,) {
  return ElevatedButton.styleFrom(
    backgroundColor: palette.optionButtonBgColor2,
    foregroundColor: palette.textColor2,
    shadowColor:const Color.fromRGBO(123, 123, 123, 0.7),
    elevation: 3.0,
    minimumSize: Size(double.infinity, (tileSize*0.8)),
    padding: const EdgeInsets.all(4.0),
    textStyle: TextStyle(
      fontSize: tileSize*0.35,
      color: palette.textColor2
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.2)),
    ),
  ); 
}



Widget labelItem(GamePlayState gamePlayState, ColorPalette palette, double fontSize, String textBody, SettingsState settingsState) {
  return Text(
    Helpers().translateText(gamePlayState.currentLanguage,textBody,settingsState),
    style: TextStyle(
      color: palette.textColor2,
      fontSize: fontSize
    ),
  ); 
}


class ControlDialogWidget extends StatelessWidget {
  final GamePlayState gamePlayState;
  final ColorPalette palette;
  final SettingsState settingsState;
  final String titleText;
  final String promptText;
  final String promptConfirmText;
  final VoidCallback action;


  const ControlDialogWidget({
    super.key,
    required this.gamePlayState,
    required this.palette,
    required this.settingsState,
    required this.titleText,
    required this.promptText,
    required this.promptConfirmText,
    required this.action,

  });

  @override
  Widget build(BuildContext context) {
    final AudioController audioController =Provider.of<AudioController>(context, listen: false);        
    return Dialog(
      backgroundColor: Colors.black,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(gamePlayState.tileSize*0.20)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              palette.screenGradientBackgroundColor1,
              palette.screenGradientBackgroundColor2,
            ]
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Container(
              height: gamePlayState.tileSize*1,
              child: Center(
                child: Text(
                  Helpers().translateText(gamePlayState.currentLanguage,titleText,settingsState),
                  style: TextStyle(
                    color: palette.textColor2,
                    fontSize: gamePlayState.tileSize*0.4
                  ),          
                ),
              ),
            ),
            Container(
              width: gamePlayState.tileSize*5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:gamePlayState.tileSize*0.1),
                child: Divider(
                  color: palette.textColor3,
                  height: gamePlayState.tileSize*0.02,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                gamePlayState.tileSize*0.15),
              child: SizedBox(
                child: Text(
                  Helpers().translateText(gamePlayState.currentLanguage,promptText,settingsState),
                  style: TextStyle(
                    fontSize: (gamePlayState.tileSize*0.30), 
                    color: palette.textColor2
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(child: SizedBox(),),
                TextButton(
                  onPressed: () {
                    audioController.playSfx(SfxType.optionSelected);
                    action();
                  },
                  child: Text(
                    Helpers().translateText(gamePlayState.currentLanguage,promptConfirmText,settingsState),
                    style:TextStyle(
                      color: palette.textColor2,
                      fontSize: gamePlayState.tileSize*0.3
                    ),
                  )
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    Helpers().translateText(gamePlayState.currentLanguage,"Cancel",settingsState),
                    style: TextStyle(
                      color: palette.textColor2,
                      fontSize: gamePlayState.tileSize*0.3
                    ),
                  )
                ),                              
              
              ],
            )
          ]
        ),
        
      ),
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(gamePlayState.tileSize*0.25))
      ),
    );
  }
}