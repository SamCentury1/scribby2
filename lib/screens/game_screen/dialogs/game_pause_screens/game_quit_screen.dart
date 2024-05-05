import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';

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

  VoidCallback quitGameAction(GamePlayState gamePlayState, BuildContext context) {
    return () {
      GameLogic().executeGameOver(gamePlayState, context);
    };
  }

  VoidCallback restartGameAction(GamePlayState gamePlayState, BuildContext context, SettingsController settings) {
    return () {
      gamePlayState.restartGame();
      Helpers().getStates(gamePlayState, settings);
      GameLogic().clearTilesFromBoard(gamePlayState);
      Navigator.of(context).pop();
    };
    
  }

  @override
  Widget build(BuildContext context) {

    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);

    late SettingsController settings = Provider.of<SettingsController>(context, listen: false);

    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);



    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return DialogWidget(
          key,
          Helpers().translateText(gamePlayState.currentLanguage,"Quit Game",),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                const Expanded(flex: 2, child: SizedBox(),),
                labelItem(gamePlayState, palette, settingsState, "Would you like to leave?"),
                TextButton(
                  style: buttonStyle(palette,settingsState),
                  onPressed: () {
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
                          action: quitGameAction(gamePlayState, context),
                        );
                      }
                    );
                  },              
                  child: Text(
                    Helpers().translateText(gamePlayState.currentLanguage,"Exit",)
                  ),
                ),
                    
                const Expanded(flex: 1, child: SizedBox(),),

                labelItem(gamePlayState, palette, settingsState, "Or simply restart?"),
                
                TextButton(
                  style: buttonStyle(palette,settingsState),         
                  onPressed: () {
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
                  child: Text(
                    Helpers().translateText(gamePlayState.currentLanguage,"Restart"),
                  )
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

ButtonStyle buttonStyle(ColorPalette palette, SettingsState settingsState,) {
  return ElevatedButton.styleFrom(
    backgroundColor: palette.optionButtonBgColor2,
    foregroundColor: palette.textColor2,
    shadowColor:const Color.fromRGBO(123, 123, 123, 0.7),
    elevation: 3.0,
    minimumSize: Size(double.infinity, (50 * settingsState.sizeFactor)),
    padding: const EdgeInsets.all(4.0),
    textStyle: TextStyle(
      fontSize: (22 * settingsState.sizeFactor),
      color: palette.textColor2
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  ); 
}



Widget labelItem(GamePlayState gamePlayState, ColorPalette palette, SettingsState settingsState, String textBody) {
  return Text(
    Helpers().translateText(gamePlayState.currentLanguage,textBody,),
    style: TextStyle(
      color: palette.textColor2,
      fontSize: (22 * settingsState.sizeFactor)
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
    return AlertDialog(
      backgroundColor: palette.optionButtonBgColor,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Helpers().translateText(gamePlayState.currentLanguage,titleText,),
            style: TextStyle(
              color: palette.textColor2
            ),          
          ),
          Divider(
            color: palette.textColor3,
            height: 1*settingsState.sizeFactor,
          )            
        ],
      ),
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0*settingsState.sizeFactor))
      ),
      titlePadding: EdgeInsets.fromLTRB(
        18.0*settingsState.sizeFactor,
        12.0*settingsState.sizeFactor,
        18.0*settingsState.sizeFactor,
        12.0*settingsState.sizeFactor,
      ),
      
      contentPadding: EdgeInsets.fromLTRB(
        18.0*settingsState.sizeFactor, 
        0.0*settingsState.sizeFactor, 
        18.0*settingsState.sizeFactor, 
        5.0*settingsState.sizeFactor
        
          
      ),
      content: SizedBox(
        child: Text(
          Helpers().translateText(gamePlayState.currentLanguage,promptText,),
          style: TextStyle(
            fontSize: (20 * settingsState.sizeFactor), 
            color: palette.textColor2
          ),
        ),
      ),
      actionsPadding: EdgeInsets.fromLTRB(
        18.0*settingsState.sizeFactor,
        4.0*settingsState.sizeFactor,
        18.0*settingsState.sizeFactor,
        4.0*settingsState.sizeFactor
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            audioController.playSfx(SfxType.optionSelected);
            action();
          },
          child: Text(
            Helpers().translateText(gamePlayState.currentLanguage,promptConfirmText,),
            style:TextStyle(
              color: palette.textColor2
            ),
          )
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            Helpers().translateText(gamePlayState.currentLanguage,"Cancel",),
            style: TextStyle(
              color: palette.textColor2
            ),
          )
        ),
      ],
    );
  }
}