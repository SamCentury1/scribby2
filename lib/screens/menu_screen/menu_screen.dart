import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/components/scribby_logo_animation_2.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/instructions_screen.dart';
import 'package:scribby_flutter_v2/screens/leaderboards_screen/leaderboards_screen.dart';
import 'package:scribby_flutter_v2/screens/settings_screen/settings_screen.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/choose_language.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin{

  late bool isLoading = false;

  @override
  void initState() {
    super.initState();

  }
  void navigateToChooseLanguage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ChooseLanguage()));
  }

  Future<Map<String,dynamic>> getDataFromStorage() async {
    late Map<String,dynamic> res = {};
    return res;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
        late SettingsController settings = Provider.of<SettingsController>(context, listen: false);
        late AudioController audioController = Provider.of<AudioController>(context, listen: false);
        late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);

        return FutureBuilder(
          future: getDataFromStorage(),
          builder:(BuildContext context, AsyncSnapshot<Map<String,dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (snapshot.hasError ) {
              return const Center(child: Text("Error"),);
            } else {
      

              return  Consumer<SettingsState>(
                  builder: (context, settingsState, child) {

                    String language = settingsState.userData['parameters']['currentLanguage'];
                    final double screenWidth = settingsState.screenSizeData['width'];
                    final double screenHeight = settingsState.screenSizeData['height'];
                    final List<Map<String,dynamic>> decorationDetails = gamePlayState.decorationData;                         
                    return PopScope(
                      canPop: false,
                      child: SafeArea(
                        child: Scaffold(
                            body: Stack(
                              children: [
                                CustomPaint(size: Size(screenWidth, screenHeight), painter: CustomBackground(palette: palette)),
                              
                                Decorations().decorativeSquare(decorationDetails[0]),
                                Decorations().decorativeSquare(decorationDetails[1]),
                                Decorations().decorativeSquare(decorationDetails[2]),
                                Decorations().decorativeSquare(decorationDetails[3]),
                                Decorations().decorativeSquare(decorationDetails[4]),
                                Decorations().decorativeSquare(decorationDetails[5]),
                                Decorations().decorativeSquare(decorationDetails[6]),
                                Decorations().decorativeSquare(decorationDetails[7]),
                                Decorations().decorativeSquare(decorationDetails[8]),
                                Decorations().decorativeSquare(decorationDetails[9]),
                                Decorations().decorativeSquare(decorationDetails[10]),                                
                                Positioned.fill(
                                  child: Container(
                                    child: Column(
                                      children: [
                                                        
                                        const Expanded(
                                          flex: 2,  
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(flex: 1, child: SizedBox(),),
                                              Expanded(
                                                flex: 4,
                                                child: ScribbyLogoAnimation2()
                                              ),
                                            ],
                                          ),
                                        ),
                                                        
                                        Expanded(
                                          flex: 3,
                                          child: Center(
                                            child: Container(
                                              width: gamePlayState.tileSize*5,
                                              height: gamePlayState.tileSize*5,
                                              child: Wrap(
                                                alignment: WrapAlignment.spaceEvenly,
                                                runSpacing: gamePlayState.tileSize*0.5,
                                                children: [

                                                  MenuTileWidget(
                                                    index:0,
                                                    gamePlayState: gamePlayState, 
                                                    palette: palette, 
                                                    language: language,
                                                    body: Helpers().translateText(language, "New Game",settingsState),
                                                    
                                                    iconData: Icon(
                                                      Icons.emoji_events,
                                                      size: gamePlayState.tileSize*0.7,
                                                      color: palette.fullTileTextColor
                                                    ),
                                                    onPressed: () {  
                                                      audioController.playSfx(SfxType.optionSelected);
                                                      Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (context) => const GameScreen()
                                                        ),
                                                      );
                                                      Helpers().getStates(gamePlayState, settings,settingsState);         
                                                    },
                                                  ),

                                                  MenuTileWidget(
                                                    index:1,
                                                    gamePlayState: gamePlayState, 
                                                    palette: palette, 
                                                    language: language,
                                                    body: Helpers().translateText(language, "Leaderboards",settingsState),
                                                    iconData: Icon(
                                                      Icons.leaderboard,
                                                      size: gamePlayState.tileSize*0.7,
                                                      color: palette.fullTileTextColor
                                                    ),                                                    
                                                    onPressed: () {
                                                      audioController.playSfx(SfxType.optionSelected);
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LeaderboardsScreen()),
                                                      );
                                                    },
                                                  ),


                                                  MenuTileWidget(
                                                    index:2,
                                                    gamePlayState: gamePlayState, 
                                                    palette: palette, 
                                                    language: language,
                                                    body: Helpers().translateText(language, "Instructions",settingsState),
                                                    iconData: Icon(
                                                      Icons.notes,
                                                      size: gamePlayState.tileSize*0.7,
                                                      color: palette.fullTileTextColor
                                                    ),                                                    
                                                    onPressed: () {
                                                      audioController.playSfx(SfxType.optionSelected);
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const InstructionsScreen()),
                                                      );
                                                    },
                                                  ),


                                                  MenuTileWidget(
                                                    index:3,
                                                    gamePlayState: gamePlayState, 
                                                    palette: palette, 
                                                    language: language,
                                                    body: Helpers().translateText(language, "Settings",settingsState),
                                                    iconData: Icon(
                                                      Icons.settings,
                                                      size: gamePlayState.tileSize*0.7,
                                                      color: palette.fullTileTextColor
                                                    ),                                                    
                                                    onPressed: () {
                                                      audioController.playSfx(SfxType.optionSelected);
                                                                                        
                                                      Helpers().getStates(gamePlayState, settings,settingsState);
                                                                                        
                                                      bool darkMode = (settings.userData.value as Map<String, dynamic>)['parameters']['darkMode'];
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) => SettingsScreen(darkMode: darkMode),
                                                        ),
                                                      );
                                                    },
                                                  ),                                                                                                                                                                            
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                                        
                                        const SizedBox(height: 15,),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  },
                );
            }
          }         
        );
    //   },
    // );
  }
}

class MenuTileWidget extends StatelessWidget {
  final int index;
  final GamePlayState gamePlayState;
  final ColorPalette palette;
  final String language;
  final String body;
  final Icon iconData;
  final void Function()? onPressed;
  const MenuTileWidget({
    super.key,
    required this.index,
    required this.gamePlayState,
    required this.palette,
    required this.language,
    required this.body,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: gamePlayState.tileSize*2,
        height: gamePlayState.tileSize*2,
        decoration: Decorations().getTileDecoration(gamePlayState.tileSize*2, palette, index, index),
        child: Center(
          child: Container(
            width: gamePlayState.tileSize*1.5,
            height: gamePlayState.tileSize*1.5,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    child: iconData
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        body,
                        style: Helpers().customTextStyle(palette.fullTileTextColor, gamePlayState.tileSize*0.35),
                      ),
                    ),
                  )
                ),            
              ],
            ),
          ),
        ),
      ),
    );
  }
}