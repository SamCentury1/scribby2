import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    final Map<String, dynamic> alphabetDocumnet =
        (settings.alphabet.value as Map<String, dynamic>);
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


  Widget multiplierIcon(String stat, int turn, int data, ColorPalette palette) {

    Color textColor = turn.isEven ? palette.textColor1 : palette.textColor3;
    late IconData iconItem;
    if (stat == 'count') {
      iconItem = Icons.bookmark;
    } else if (stat == 'crosswords') {
      iconItem = Icons.close;
    } else if (stat == 'streak') {
      iconItem = Icons.bolt;
    }

    return SizedBox(
      width: 35,
      child: Stack(
        children: [
          Icon(
            iconItem,
            size: 16,
            color: textColor,
          ),
          Positioned(
            left: 14.0,
            top:-3,
            child: Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:"x",
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor
                      )
                  ),
                  TextSpan(
                    text: data.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor
                    )
                  ),
                ],
              ),
            ),          
          )
      
        ],
      ),
    );
  }  

  TableRow scoreSummaryTableRow(int index, ColorPalette palette, Map<String,dynamic> data, BuildContext context, String language) {

    Color textColor = data['turn'].isEven ? palette.textColor1 : palette.textColor3;
    String word = data["word"];


    return TableRow(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${(index+1).toString()}.",
          style: TextStyle(
            color: textColor,
            fontSize: 20
          ),
        ),
      ),
      Row(
        children: [
          GestureDetector(
            child: Text(
              data['word'],
              style: TextStyle(
                color: textColor,
                fontSize: 20,
              ),
            ),
            onTap: () {
              showDialog(
                context: context, 
                builder:(context) {
                  return FutureBuilder<String>(
                    future: GameLogic().fetchDefinition(data["word"], language),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return AlertDialog(
                          backgroundColor: palette.optionButtonBgColor,
                          title: Text(
                            word,
                            style: TextStyle(
                              color: palette.textColor2
                            ),
                          ),
                          content:SizedBox()  //Text("Fetching definition..."),
                        );
                      } else if (snapshot.hasError) {
                        return AlertDialog(
                          backgroundColor: palette.optionButtonBgColor,
                          title: Text(
                            word,
                            style: TextStyle(
                              color: palette.textColor2
                            ),
                          ),
                          content: Text(
                            "Error fetching definition",
                            style: TextStyle(
                              color: palette.textColor2
                            ),                            
                          ),
                        );
                      } else {
                        return AlertDialog(
                          backgroundColor: palette.optionButtonBgColor,
                          title: Text(
                            word,
                            style: TextStyle(
                              color: palette.textColor2
                            ),
                          ),
                          content: Text(
                            snapshot.data ?? "No definition available",
                            style: TextStyle(
                              color: palette.textColor2
                            ),                            
                          ),
                        );
                      }                    
                    },
      
                  );
                },
              );
            },
          ),
          SizedBox(width: 10,),
          Expanded(child: SizedBox()),
          data['count'] > 1 ? multiplierIcon('count',data['turn'], data['count'], palette) : const SizedBox(),
          data['crosswords'] > 1 ? multiplierIcon('crosswords',data['turn'], data['crosswords'], palette) : const SizedBox(),
          data['streak'] > 1 ? multiplierIcon('streak',data['turn'], data['streak'], palette) : const SizedBox(),
        ],
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          data['points'].toString(),
          style: TextStyle(color: textColor, fontSize: 20),
          textAlign: TextAlign.right,
        ),
      ),
    ]);
  }

  String translateText(String language, String originalString,) {
    // print(originalString);
    late Map<String,dynamic> languageMap = translations.firstWhere((element) => element['key'] == originalString);
    return languageMap['data'][language];
  }

  String translateDemoSequence(String language, String originalString,) {
    String res = "";
    String translatedBody = translateText(language, originalString);
    late Map<String,dynamic> dynamicLetters = demoStateDynamicLetters[language];
    dynamicLetters.forEach((key, value) {
      translatedBody = translatedBody.replaceAll(key, value);
    });
    return translatedBody;
  }







}
