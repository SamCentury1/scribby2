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
    Color textColor = index.isEven ? palette.textColor1 : palette.textColor3;
    Color rowColor = index.isEven ? palette.optionButtonBgColor2 : palette.optionButtonBgColor3;
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
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18*sizeFactor
                    ),
                  )
                )
              ],
            ),
          ),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (Map<String,dynamic> word in words)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: Text(
                      word['word'],
                      style: TextStyle(
                        color: textColor,
                        fontSize: (18 * sizeFactor),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context, 
                        builder:(context) {
                          return FutureBuilder<String>(
                            future: GameLogic().fetchDefinition(word["word"], language),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return AlertDialog(
                                  backgroundColor: palette.optionButtonBgColor,
                                  title: Text(
                                    word['word'],
                                    style: TextStyle(
                                      color: palette.textColor2,
                                      fontSize: 18 * sizeFactor
                                    ),
                                  ),
                                  content:SizedBox()  //Text("Fetching definition..."),
                                );
                              } else if (snapshot.hasError) {
                                return AlertDialog(
                                  backgroundColor: palette.optionButtonBgColor,
                                  title: Text(
                                    word['word'],
                                    style: TextStyle(
                                      color: palette.textColor2,
                                      fontSize: 18 * sizeFactor
                                    ),
                                  ),
                                  content: Text(
                                    "Error fetching definition",
                                    style: TextStyle(
                                      color: palette.textColor2,
                                      fontSize: 18 * sizeFactor
                                    ),                            
                                  ),
                                );
                              } else {
                                return AlertDialog(
                                  backgroundColor: palette.optionButtonBgColor,
                                  title: Text(
                                    word['word'],
                                    style: TextStyle(
                                      color: palette.textColor2,
                                      fontSize: 18 * sizeFactor
                                    ),
                                  ),
                                  content: Text(
                                    snapshot.data ?? "No definition available",
                                    style: TextStyle(
                                      color: palette.textColor2,
                                      fontSize: 18  * sizeFactor
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
                )
              ],
            ),
            const Expanded(child: SizedBox(),),
            Row(
              children: [
                data['count'] > 1 ? multiplierIcon('count',index, data['count'], palette, sizeFactor) : const SizedBox(),
                data['crossword'] > 1 ? multiplierIcon('crosswords',index, data['crossword'], palette, sizeFactor) : const SizedBox(),
                data['streak'] > 1 ? multiplierIcon('streak',index, data['streak'], palette, sizeFactor) : const SizedBox(),

              ],
            ),
            const Expanded(child: SizedBox(),),          
          ],
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
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18*sizeFactor
                    ),
                  )
                )
              ],
            ),          
            // child: Text(
            //   data['points'].toString(),
            //   style: TextStyle(color: textColor, fontSize: (20 * sizeFactor)),
            //   textAlign: TextAlign.right,
            // ),
          ),
        ),
        // Table(
        //   columnWidths: const <int, TableColumnWidth>{
        //     0: FlexColumnWidth(1),
        //     1: FlexColumnWidth(7),
        //     2: FlexColumnWidth(2),
        //   },
        //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        //   children: <TableRow>[
        //     for (Map<String,dynamic> item in data['words'])
        //     TableRow(

        //     )
        //   ]
          
        // )    
      ]
    );
  }
  TableRow scoreSummaryTableRow(int index, ColorPalette palette, Map<String,dynamic> data, BuildContext context, String language, double sizeFactor) {

    Color textColor = data['turn'].isEven ? palette.textColor1 : palette.textColor3;
    String word = data["word"];


    return TableRow(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${(index+1).toString()}.",
          style: TextStyle(
            color: textColor,
            fontSize: (20 * sizeFactor)
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
                fontSize: (20 * sizeFactor),
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
                              color: palette.textColor2,
                              fontSize: 18 * sizeFactor
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
                              color: palette.textColor2,
                              fontSize: 18 * sizeFactor
                            ),
                          ),
                          content: Text(
                            "Error fetching definition",
                            style: TextStyle(
                              color: palette.textColor2,
                              fontSize: 18 * sizeFactor
                            ),                            
                          ),
                        );
                      } else {
                        return AlertDialog(
                          backgroundColor: palette.optionButtonBgColor,
                          title: Text(
                            word,
                            style: TextStyle(
                              color: palette.textColor2,
                              fontSize: 18 * sizeFactor
                            ),
                          ),
                          content: Text(
                            snapshot.data ?? "No definition available",
                            style: TextStyle(
                              color: palette.textColor2,
                              fontSize: 18  * sizeFactor
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
          // data['count'] > 1 ? multiplierIcon('count',data['turn'], data['count'], palette) : const SizedBox(),
          // data['crosswords'] > 1 ? multiplierIcon('crosswords',data['turn'], data['crosswords'], palette) : const SizedBox(),
          // data['streak'] > 1 ? multiplierIcon('streak',data['turn'], data['streak'], palette) : const SizedBox(),
        ],
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          data['points'].toString(),
          style: TextStyle(color: textColor, fontSize: (20 * sizeFactor)),
          textAlign: TextAlign.right,
        ),
      ),
    ]);
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

    print("language $languageRaw");
    if (languageRaw == "") {
      res = "";
    } else {
      String language = translationMap[languageRaw];
      print("languageMap['data'][language.toLowerCase()] = ${languageMap['data'][language.toLowerCase()]}");
      res = languageMap['data'][language.toLowerCase()];
    }
    print("translateText = $res");
    // return languageMap['data'][language];
    return res;    
  }

  String translateText(String languageRaw, String originalString,) {
    // print(originalString);
    // String res = '';
    // late Map<String,dynamic> languageMap = translations.firstWhere((element) => element['key'] == originalString);

    // print("language $languageRaw");
    // if (languageRaw == "") {
    //   res = "";
    // } else {
    //   String language = translationMap[languageRaw];
    //   print("languageMap['data'][language.toLowerCase()] = ${languageMap['data'][language.toLowerCase()]}");
    //   res = languageMap['data'][language.toLowerCase()];
    // }
    // print("translateText = $res");
    // // return languageMap['data'][language];
    // return res;
    late Map<String,dynamic> languageMap = translations.firstWhere((element) => element['key'] == originalString);
    return languageMap['data'][languageRaw.toLowerCase()];
  }

  String translateDemoSequence(String language, String originalString,) {
    print("language = $language");
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


  void getSizeFactor(SettingsState settingsState, double screenHeight) {
    double res = 1.0;
    if (screenHeight <= 801 ) {
      res = 0.75;
    }

    settingsState.setSizeFactor(res);
  }










}
