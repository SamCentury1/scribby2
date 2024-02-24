import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/player_progress/persistence/local_storage_player_progress_persistence.dart';
// import 'package:scribby_flutter_v2/player_progress/persistence/player_progress_persistence.dart';
// import 'package:scribby_flutter_v2/player_progress/player_progress.dart';
// import 'package:scribby_flutter_v2/resources/auth_service.dart';
// import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
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
      debugPrint(error.toString());
    }
    return res;
  }


  // Future<Map<String, dynamic>> getAlphabet() async  {
  //   late Map<String, dynamic> res = {};
  //   try {
  //     res = (settings.alphabet.value as Map<String, dynamic>);
  //   } catch (error) {
  //     debugPrint(error.toString());
  //   }
  //   return res;
  // }  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDataFromStorage(), 
      builder:(context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        } else if (snapshot.hasError ) {
          return Center(child: Text("Error"),);
        } else {
            String language = snapshot.data!['userData']['parameters']['currentLanguage'];
          // if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(
                    Helpers().translateText(language, "Instructions"),
                    
                    style: TextStyle(
                      color: palette.textColor1,
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: palette.textColor1,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const MenuScreen()));
                    },
                  ),
                  backgroundColor: palette.appBarColor,
                ),
                body: SingleChildScrollView(
                  child: Consumer<SettingsController>(
                      builder: (context, settings, child) {
                    return Container(
                      width: double.infinity,
                      color: palette.screenBackgroundColor,
                      child: Column(
                        children: [

                          const SizedBox(
                            height: 15,
                          ),
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
                                    Helpers().translateText(language, "Objective")
                                  ),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language, 
                                      "Score as many points as possible by completing as many words as you can."
                                    )
                                  ),
                                  _gap(15),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language, 
                                      "Words must be at least 3 letters in length to count"
                                    )                                  
                                  ),
                                  _gap(25),
                                  TextButton(
                                    onPressed: () {
                                      TutorialHelpers().navigateToTutorial(context);
                                    }, 
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: <Color>[
                                                  palette.optionButtonBgColor,
                                                  palette.optionButtonBgColor
                                                ],
                                                tileMode: TileMode.mirror),
                                            border: const Border(),
                                            borderRadius: const BorderRadius.all(Radius.circular(12.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                                      TextStyle(fontSize: 24, color: palette.optionButtonTextColor),
                                                ),
                                              )),
                                        ),
                                      ),
                                    )
                                  ),                                  
                                  textHeading(
                                    palette.textColor3,
                                    Helpers().translateText(language,"How It Works",)
                                  ),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language,
                                      "Every turn, you have a random letter to place anywhere on the board before the timer runs out."),
                                    ),
                                  _gap(15),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "If the timer runs out, the tile will be disabled for the rest of the game!"),
                                  ),
                                  _gap(15),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "When words are found, their letters will be destroyed and their values tabulated"),
                                  ),
                                  _gap(15),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "The game ends when the board is full and no more letters can be placed"),
                                  ),
                                  _gap(15),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "At every level reached (maximum 10) you have less and less time to place a letter"),
                                  ),
                                  _gap(25),
                                  textHeading(
                                    palette.textColor3,
                                    Helpers().translateText(
                                      language,                                    
                                    "Scoring",
                                    ),
                                  ),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "Every letter has a value from 1 to 10"),
                                  ),
                                  _gap(15),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "Each turn where at least one word is found, letter values are summed for each word."),
                                  ),
                                  _gap(15),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "The total value of the turn is calculated based on the following factors:"),
                                  ),
                                  _gap(15),
                                  textBodyBulletHeading(
                                      palette.textColor3,
                                    Helpers().translateText(
                                      language,                                      
                                      "Word Lengths:"),
                                  ),
                                  textBodyBullet(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "For Words that are 5 and 6 letters in length, each of their letters are multiplied by a factor of 2 and 3 respectively"),
                                  ),
                                  _gap(10),
                                  textBodyBulletHeading(
                                      palette.textColor3, 
                                    Helpers().translateText(
                                      language,                                      
                                      "Active Streak:"),
                                  ),
                                  textBodyBullet(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "The running number of consecutive turns with at least one word found"),
                                  ),
                                  _gap(10),
                                  textBodyBulletHeading(                                    
                                      palette.textColor3,
                                      Helpers().translateText(
                                        language,                                      
                                      "Cross Words:"),
                                  ),
                                  textBodyBullet(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "Whether or not words were found in the horizontal and vertical axis' doubles the points"),
                                  ),
                                  _gap(10),
                                  textBodyBulletHeading(
                                      palette.textColor3,
                                      Helpers().translateText(
                                        language,                                      
                                      "Word Count:"),
                                  ),
                                  textBodyBullet(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "The running total is then multiplied by the number of words found in that turn"),
                                  ),
                                  _gap(10),
                                  textHeading(
                                    palette.textColor3,
                                    Helpers().translateText(
                                      language,                                    
                                    "Letter Values",
                                    ),
                                  ),
                                  Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      for (dynamic item in snapshot.data!['alphabet'])
                                      
                                        SizedBox(
                                            width: 45,
                                            height: 45,
                                            // color: Colors.amber,
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: scrabbleTile(item['letter'],
                                                  item['points'], 45, 0.65),
                                            ))
                                    ],
                                  ),
                                  _gap(25),
                                  textHeading(
                                    palette.textColor3,
                                    Helpers().translateText(
                                      language,                                    
                                    "Tips",
                                    ),
                                  ),
                                  _gap(15),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "Place hard letters strategically"),
                                  ),
                                  _gap(15),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "Be careful when trying to create long words, there are ALOT more three letter words than you think..."),
                                    ),
                                  _gap(15),
                                  textBody(palette.textColor3,
                                    Helpers().translateText(
                                      language,                                  
                                      "Don't be afraid to let the board fill up with letters, it's actually really hard to lose this game that way"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    );
                  }),
                ));            
          // }
        }
      },
    );
    // return isLoading
    //     ? const Center(
    //         child: CircularProgressIndicator(),
    //       )
    //     : Scaffold(
    //         appBar: AppBar(
    //           title: Text(
    //             "Instructions",
    //             style: TextStyle(
    //               color: palette.textColor1,
    //             ),
    //           ),
    //           leading: IconButton(
    //             icon: Icon(
    //               Icons.arrow_back,
    //               color: palette.textColor1,
    //             ),
    //             onPressed: () {
    //               Navigator.of(context).pushReplacement(MaterialPageRoute(
    //                   builder: (context) => const MenuScreen()));
    //             },
    //           ),
    //           backgroundColor: palette.appBarColor,
    //         ),
    //         body: SingleChildScrollView(
    //           child: Consumer<SettingsController>(
    //               builder: (context, settings, child) {
    //             return Container(
    //               width: double.infinity,
    //               color: palette.screenBackgroundColor,
    //               child: Column(
    //                 children: [
    //                   Text(_userFromStorage['username'].toString()),
    //                   const SizedBox(
    //                     height: 15,
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.symmetric(horizontal: 28.0),
    //                     child: SizedBox(
    //                       width: double.infinity,
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           textHeading(
    //                             palette.textColor3,
    //                             "Objective",
    //                           ),
    //                           textBody(palette.textColor3,
    //                               "Score as many points as possible by completing as many words as you can."),
    //                           _gap(15),
    //                           textBody(palette.textColor3,
    //                               "Words must be at least 3 letters in length to count"),
    //                           _gap(25),
    //                           textHeading(
    //                             palette.textColor3,
    //                             "How It Works",
    //                           ),
    //                           textBody(palette.textColor3,
    //                               "Every turn, you have a random letter to place anywhere on the board before the timer runs out."),
    //                           _gap(15),
    //                           textBody(palette.textColor3,
    //                               "If the timer runs out, the tile will be disabled for the rest of the game!"),
    //                           _gap(15),
    //                           textBody(palette.textColor3,
    //                               "When words are found, their letters will be destroyed and their values tabulated"),
    //                           _gap(15),
    //                           textBody(palette.textColor3,
    //                               "The game ends when the board is full and no more letters can be placed"),
    //                           _gap(15),
    //                           textBody(palette.textColor3,
    //                               "At every level reached (maximum 10) you have less and less time to place a letter"),
    //                           _gap(25),
    //                           textHeading(
    //                             palette.textColor3,
    //                             "Scoring",
    //                           ),
    //                           textBody(palette.textColor3,
    //                               "Every letter has a value from 1 to 10"),
    //                           _gap(15),
    //                           textBody(palette.textColor3,
    //                               "Each turn where at least one word is found, letter values are summed for each word."),
    //                           _gap(15),
    //                           textBody(palette.textColor3,
    //                               "The the total value of the turn is calculated based on the following factors:"),
    //                           _gap(15),
    //                           textBodyBulletHeading(
    //                               palette.textColor3, "Word Lengths:"),
    //                           textBodyBullet(palette.textColor3,
    //                               "For Words that are 5 and 6 letters in length, each of their letters are multiplied by a factor of 2 and 3 respectively"),
    //                           _gap(10),
    //                           textBodyBulletHeading(
    //                               palette.textColor3, "Active Streak:"),
    //                           textBodyBullet(palette.textColor3,
    //                               "The running number of consecutive turns with at least one word found"),
    //                           _gap(10),
    //                           textBodyBulletHeading(
    //                               palette.textColor3, "Cross Words:"),
    //                           textBodyBullet(palette.textColor3,
    //                               "Whether or not words wer found in the horizontal and vertical axis' doubles the points"),
    //                           _gap(10),
    //                           textBodyBulletHeading(
    //                               palette.textColor3, "Word Count:"),
    //                           textBodyBullet(palette.textColor3,
    //                               "The running total is then multiplied by the number of words found in that turn"),
    //                           _gap(10),
    //                           textHeading(
    //                             palette.textColor3,
    //                             "Letter Values",
    //                           ),
    //                           Wrap(
    //                             direction: Axis.horizontal,
    //                             children: [
    //                               for (dynamic item in _alphabet)
    //                                 SizedBox(
    //                                     width: 45,
    //                                     height: 45,
    //                                     // color: Colors.amber,
    //                                     child: Padding(
    //                                       padding: const EdgeInsets.all(3.0),
    //                                       child: scrabbleTile(item['letter'],
    //                                           item['points'], 45, 0.65),
    //                                     ))
    //                             ],
    //                           ),
    //                           _gap(25),
    //                           textHeading(
    //                             palette.textColor3,
    //                             "Tips",
    //                           ),
    //                           _gap(15),
    //                           textBody(palette.textColor3,
    //                               "Place hard letters strategically (Q, X, J) - how many words do you know end with any of these?"),
    //                           _gap(15),
    //                           textBody(palette.textColor3,
    //                               "Be careful when trying to create long words, there are ALOT more three letter words than you think..."),
    //                           _gap(15),
    //                           textBody(palette.textColor3,
    //                               "Don't be afraid to let the board fill upwith letters, it's actually really hard to lose this game that way"),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 30,
    //                   ),
    //                 ],
    //               ),
    //             );
    //           }),
    //         ));
  }
}

Widget _gap(double gap) {
  return SizedBox(
    height: gap,
  );
}

Widget textHeading(Color color, String body) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      body,
      style: GoogleFonts.roboto(fontSize: 32, color: color),
    ),
  );
}

Widget textBody(Color color, String body) {
  return Text(
    body,
    style: GoogleFonts.roboto(fontSize: 18, color: color),
  );
}

Widget textBodyBulletHeading(Color color, String body) {
  return Padding(
    padding: const EdgeInsets.only(left: 30),
    child: Text(
      body,
      style: GoogleFonts.roboto(
          fontSize: 18, color: color, fontWeight: FontWeight.bold),
    ),
  );
}

Widget textBodyBullet(Color color, String body) {
  return Padding(
    padding: const EdgeInsets.only(left: 30),
    child: Text(
      body,
      style: GoogleFonts.roboto(fontSize: 14, color: color),
    ),
  );
}
