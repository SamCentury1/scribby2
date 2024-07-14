import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/components/scrabble_tile.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/demo_board_state.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';



class InstructionsScreen extends StatefulWidget {
  const InstructionsScreen({super.key});

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  late bool isLoading = false;
  late bool isLoading2 = false;
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
      final List<dynamic> alphabetObject = (settings.alphabet.value as List<dynamic>);
      res = {"userData": userData, "alphabet": alphabetObject};
    } catch (error) {
    }
    return res;
  }




  @override
  Widget build(BuildContext context) {
            late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
            final AudioController audioController =Provider.of<AudioController>(context, listen: false);
            final GamePlayState gamePlayState =Provider.of<GamePlayState>(context, listen: false);
            String language = gamePlayState.currentLanguage;

            final double screenWidth = settingsState.screenSizeData['width'];
            final double screenHeight = settingsState.screenSizeData['height'];
            final List<Map<String,dynamic>> decorationDetails = gamePlayState.decorationData;             
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
                                              builder: (context) => const MenuScreen(),
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
                                  List<dynamic> alphabetList = settings.alphabet.value as List<dynamic>;

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


                                              Helpers().instructionsHeading(palette.textColor3, "Demo",gamePlayState.currentLanguage, gamePlayState.tileSize*0.35,settingsState),
                                              Helpers().instructionsText(palette.textColor3,
                                                  "The two letters at the top are randomly generated. The center letter letter_01 gets placed next",
                                                  gamePlayState.currentLanguage,
                                                  true,
                                                  gamePlayState.tileSize*0.30,
                                                  settingsState.demoLetters,
                                                  settingsState),
                                              DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState1'], language: gamePlayState.currentLanguage),
                                              Helpers().instructionsText(palette.textColor3,
                                                  "When the letter letter_01 is placed inside the board, the letter to the right letter_02 will become the center letter and a new random letter will be generated and take its spot",
                                                  gamePlayState.currentLanguage,
                                                  true,
                                                  gamePlayState.tileSize*0.30,
                                                  settingsState.demoLetters,
                                                  settingsState),
                                              SizedBox(height: gamePlayState.tileSize*0.2,),
                                              Helpers().instructionsText(palette.textColor3,
                                                  "A new letter letter_03 is randomly generated to be place after the next letter letter_02 is placed.",
                                                  gamePlayState.currentLanguage,
                                                  true,
                                                  gamePlayState.tileSize*0.30,
                                                  settingsState.demoLetters,
                                                  settingsState),
                                              DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState2'], language: gamePlayState.currentLanguage),
                                              Helpers().instructionsText(palette.textColor3,
                                                  "Place your letters strategically to create words. In this case, we see the letter_04 coming after the letter_03",
                                                  gamePlayState.currentLanguage,
                                                  true,
                                                  gamePlayState.tileSize*0.30,
                                                  settingsState.demoLetters,
                                                  settingsState),
                                              DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState3'], language: gamePlayState.currentLanguage),
                                              Helpers().instructionsText(palette.textColor3,
                                                  "The letter_03 is placed below the letter_02 so the letter_04 can be placed between the letter_01 and the letter_02 and create the word WORD",
                                                  gamePlayState.currentLanguage,
                                                  true,
                                                  gamePlayState.tileSize*0.30,
                                                  settingsState.demoLetters,
                                                  settingsState),
                                              DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState4'], language: gamePlayState.currentLanguage),
                                              Helpers().instructionsText(palette.textColor3,
                                                  "The letter_04 is placed in between the letter_01 and letter_02. The letters animate and you are granted points for the letters.",
                                                  gamePlayState.currentLanguage,
                                                  true,
                                                  gamePlayState.tileSize*0.30,
                                                  settingsState.demoLetters,
                                                  settingsState),
                                              // Helpers().instructionsHeading(palette.textColor3,
                                              //     "Swipe to 'Settings' to understand how points are allocated",gamePlayState.currentLanguage, gamePlayState.tileSize*0.35),
                                              DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState5'], language: gamePlayState.currentLanguage),
                                              Helpers().instructionsText(palette.textColor3,
                                                  "After an animation plays, the letters from the word WORD will disappear from the board and the spaces will become available for new letters",
                                                  gamePlayState.currentLanguage,
                                                  true,
                                                  gamePlayState.tileSize*0.30,
                                                  settingsState.demoLetters,
                                                  settingsState),
                                              DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState6'], language: gamePlayState.currentLanguage),
                                              Helpers().instructionsText(palette.textColor3,
                                                  "The spaces become available for the new letters to be placed",
                                                  gamePlayState.currentLanguage,
                                                  false,
                                                  gamePlayState.tileSize*0.30,
                                                  settingsState.demoLetters,
                                                  settingsState),

                                              SizedBox(height: gamePlayState.tileSize*0.3,),


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

                                              // Helpers().wordValuesTable(snapshot.data!['alphabet'],gamePlayState.currentLanguage,settingsState,palette,gamePlayState.tileSize),
                                              Wrap(
                                                direction: Axis.horizontal,
                                                alignment: WrapAlignment.start,
                                                children: [
                                                  
                                                  for (int i=0; i<alphabetList.length; i++)
                                                  ScrabbleTile(letterData: alphabetList[i])
                                                ],
                                              ),
                                              _gap(0.25*gamePlayState.tileSize),
                                              textHeading(
                                                palette.textColor3,
                                                Helpers().translateText(language,"Tips",settingsState),
                                                gamePlayState.tileSize
                                              ),
                                              _gap(0.15*gamePlayState.tileSize),
                                              textBody(palette.textColor3,
                                                Helpers().translateText(language,"Place hard letters strategically",settingsState),
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
  );
}

Widget textBodyBulletHeading(Color color, String body, double tileSize) {
  return Padding(
    padding: EdgeInsets.only(left: tileSize*0.35),
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

Widget textBodyBullet(Color color, String body, double tileSize) {
  return Padding(
    padding: EdgeInsets.only(left: tileSize*0.35),
    child: Text(
      body,
      style: Helpers().customTextStyle(color, tileSize*0.28),
    ),
  );
}

