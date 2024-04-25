import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';
import 'package:scribby_flutter_v2/utils/translations.dart';

class Helpers {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String formatWord(String s) {
    String lower = s.toLowerCase();
    String newString = lower[0].toUpperCase() + lower.substring(1);
    return newString;
  } 

  String fixForCharacter(String s, String character) {
    List<String> strings = s.split(character);
    List<String> newList = [];
    for (String item in strings) {
      newList.add(capitalize(item));
    }
    String stringsCleaned = newList.join(character);
    return stringsCleaned;
  }

  String capitalizeName(String s) {
    String stringWitoutSpaces = fixForCharacter(s, " ");
    String stringWithoutDashes = fixForCharacter(stringWitoutSpaces, "-");
    String stringWithoutPeriods = fixForCharacter(stringWithoutDashes, ".");

    return stringWithoutPeriods;
  }

  int getCurrentHighScore(SettingsState settings) {
    final String currentLanguage =
        settings.userData['parameters']['currentLanguage'];
    final int currentHighScore =
        settings.userData['highScores'][currentLanguage] ?? 0;
    return currentHighScore;
  }

  void getStates(GamePlayState gamePlayState, SettingsController settings) {
    final Map<String, dynamic> alphabetDocumnet = (settings.alphabet.value as Map<String, dynamic>);
    final List<dynamic> alphabet = alphabetDocumnet['alphabet'];

    if (alphabet.isNotEmpty) {
      late List<Map<String, dynamic>> startingAlphabetState = GameLogic()
          .generateStartingStates(
              alphabet, initialBoardState, [])['startingAlphabet'];
      late List<String> randomLetterListState = GameLogic()
          .generateStartingStates(
              alphabet, initialBoardState, [])['startingRandomLetterList'];
      late List<Map<String, dynamic>> startingTileState = GameLogic()
          .generateStartingStates(
              alphabet, initialBoardState, [])['startingTileState'];

      gamePlayState.setAlphabetState(startingAlphabetState);
      gamePlayState.setRandomLetterList(randomLetterListState);
      gamePlayState.setVisualTileState(startingTileState);
    } else {
      debugPrint("something went wrong retrieving the alphabet from storage");
    }
  }

  Map<String,dynamic> getTileObject(GamePlayState gamePlayState, int index) {
    late Map<String,dynamic> tileObject = gamePlayState.visualTileState.firstWhere((element) => element["index"] == index);
    return tileObject;
  }




  Widget multiplierIcon(String stat, int turn, int data, ColorPalette palette, double sizeFactor) {

    Color textColor = turn.isEven ? palette.textColor1 : palette.textColor3;
    late IconData iconItem;
    if (stat == 'count') {
      iconItem = Icons.library_books_outlined;
    } else if (stat == 'crosswords') {
      iconItem = Icons.close;
    } else if (stat == 'streak') {
      iconItem = Icons.bolt;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0*sizeFactor),
      child: SizedBox(
        width: 35*sizeFactor,
        child: Stack(
          children: [
            Icon(
              iconItem,
              size: 22*sizeFactor,
              color: textColor,
            ),
            Positioned(
              left: 22.0*sizeFactor,
              top:7*sizeFactor,
              child: Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text:"x",
                        style: TextStyle(
                          fontSize: 10*sizeFactor,
                          color: textColor
                        )
                    ),
                    TextSpan(
                      text: data.toString(),
                      style: TextStyle(
                        fontSize: 14*sizeFactor,
                        color: textColor
                      )
                    ),
                  ],
                ),
              ),          
            )
        
          ],
        ),
      ),
    );
  }  


  TableRow scoreSummaryTableRow2(int index, ColorPalette palette, Map<String,dynamic> data, BuildContext context, String language, double sizeFactor) {
    Color textColor = index.isEven ? palette.textColor1 : palette.textColor1;
    Color rowColor = index.isEven ? palette.optionButtonBgColor : palette.optionButtonBgColor2;
    List<Map<String,dynamic>> words = data["words"];

    return TableRow(
      decoration: BoxDecoration(
        color: rowColor,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                for (Map<String,dynamic> word in words)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    word['index'].toString(),
                    style: customTextStyle(textColor, 18* sizeFactor),
                    // style: TextStyle(
                    //   color: textColor,
                    //   fontSize: 18*sizeFactor
                    // ),
                  )
                )
              ],
            ),
          ),
        ),
        // Row(
          // children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (Map<String,dynamic> word in words)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: Text(
                      word['word'],
                      style: customTextStyle(textColor, 18* sizeFactor),
                      // style: TextStyle(
                      //   color: textColor,
                      //   fontSize: (18 * sizeFactor),
                      // ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context, 
                        builder:(context) {
                          return FutureBuilder<String>(
                            future: GameLogic().fetchDefinition(word["word"], language),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return wordDefinitionDialog(palette, sizeFactor,word['word'],translateText(language, "loading..."));
                              } else if (snapshot.hasError) {
                                return wordDefinitionDialog(palette, sizeFactor,word['word'],translateText(language,"Error fetching definition"));
                              } else {
                                if (snapshot.data != null) {
                                  return wordDefinitionDialog(palette, sizeFactor,word['word'], snapshot.data!);
                                } else {
                                  return wordDefinitionDialog(palette, sizeFactor,word['word'],translateText(language, "No definition available at this time"));
                                }
                              }                    
                            },
              
                          );
                        },
                      );
                    },
                  ),
                // )
              // ],
            ),       
          ],
        ),

        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              for (int i=0; i<words.length; i++)
              Text(
                data['streak'].toString(),
                style: customTextStyle(textColor, 18* sizeFactor),
              )
            ],
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              for (int i=0; i<words.length; i++)
              Text(
                data['count'].toString(),
                style: customTextStyle(textColor, 18* sizeFactor),
              )
            ],
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              for (int i=0; i<words.length; i++)
              Text(
                data['crossword'].toString(),
                style: customTextStyle(textColor, 18* sizeFactor),
              )
            ],
          ),
        ),                
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Column(
              children: [
                for (Map<String,dynamic> word in words)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    word['totalScore'].toString(),
                    style: customTextStyle(textColor, 18* sizeFactor),
                  )
                )
              ],
            ),

          ),
        ),
 
      ]
    );
  }


  String translateWelcomeText(String languageRaw, String originalString,) {
    String res = '';
    late Map<String,dynamic> languageMap = translations.firstWhere((element) => element['key'] == originalString);
    late Map<String,dynamic> translationMap = {
      "English" : "english",
      "Français" : "french",
      "Español" : "spanish",
      "Deutsch" : "german",
      "Italiano" : "italian",
      "Português" : "portuguese",
      "Ελληνικά" : "greek",
      "Nederlands" : "dutch",
    };

    if (languageRaw == "") {
      res = "";
    } else {
      String language = translationMap[languageRaw];
      res = languageMap['data'][language.toLowerCase()];
    }
    return res;    
  }

  String translateText(String languageRaw, String originalString,) {
    late Map<String,dynamic> languageMap = translations.firstWhere((element) => element['key'] == originalString);
    return languageMap['data'][languageRaw.toLowerCase()];
  }

  String translateDemoSequence(String language, String originalString,) {
    if (language == "") {
      return "";
    } else {

      String translatedBody = translateText(language.toLowerCase(), originalString);
      late Map<String,dynamic> dynamicLetters = demoStateDynamicLetters[language];
      dynamicLetters.forEach((key, value) {
        translatedBody = translatedBody.replaceAll(key, value);
      });
      return translatedBody;
    }
  }


  double getSizeFactor(double screenHeight) {
    double res = 1.0;
    if (screenHeight <= 801 ) {
      res = 0.75;
    }
    return res;
  }

  Future<void> showBadNameDialog(
    BuildContext context, 
    String titleText, 
    String textBody,
    String buttonText,   
    ColorPalette palette
    ) async {
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {

     

        return Theme(
          data: ThemeData.dark().copyWith(
            // Set the background color of the AlertDialog
            dialogBackgroundColor: palette.optionButtonBgColor,
            // Set the text color of the AlertDialog
            textTheme: const TextTheme().copyWith(
              bodyMedium: TextStyle(color: palette.textColor1),
            ),
          ),      
          child: AlertDialog(
            title: Text(
              titleText,
              style: TextStyle(
                color: palette.textColor2
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    textBody,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: palette.textColor2
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        );
      },
    );
  }

  bool checkForBadWords(String name) {
    List<String> badWords = ["faggot", "faggit", "fagot","nigger","retard","nigga","bitch","cunt"];
    bool badWordFound = false;
    for (String word in badWords) {
      if (name.contains(word)) {
        badWordFound = true;
        
      } 
    }

    
    return badWordFound;
  }

  Widget wordDefinitionDialog(ColorPalette palette, double sizeFactor, String wordText, String textBody ) {
    return AlertDialog(
      backgroundColor: palette.optionButtonBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0*sizeFactor))
      ),                                  
      title: Text(
        wordText,
        style: TextStyle(
          color: palette.textColor2,
          fontSize: 18 * sizeFactor
        ),
      ),
      content: Text(
        textBody,
        style: TextStyle(
          color: palette.textColor2,
          fontSize: 18  * sizeFactor
        ),                            
      ),                        
    );    
  }


  TextStyle customTextStyle(Color textColor, double fontSize) {
    return GoogleFonts.roboto(
      color: textColor,
      fontSize: fontSize
    );
  }




}
