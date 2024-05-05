import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
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
    // getUserFromFirebase();
    settings = Provider.of<SettingsController>(context, listen: false);
    palette = Provider.of<ColorPalette>(context, listen: false);
    // getUserFromStorage(settings);
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
            String language = snapshot.data!['userData']['parameters']['currentLanguage'];
          // if (snapshot.hasData) {
            return SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30.0)
                      )
                    ),
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: palette.textColor1,
                      ),
                      onPressed: () {
                        audioController.playSfx(SfxType.optionSelected);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const WelcomeUser()));
                      },
                    ),                  
                    title: Text(
                      Helpers().translateText(language, "Instructions"),
                      style: Helpers().customTextStyle(palette.textColor1, 30*settingsState.sizeFactor) // TextStyle(color: palette.textColor1),
                    ),
                    backgroundColor: palette.appBarColor,
              
                  ),
                  backgroundColor: palette.screenBackgroundColor,              
              
                  body: Container(
                    color: palette.screenBackgroundColor,
                    // width: double.infinity,
                    child: SingleChildScrollView(
                      child: Consumer<SettingsController>(
                          builder: (context, settings, child) {
                        return Align(
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 600
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
                                          Helpers().translateText(language, "Objective"),
                                          settingsState.sizeFactor
                                        ),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language, 
                                            "Score as many points as possible by completing as many words as you can.",
                                          ),
                                          settingsState.sizeFactor
                                        ),
                                        _gap(15*settingsState.sizeFactor),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language, 
                                            "Words must be at least 3 letters in length to count"
                                          ),
                                          settingsState.sizeFactor                                  
                                        ),
                                        _gap(25*settingsState.sizeFactor),
                                        TextButton(
                                          onPressed: () {
                                            TutorialHelpers().navigateToTutorial(context, language);
                                          }, 
                                          child: Padding(
                                            padding:  EdgeInsets.fromLTRB(16.0*settingsState.sizeFactor, 4.0*settingsState.sizeFactor, 16.0*settingsState.sizeFactor, 4.0*settingsState.sizeFactor),
                                            child: Container(
                                              width: double.infinity,
                                              height: 50*settingsState.sizeFactor,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      // stops: [10.0, 1.0, 1.0, 1.0, 3.0],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: <Color>[
                                                        palette.optionButtonBgColor2,
                                                        palette.optionButtonBgColor2,
                                                        // palette.optionButtonBgColor2,
                                                        // palette.optionButtonBgColor2,
                                                        // palette.optionButtonBgColor,
                                                        // Colors.black
                                                
                                                      ],
                                                      tileMode: TileMode.mirror),
                                                  border: const Border(),
                                                  borderRadius: BorderRadius.all(Radius.circular(12.0*settingsState.sizeFactor))),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0*settingsState.sizeFactor),
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        Helpers().translateText(
                                                          language, 
                                                          "Watch a Demo!"
                                                        ),
                                                        style:
                                                            TextStyle(fontSize: 24*settingsState.sizeFactor, color: palette.optionButtonTextColor),
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          )
                                        ),                                  
                                        textHeading(
                                          palette.textColor3,
                                          Helpers().translateText(language,"How It Works",),
                                          settingsState.sizeFactor
                                        ),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language,
                                            "Every turn, you have a random letter to place anywhere on the board before the timer runs out."),
                                            settingsState.sizeFactor
                                          ),
                                        _gap(15*settingsState.sizeFactor),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "If the timer runs out, the tile will be disabled for the rest of the game!"),
                                            settingsState.sizeFactor
                                        ),
                                        _gap(15*settingsState.sizeFactor),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "When words are found, their letters will be destroyed and their values tabulated"),
                                            settingsState.sizeFactor
                                        ),
                                        _gap(15*settingsState.sizeFactor),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "The game ends when the board is full and no more letters can be placed"),
                                            settingsState.sizeFactor
                                        ),
                                        _gap(15*settingsState.sizeFactor),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "At every level reached (maximum 10) you have less and less time to place a letter"),
                                            settingsState.sizeFactor
                                        ),
                                        _gap(25*settingsState.sizeFactor),
                                        textHeading(
                                          palette.textColor3,
                                          Helpers().translateText(
                                            language,                                    
                                          "Scoring",
                                          
                                          ),
                                          settingsState.sizeFactor
                                        ),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "Every letter has a value from 1 to 10"),
                                            settingsState.sizeFactor
                                        ),
                                        _gap(15*settingsState.sizeFactor),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "Each turn where at least one word is found, letter values are summed for each word."),
                                            settingsState.sizeFactor
                                        ),
                                        _gap(15*settingsState.sizeFactor),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "The total value of the turn is calculated based on the following factors:"),
                                            settingsState.sizeFactor
                                        ),
                                        _gap(15*settingsState.sizeFactor),
                                        textBodyBulletHeading(
                                            palette.textColor3,
                                          Helpers().translateText(
                                            language,                                      
                                            "Word Lengths:"),
                                            settingsState.sizeFactor
                                        ),
                                        textBodyBullet(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "For Words that are 5 and 6 letters in length, each of their letters are multiplied by a factor of 2 and 3 respectively"),
                                            settingsState.sizeFactor
                                        ),
                                        _gap(10*settingsState.sizeFactor),
                                        textBodyBulletHeading(
                                            palette.textColor3, 
                                          Helpers().translateText(
                                            language,                                      
                                            "Active Streak:"),
                                            settingsState.sizeFactor
                                        ),
                                        textBodyBullet(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "The running number of consecutive turns with at least one word found"),
                                            settingsState.sizeFactor
                                        ),
                                        _gap(10*settingsState.sizeFactor),
                                        textBodyBulletHeading(                                    
                                            palette.textColor3,
                                            Helpers().translateText(
                                              language,                                      
                                            "Cross Words:"),
                                            settingsState.sizeFactor
                                        ),
                                        textBodyBullet(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "Whether or not words were found in the horizontal and vertical axis' doubles the points"),
                                            settingsState.sizeFactor
                                        ),
                                        _gap(10*settingsState.sizeFactor),
                                        textBodyBulletHeading(
                                            palette.textColor3,
                                            Helpers().translateText(
                                              language,                                      
                                            "Word Count:"),
                                            settingsState.sizeFactor
                                        ),
                                        textBodyBullet(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "The running total is then multiplied by the number of words found in that turn"),
                                            settingsState.sizeFactor
                                        ),
                                        _gap(10*settingsState.sizeFactor),
                                        textHeading(
                                          palette.textColor3,
                                          Helpers().translateText(
                                            language,                                    
                                          "Letter Values",
                                          ),
                                          settingsState.sizeFactor
                                        ),
                                        Wrap(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.start,
                                          children: [
                                            for (dynamic item in snapshot.data!['alphabet'])
                                            
                                              SizedBox(
                                                  width: 45*settingsState.sizeFactor,
                                                  height: 45*settingsState.sizeFactor,
                                                  // color: Colors.amber,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(3.0),
                                                    child: scrabbleTile(item['letter'],
                                                        item['points'], 45*settingsState.sizeFactor, 0.65*settingsState.sizeFactor),
                                                  ))
                                          ],
                                        ),
                                        _gap(25*settingsState.sizeFactor),
                                        textHeading(
                                          palette.textColor3,
                                          Helpers().translateText(
                                            language,                                    
                                          "Tips",
                                          ),
                                          settingsState.sizeFactor
                                        ),
                                        _gap(15*settingsState.sizeFactor),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "Place hard letters strategically"),
                                            settingsState.sizeFactor
                                        ),
                                        _gap(15*settingsState.sizeFactor),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "Be careful when trying to create long words, there are ALOT more three letter words than you think..."),
                                            settingsState.sizeFactor
                                          ),
                                        _gap(15*settingsState.sizeFactor),
                                        textBody(palette.textColor3,
                                          Helpers().translateText(
                                            language,                                  
                                            "Don't be afraid to let the board fill up with letters, it's actually really hard to lose this game that way"),
                                            settingsState.sizeFactor
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30*settingsState.sizeFactor,),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  )),
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

Widget textHeading(Color color, String body, double sizeFactor) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0*sizeFactor),
    child: Text(
      body,
      style: Helpers().customTextStyle(color, 32*sizeFactor),
    ),
  );
}

Widget textBody(Color color, String body, double sizeFactor) {
  return Text(
    body,
    style: Helpers().customTextStyle(color, 18*sizeFactor),
    // style: GoogleFonts.roboto(
    //   fontSize: 18*sizeFactor, color: color
    // ),
  );
}

Widget textBodyBulletHeading(Color color, String body, double sizeFactor) {
  return Padding(
    padding: EdgeInsets.only(left: 30*sizeFactor),
    child: Text(
      body,
      style: Helpers().customTextStyle(color, 18*sizeFactor),
      // style: GoogleFonts.roboto(
      //     fontSize: 18*sizeFactor, 
      //     color: color, 
      //     fontWeight: FontWeight.bold
      //   ),
    ),
  );
}

Widget textBodyBullet(Color color, String body, double sizeFactor) {
  return Padding(
    padding: EdgeInsets.only(left: 30*sizeFactor),
    child: Text(
      body,
      style: Helpers().customTextStyle(color, 14*sizeFactor),
      // style: GoogleFonts.roboto(
      //   fontSize: 14*sizeFactor, 
      //   color: color
      // ),
    ),
  );
}
