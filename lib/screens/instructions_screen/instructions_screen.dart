import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/welcome_user.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/styles/styles.dart';

class InstructionsScreen extends StatefulWidget {
  const InstructionsScreen({super.key});

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  late bool isLoading = false;
  late bool isLoading2 = false;
  // late Map<String, dynamic> _userData = {};
  late ColorPalette palette;

  late SettingsController settings;

  @override
  void initState() {
    super.initState();
    settings = Provider.of<SettingsController>(context, listen: false);
    palette = Provider.of<ColorPalette>(context, listen: false);
  }




  Future<Map<String, dynamic>> getDataFromStorage() async  {
    late Map<String, dynamic> res = {};
    try {
      final Map<String,dynamic> userData = (settings.userData.value as Map<String, dynamic>);
      final Map<String, dynamic> alphabetObject = (settings.alphabet.value as Map<String, dynamic>);
      res = {"userData": userData, "alphabet": alphabetObject['alphabet']};

    } catch (error) {
      // debugPrint(error.toString());
    }
    return res;
  }




  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDataFromStorage(), 
      builder:(context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        } else if (snapshot.hasError ) {
          return const Center(child: Text("Error"),);
        } else {
            late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
            final AudioController audioController =Provider.of<AudioController>(context, listen: false);
            final GamePlayState gamePlayState =Provider.of<GamePlayState>(context, listen: false);
            String language = snapshot.data!['userData']['parameters']['currentLanguage'];

            final double screenWidth = settingsState.screenSizeData['width'];
            final double screenHeight = settingsState.screenSizeData['height'];
            final List<Map<String,dynamic>> decorationDetails = gamePlayState.decorationData;             
          // if (snapshot.hasData) {
            return SafeArea(
              child: Stack(
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
                    child: Scaffold(
                          appBar: PreferredSize(
                            preferredSize: Size(double.infinity,gamePlayState.tileSize),
                            
                            child: AppBar(     
                              backgroundColor: Colors.transparent,
                              leading: SizedBox(),
                                flexibleSpace: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        iconSize: gamePlayState.tileSize*0.4,
                                        color: palette.textColor1,
                                        onPressed: () {
                                          audioController.playSfx(SfxType.optionSelected);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => const WelcomeUser(),
                                            ),
                                          );
                                        },
                                      ),                                         
                                      Text(Helpers().translateText(gamePlayState.currentLanguage, 'Instructions',settingsState),
                                        style: TextStyle(
                                          color: palette.textColor1,
                                          fontSize: gamePlayState.tileSize*0.4
                                        ),
                                                                        
                                      ),
                                    ],
                                  ),
                                ), 
                            ),
                          ),   
                        backgroundColor: Colors.transparent,              
                    
                        body: Container(
                          child: SingleChildScrollView(
                            child: Consumer<SettingsController>(
                                builder: (context, settings, child) {
                              return Align(
                                alignment: Alignment.center,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 500
                                  ),
                                  
                                  child: Column(
                                    children: [    
                                      const SizedBox(height: 15,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              textHeading(
                                                palette.textColor3,
                                                Helpers().translateText(language, "Objective",settingsState),
                                                gamePlayState.tileSize
                                              ),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language, 
                                                  "Score as many points as possible by completing as many words as you can.",
                                                  settingsState
                                                ),
                                                gamePlayState.tileSize
                                              ),
                                              _gap(0.15*gamePlayState.tileSize),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language, 
                                                  "Words must be at least 3 letters in length to count",
                                                  settingsState
                                                ),
                                                gamePlayState.tileSize                                  
                                              ),
                                              _gap(0.25*gamePlayState.tileSize),
                                              TextButton(
                                                onPressed: () {
                                                  // TutorialHelpers().navigateToTutorial(context, language);
                                                }, 
                                                child: Padding(
                                                  padding:  EdgeInsets.fromLTRB(
                                                    gamePlayState.tileSize*0.05, 
                                                    gamePlayState.tileSize*0.15, 
                                                    gamePlayState.tileSize*0.05, 
                                                    gamePlayState.tileSize*0.15
                                                  ),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: gamePlayState.tileSize,
                                                    decoration: Decorations().getTileDecoration(
                                                      gamePlayState.tileSize, 
                                                      palette, 
                                                      3, 
                                                      2
                                                    ),
                                                    // decoration: BoxDecoration(
                                                    //     gradient: LinearGradient(
                                                    //         // stops: [10.0, 1.0, 1.0, 1.0, 3.0],
                                                    //         begin: Alignment.topCenter,
                                                    //         end: Alignment.bottomCenter,
                                                    //         colors: <Color>[
                                                    //           palette.optionButtonBgColor2,
                                                    //           palette.optionButtonBgColor2,
                                                    //           // palette.optionButtonBgColor2,
                                                    //           // palette.optionButtonBgColor2,
                                                    //           // palette.optionButtonBgColor,
                                                    //           // Colors.black
                                                      
                                                    //         ],
                                                    //         tileMode: TileMode.mirror),
                                                    //     border: const Border(),
                                                    //     borderRadius: BorderRadius.all(Radius.circular(gamePlayState.tileSize*0.2))),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(gamePlayState.tileSize*0.07),
                                                      child: Align(
                                                          alignment: Alignment.center,
                                                          child: FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            child: Text(
                                                              Helpers().translateText(
                                                                language, 
                                                                "Watch a Demo!",
                                                                settingsState
                                                              ),
                                                              style:
                                                                  TextStyle(fontSize: gamePlayState.tileSize*0.4, color: palette.fullTileTextColor),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                )
                                              ),                                  
                                              textHeading(
                                                palette.textColor3,
                                                Helpers().translateText(language,"How It Works",settingsState),
                                                gamePlayState.tileSize
                                              ),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language,
                                                  "Every turn, you have a random letter to place anywhere on the board before the timer runs out.",
                                                  settingsState),
                                                  
                                                  gamePlayState.tileSize
                                                ),
                                              _gap(0.15*gamePlayState.tileSize),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "If the timer runs out, the tile will be disabled for the rest of the game!",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              _gap(0.15*gamePlayState.tileSize),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "When words are found, their letters will be destroyed and their values tabulated",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              _gap(0.15*gamePlayState.tileSize),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "The game ends when the board is full and no more letters can be placed",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              _gap(0.15*gamePlayState.tileSize),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "At every level reached (maximum 10) you have less and less time to place a letter",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              _gap(0.25*gamePlayState.tileSize),
                                              textHeading(
                                                palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                    
                                                "Scoring",
                                                settingsState
                                                
                                                ),
                                                gamePlayState.tileSize
                                              ),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "Every letter has a value from 1 to 10",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              _gap(0.15*gamePlayState.tileSize),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "Each turn where at least one word is found, letter values are summed for each word.",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              _gap(0.15*gamePlayState.tileSize),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "The total value of the turn is calculated based on the following factors:",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              _gap(0.15*gamePlayState.tileSize),
                                              textBodyBulletHeading(
                                                  palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                      
                                                  "Word Lengths:",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              textBodyBullet(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "For Words that are 5 and 6 letters in length, each of their letters are multiplied by a factor of 2 and 3 respectively",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              _gap(0.10*gamePlayState.tileSize),
                                              textBodyBulletHeading(
                                                  palette.textColor3, 
                                                Helpers().translateText(
                                                  language,                                      
                                                  "Active Streak:",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              textBodyBullet(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "The running number of consecutive turns with at least one word found",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              _gap(0.10*gamePlayState.tileSize),
                                              textBodyBulletHeading(                                    
                                                  palette.textColor3,
                                                  Helpers().translateText(
                                                    language,                                      
                                                  "Cross Words:",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              textBodyBullet(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "Whether or not words were found in the horizontal and vertical axis' doubles the points",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              _gap(0.10*gamePlayState.tileSize),
                                              textBodyBulletHeading(
                                                  palette.textColor3,
                                                  Helpers().translateText(
                                                    language,                                      
                                                  "Word Count:",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              textBodyBullet(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "The running total is then multiplied by the number of words found in that turn",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              _gap(0.10*gamePlayState.tileSize),
                                              textHeading(
                                                palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                    
                                                "Letter Values",
                                                settingsState
                                                ),
                                                gamePlayState.tileSize
                                              ),
                                              Wrap(
                                                direction: Axis.horizontal,
                                                alignment: WrapAlignment.start,
                                                children: [
                                                  for (dynamic item in snapshot.data!['alphabet'])
                                                  
                                                    SizedBox(
                                                        width: gamePlayState.tileSize*0.8,
                                                        height: gamePlayState.tileSize*0.8,
                                                        // color: Colors.amber,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(3.0),
                                                          child: scrabbleTile(item['letter'],
                                                              item['points'], gamePlayState.tileSize*0.8,1.0 ),
                                                        ))
                                                ],
                                              ),
                                              _gap(0.25*gamePlayState.tileSize),
                                              textHeading(
                                                palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                    
                                                "Tips",
                                                settingsState
                                                ),
                                                gamePlayState.tileSize
                                              ),
                                              _gap(0.15*gamePlayState.tileSize),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "Place hard letters strategically",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                              _gap(0.15*gamePlayState.tileSize),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "Be careful when trying to create long words, there are ALOT more three letter words than you think...",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                                ),
                                              _gap(0.15*gamePlayState.tileSize),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(
                                                  language,                                  
                                                  "Don't be afraid to let the board fill up with letters, it's actually really hard to lose this game that way",
                                                  settingsState),
                                                  gamePlayState.tileSize
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 0.30*gamePlayState.tileSize,),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        )),
                  ),
                ],
              ),
            );            
          // }
        }
      },
    );
  }
}

Widget _gap(double gap) {
  return SizedBox(
    height: gap,
  );
}

Widget textHeading(Color color, String body, double tileSize) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: tileSize*0.05),
    child: Text(
      body,
      style: GoogleFonts.roboto(
          fontSize: tileSize*0.35, 
          color: color, 
          fontWeight: FontWeight.bold
        ),
    ),
  );
}

Widget textBody(Color color, String body, double tileSize) {
  return Text(
    body,
    style: Helpers().customTextStyle(color, tileSize*0.3),
    // style: GoogleFonts.roboto(
    //   fontSize: 18*sizeFactor, color: color
    // ),
  );
}

Widget textBodyBulletHeading(Color color, String body, double tileSize) {
  return Padding(
    padding: EdgeInsets.only(left: tileSize*0.35),
    child: Text(
      body,
      // style: Helpers().customTextStyle(color, tileSize*0.3),
      style: GoogleFonts.roboto(
          fontSize: tileSize*0.35, 
          color: color, 
          fontWeight: FontWeight.bold
        ),
    ),
  );
}

Widget textBodyBullet(Color color, String body, double tileSize) {
  return Padding(
    padding: EdgeInsets.only(left: tileSize*0.35),
    child: Text(
      body,
      style: Helpers().customTextStyle(color, tileSize*0.28),
      // style: GoogleFonts.roboto(
      //   fontSize: 14*sizeFactor, 
      //   color: color
      // ),
    ),
  );
}
