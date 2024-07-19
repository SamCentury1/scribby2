import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/models/tile_model.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
// import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';
// import 'package:scribby_flutter_v2/utils/translations.dart';
import 'package:http/http.dart' as http;

class Helpers {
  
  // String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String formatWord(String s) {
    String lower = s.toLowerCase();
    String newString = lower[0].toUpperCase() + lower.substring(1);
    return newString;
  } 

  String fixForCharacter(String s, String character) {
    List<String> strings = s.split(character);
    List<String> newList = [];
    for (String item in strings) {
      // newList.add(capitalize(item));
      newList.add(item);
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


List<dynamic> createCopyOfAlphabet(SettingsState settingsState) {
  final List<dynamic> originalAlphabet = settingsState.alphabetCopy;

  List<dynamic> alphabetCopy = [];
  for (Map<String, dynamic> alphabetObject in originalAlphabet) {
    // Create a deep copy of each map in the list
    Map<String, dynamic> newObject = Map<String, dynamic>.from(alphabetObject);
    alphabetCopy.add(newObject);
  }
  return alphabetCopy;
}

  void getStates(GamePlayState gamePlayState, SettingsController settings, SettingsState settingsState){

    List<dynamic> alphabet = createCopyOfAlphabet(settingsState);

    
    if (alphabet.isNotEmpty) {

      final List<dynamic> _initialBoardState = settings.initialTileState.value as List<dynamic>;
      Map<String, dynamic> startingStates = generateStartingStates(alphabet, _initialBoardState, []);

      late List<Map<String, dynamic>> startingAlphabetState = startingStates['startingAlphabet'];
      late List<String> randomLetterListState = startingStates['startingRandomLetterList'];

      late List<int> randomShadeListState = startingStates['startingRandomShadeList'];

      late List<int> randomAngleListState = startingStates['startingRandomAngleList'];
      late List<dynamic> startingTileState = startingStates['startingTileState'];

      gamePlayState.setAlphabetState(startingAlphabetState);
      gamePlayState.setRandomLetterList(randomLetterListState);
      gamePlayState.setRandomShadeList(randomShadeListState);
      gamePlayState.setRandomAngleList(randomAngleListState);
      gamePlayState.setTileState(startingTileState);
    } else {

    }
  }

  Map<dynamic,dynamic> getTileObject(GamePlayState gamePlayState, int index) {
    late Map<dynamic,dynamic> tileObject = gamePlayState.tileState.firstWhere((element) => element["index"] == index);
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

  Widget multiplierData(String element, int value, double tileSize, Color color) {
    late Icon icon;
    if (element == 'streak') {
      icon = Icon(Icons.bolt, color: color, size: tileSize*0.35);
    } else if (element == 'words') {
      icon = Icon(Icons.library_books, color: color, size: tileSize*0.35);
    } else if (element == 'crossWord') {
      icon = Icon(Icons.close, color: color, size: tileSize*0.35);
    }
    final Widget res = Padding(
      padding: EdgeInsets.symmetric(horizontal: tileSize*0.05),
      child: Container(
        // color: Colors.orange,
        width: tileSize*0.4,
        height: tileSize*0.6,
        child: Stack(
          children: [
            Positioned(
              // left: element == 'streak' ? 0 : -5.0,
              left: 0,
              top: 0.0,
              child: icon
            ),
            Positioned(
              bottom: 0,
              // right: element == 'streak' ? 10 : 5,
              right: 0,
              child: DefaultTextStyle(
                child: Text(
                  value.toString(),
                ),
                style: TextStyle(
                  fontSize: tileSize*0.25,
                  color: color
                ),
              ),
            )        
        
          ],
        ),
      ),
    );

    if (value < 2) {
      return SizedBox();
    } else {
      return res;
    }
  }


  TableRow scoreSummaryTableRow2(
    int index, 
    ColorPalette palette, 
    Map<String,dynamic> data, 
    BuildContext context, 
    String language, 
    double tileSize, 
    ) {
    Color textColor = palette.overlayText;  //index.isEven ? palette.textColor2 : palette.fullTileTextColor ;
    // Color rowColor1 = index.isEven ? Colors.transparent : palette.tileGradientShade2Color1;
    // Color rowColor2 = index.isEven ? Colors.transparent : palette.tileGradientShade2Color2;
    List<Map<String,dynamic>> words = data["wordValues"];

    SettingsState settingsState = context.read<SettingsState>();

    // return TableRow();

    return TableRow(
      decoration: BoxDecoration(
        // color: rowColor,
        // gradient: LinearGradient(
        //   begin: Alignment.bottomLeft,
        //   end: Alignment.topRight,
        //   colors: [
        //     rowColor1,
        //     rowColor2,
        //   ]
        // )
        color: Colors.transparent
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: tileSize*0.05),
          child: Align(
            alignment: Alignment.centerLeft,
            child: DefaultTextStyle(
              child: Text(
                data['turn'].toString()
              ),
              style: TextStyle(
                fontSize: tileSize*0.3,
                color: textColor
              ),
            ),
            // child: Column(
            //   children: [
            //     for (Map<String,dynamic> word in words)
            //     Align(
            //       alignment: Alignment.centerLeft,
            //       child: DefaultTextStyle(
            //         child: Text(
            //           word['index'].toString(),
            //         ),
            //         style: customTextStyle(textColor, tileSize*0.3),
            //       )
            //     )
            //   ],
            // ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (Map<String,dynamic> word in words)
            Padding(
              padding: EdgeInsets.symmetric(vertical: tileSize*0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  child: DefaultTextStyle(
                    child: Text(
                      word['word'],
                    ),
                    style: customTextStyle(textColor, tileSize*0.3),
                  ),
                  onTap: () {
                    showDialog(
                      context: context, 
                      builder:(context) {
                        return FutureBuilder<Map<String,dynamic>>(
                          future: fetchDefinition(word["word"], language, settingsState),
                          builder: (context, snapshot) {
                            late Map<String,dynamic> res = {};
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              res = {"result" : "loading", "data": translateText(language, "loading...",settingsState)};
                              return wordDefinitionDialog(palette, tileSize,word['word'],res,language);
                            } else if (snapshot.hasError) {
                              res = {"result" : "fail", "data": translateText(language,"Error fetching definition",settingsState)};
                              return wordDefinitionDialog(palette, tileSize,word['word'],res,language);
                            } else {
                              if (snapshot.data != null) {
                                return wordDefinitionDialog(palette, tileSize,word['word'], snapshot.data!,language);
                              } else {
                                res = {"result" : "fail", "data": translateText(language, "No definition available at this time",settingsState)};
                                return wordDefinitionDialog(palette, tileSize,word['word'],res,language);
                              }
                            }                    
                          },
                        
                        );
                      },
                    );
                  },
                ),
              ),
            ),       
          ],
        ),

        Align(
          alignment: Alignment.center,
          child: Center(
            child: Row(
              children: [
                multiplierData('streak',data['streak'],tileSize,textColor),
                multiplierData('words',data['words'],tileSize,textColor),
                multiplierData('crossWord',data['crossWord'],tileSize,textColor),
              ],
            ),
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
                  child: DefaultTextStyle(
                    child: Text(
                      word['totalScore'].toString(),
                    ),
                    style: customTextStyle(textColor, tileSize*0.3),
                  )
                )
              ],
            ),

          ),
        ),
 
      ]
    );
  }


  String translateWelcomeText(String languageRaw, String originalString, SettingsState settingsState) {
    String res = '';
    late Map<dynamic,dynamic> languageMap = settingsState.translations.firstWhere((element) => element['key'] == originalString);
    late Map<dynamic,dynamic> translationMap = {
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

  String translateText(String languageRaw, String originalString,SettingsState settingsState) {

    try {
      late Map<dynamic,dynamic> languageMap = settingsState.translations.firstWhere((element) => element['key'] == originalString);
      return languageMap['data'][languageRaw.toLowerCase()];
    } catch (e) {
      return originalString;
    }
  }

  String translateDemoSequence(String language, String originalString, Map<dynamic,dynamic> demoStateDynamicLetters, SettingsState settingsState) {
    if (language == "") {
      return "";
    } else {

      String translatedBody = translateText(language.toLowerCase(), originalString,settingsState);
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

  double getTileSize(double screenWidth) {
    double updatedWidth = screenWidth;
    if (screenWidth > 600) {
      updatedWidth = 600;
    }
    double tileSize = (updatedWidth*0.9)/6;
    return tileSize;

  }

  double getScreenWidth(double currentScreenWidth, double sizeFactor) {
    double res = currentScreenWidth;
    if (currentScreenWidth > 500) {
      res = 500;
    }
    return res*sizeFactor;
  }


  bool checkForBadWords(String name) {
    List<String> badWords = ["faggot", "faggit", "fagot","nigger","retard","nigga","bitch","cunt",];
    bool badWordFound = false;
    for (String word in badWords) {
      if (name.contains(word)) {
        badWordFound = true;
        
      } 
    }
    return badWordFound;
  }

  void showUserNameSnackBar(BuildContext context,ColorPalette palette, double tileSize,String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: palette.fullTileTextColor,
            fontSize: tileSize*0.3
          ),
        ),
        duration: const Duration(milliseconds: 3000),
      )
    );    
  }

  List<Widget> getDefinitions(List<dynamic> definitions, double tileSize, ColorPalette palette, String language) {

    late List<Widget> cols = [];

    if (language =='english') {
      for (int i=0; i<definitions.length; i++) {


        if (definitions[i] is Map<String, dynamic>) {

          String partOfSpeech = "";
          String string = "";
          final Map<String, dynamic> something = definitions[i] as Map<String, dynamic>;
          partOfSpeech = something["partOfSpeech"];
          string = something["string"];
          late List<TableRow> rows = [];
          late TableRow partOfSpeechRow = TableRow(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "${(i+1).toString()}. ",
                  style: TextStyle(
                    color: palette.textColor2,
                    fontWeight: FontWeight.w800,
                    fontSize: tileSize*0.20 
                  ),
                ),            
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  // partOfSpeech,
                  partOfSpeech,
                  style: TextStyle(
                    color: palette.textColor2,
                    fontWeight: FontWeight.w800,
                    fontSize: tileSize*0.20, 
                  ),
                ),            
              ),
            ]
          );
          rows.add(partOfSpeechRow);
          late TableRow definitionRow = TableRow(
            children: [
              SizedBox(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  // string,
                  string,
                  style: TextStyle(
                    color: palette.textColor2,
                    fontSize: tileSize*0.20           
                  ),
                ),            
              ),          
            ]
          );
          rows.add(definitionRow);
          late Table tableRes = Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(9),
            },
            defaultVerticalAlignment:TableCellVerticalAlignment.middle,
            children: rows,
          );  
          cols.add(tableRes);
          cols.add(Divider(color: palette.textColor2,thickness: tileSize*0.01,));

        }

      }
    } else {
      for (int i=0; i<definitions.length; i++) {
        final String definition = definitions[i];
        late List<TableRow> rows = [];
        late TableRow definitionRow = TableRow(
          children: [
            Container(
              // color: Colors.red,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "${(i+1).toString()}. ",
                      style: TextStyle(
                        color: palette.textColor2,
                        fontWeight: FontWeight.w800,
                        fontSize: tileSize*0.20 
                      ),
                    ),            
                  ),
                  
                ]
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                definition,
                style: TextStyle(
                  color: palette.textColor2,
                  fontSize: tileSize*0.20, 
                ),
              ),            
            ),
          ]
        );
        rows.add(definitionRow);
        late Table tableRes = Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(9),
          },
          defaultVerticalAlignment:TableCellVerticalAlignment.middle,
          // border: TableBorder(bottom: BorderSide(width: 0.5, color: palette.textColor2, style: BorderStyle.solid)),     
          children: rows,
        );  
        cols.add(tableRes);
        final Divider divider = Divider(thickness: 1, color: palette.textColor2.withOpacity(0.2),);
        cols.add(divider);            
      }
    }

    return cols;
  }

  Widget wordDefinitionDialog(ColorPalette palette, double tileSize, String wordText, Map<String,dynamic> definition, String language) {

    List<Widget> definitions = [];
    if (definition['result'] != 'success') {

      Text(definition['data']);
    } else {

      if (language == 'english') {
        definitions = getDefinitions(definition['data']['data'], tileSize, palette, language);
      } else {
        definitions = getDefinitions(definition['data'], tileSize, palette, language);
      }      
    }


    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(tileSize*0.2))
      ),
      child: Container(
        decoration: BoxDecoration(
          color: palette.modalBgColor,
          // gradient: LinearGradient(
          //   begin: Alignment.bottomCenter,
          //   end: Alignment.topCenter,
          //   colors: [
          //     palette.screenGradientBackgroundColor1,
          //     palette.screenGradientBackgroundColor2
          //   ]
          // ),
          borderRadius: BorderRadius.all(Radius.circular(tileSize*0.2))
        ),

        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: tileSize*10
          ),
          child: Padding(
            padding: EdgeInsets.all(tileSize*0.2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  wordText,
                  style: TextStyle(
                    color: palette.textColor2,
                    fontSize: tileSize*0.3
                  ),
                ),
            
                Divider(color: palette.textColor2,thickness:tileSize*0.01),
                definition['result'] != 'success' ? Text(definition['data'],style: TextStyle(color: palette.modalTextColor),) : 
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: definitions
                    ),
                  ),
                )
                
            
              ],
            ),
          ),
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

  bool getIsInWord(GamePlayState gamePlayState, String tileId) {
    List<dynamic> idsInWord = gamePlayState.validIds.map((e) => e['tileId']).toList();
    if (idsInWord.contains(tileId)) {
      return true;
    } else {
      return false;
    }
  } 

  List<Map<String,dynamic>> getRandomDecorativeSquareDetails(double w, double h) {

    final double quadrantHeight = h/4;
    final double quadrantWidth = w/3;
    
    
    
    final Map<int,dynamic> coordinateMap = {
      0: {'left': 0, 'top': 0},
      1: {'left': 1, 'top': 0},
      2: {'left': 2, 'top': 0},
      3: {'left': 0, 'top': 1},
      4: {'left': 1, 'top': 1},
      5: {'left': 2, 'top': 1},
      6: {'left': 0, 'top': 2}, 
      7: {'left': 1, 'top': 2},
      8: {'left': 2, 'top': 2},
      9: {'left': 0, 'top': 3},
      10: {'left': 1, 'top': 3}, 
      11: {'left': 2, 'top': 3},          
    };


    List<Map<String,dynamic>> res = [];
    for (int i=0; i<11; i++) {
      Random rand = Random();
      Map<String,dynamic> quadrantObject = coordinateMap[i];

      double minTop = quadrantObject['top']*quadrantHeight;
      double maxTop = (quadrantObject['top']+1)*quadrantHeight;
      double minLeft = quadrantObject['left']*quadrantWidth;
      double maxLeft = (quadrantObject['left']+1)*quadrantWidth;      

      int top = (rand.nextInt(maxTop.round()-minTop.round())+minTop).round();
      int left = (rand.nextInt(maxLeft.round()-minLeft.round())+minLeft).round();
      
      int angle = rand.nextInt(16) + 1;
      int size = rand.nextInt(150 - 50) + 50;
      final double opacity =  (rand.nextInt(10) + 5)/100; 
      Map<String,dynamic> details = {"top": top, "left": left, "angle": angle, "size": size, "opacity":opacity};
      res.add(details);
    }
    return res;
  }

  Map<String, dynamic> startingRandomLetterData(List<dynamic> alphabetState) {
    // initialize Random
    Random random = Random();

    // first, get a list of all letters
    late List<String> availableLetters = [];
    for (Map<String, dynamic> letter in alphabetState) {
      for (var i = 0; i < letter['count']; i++) {
        availableLetters.add(letter['letter']);
      }
    }


    // select a random number to pick from the first letter
    int randomIndex1 = random.nextInt(availableLetters.length);

    String randomLetter1 = availableLetters[randomIndex1];
    int randomShade1 = random.nextInt(5);
    int randomAngle1 = random.nextInt(5);    

    // remove the letter from the list so we don't get a duplicate
    availableLetters.removeWhere((element) => element == randomLetter1);

    // select from the updated list
    int randomIndex2 = random.nextInt(availableLetters.length);
    String randomLetter2 = availableLetters[randomIndex2];
    int randomShade2 = random.nextInt(5);
    int randomAngle2 = random.nextInt(5);      



    List<String> startingRandomLetterList = [randomLetter1, randomLetter2];
    List<int> startingShadeList = [randomShade1, randomShade2];
    List<int> startingAngleList = [randomAngle1, randomAngle2];

    List<Map<String, dynamic>> alphabetState1 = [];
    for (Map<String, dynamic> letterObject in alphabetState) {
      if (letterObject["letter"] == randomLetter1) {
        letterObject.update("count", (value) => letterObject["count"]-1);
        letterObject.update("count", (value) => letterObject["count"]+1);
      }
      alphabetState1.add(letterObject);
    }

    List<Map<String, dynamic>> alphabetState2 = [];
    for (Map<String, dynamic> letterObject in alphabetState1) {
      if (letterObject["letter"] == randomLetter2) {
        letterObject.update("count", (value) => letterObject["count"]-1);
        letterObject.update("count", (value) => letterObject["count"]+1);      
      }
      alphabetState2.add(letterObject);
    }

    final Map<String, dynamic> startingRandomLetterData = {
      "list": startingRandomLetterList,
      "shadeList" : startingShadeList,
      "angleList": startingAngleList,
      "state": alphabetState2
    };
    return startingRandomLetterData;
  }


  List<Map<String,dynamic>> adjustAlphabet(Map<String, dynamic> startingRandomLetterStates) {
    late List<Map<String, dynamic>>  startingAlphabet = startingRandomLetterStates['state'];
    late List<String> startingRandomLetterList = startingRandomLetterStates['list'];

    for (String letter in startingRandomLetterList) {
      Map<String,dynamic> alphabetLetterObject = startingAlphabet.firstWhere((element) => element['letter'] == letter);
      int count = alphabetLetterObject['count'];
      int inPlay = alphabetLetterObject['inPlay'];
      alphabetLetterObject.update('count', (value) => (count-1));
      alphabetLetterObject.update('inPlay', (value) => (inPlay+1));
    }
    return startingAlphabet;
  }  

  Map<String, dynamic> generateStartingStates(
    // List<Map<String,dynamic>> initialRandomLetterState,
    List<dynamic> letterState,
    List<dynamic> initialTileState,
    List<String> initialRandomLetterList,
    // GamePlayState gamePlayState,
  ) {



    // late List<Map<String, dynamic>> startingAlphabet = [];
    late List<dynamic> startingTileState = [];
    late List<String> startingRandomLetterList = [];
    late List<int> startingRandomShadeList = [];
    late List<int> startingRandomAngleList = [];


    late Map<String, dynamic> startingRandomLetterStates = startingRandomLetterData(letterState);
    

    // late Map<String,dynamic> startingRandomLetterStates = startingRandomLetterData(gamePlayState.alphabetState);
    // startingAlphabet = startingRandomLetterStates['state'];
    startingRandomLetterList = startingRandomLetterStates['list'];
    startingRandomShadeList = startingRandomLetterStates['shadeList'];
    startingRandomAngleList = startingRandomLetterStates['angleList'];
    startingTileState = initialTileState ;

    late List<Map<String, dynamic>> adjustedAlphabet = adjustAlphabet(startingRandomLetterStates);
    

    late Map<String, dynamic> res = {
      "startingAlphabet": adjustedAlphabet,
      "startingRandomLetterList": startingRandomLetterList,
      "startingRandomShadeList" : startingRandomShadeList,
      "startingRandomAngleList" : startingRandomAngleList,
      "startingTileState": startingTileState
    };
    return res;
  }

  Future<Map<String,dynamic>> fetchDefinition(String word, String language, SettingsState settingsState) async {

    Map<String,dynamic> res = {};

    if (language == 'english') {

      String baseUrl_1 = "https://firebasestorage.googleapis.com/v0/b/scribby-6934e.appspot.com/o/definitions%2F";

      String baseUrl_2 = "%2F";
   
      String baseUrl_3 = ".json?alt=media&token=511d5629-7808-4821-a455-b66360cbf707";
      
      String url = baseUrl_1 + language + baseUrl_2 + word + baseUrl_3;

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final Map<String,dynamic> jsonMap = json.decode(decodedBody);

        // late String def = "Defintions temporarily unavailable";
        res = {
          "result" : "success",
          "data": jsonMap,
        };


      } else {

        res = {
          "result" : "fail",
          "data": Helpers().translateText(language, "No definition available at this time",settingsState)
        };        
        // res = Helpers().translateText(language, "No definition available at this time");
      }

    } else {

      String baseUrl_1 = "https://firebasestorage.googleapis.com/v0/b/scribby-6934e.appspot.com/o/definitions%2F";

      String baseUrl_2 = "%2F";
   
      String baseUrl_3 = ".json?alt=media&token=511d5629-7808-4821-a455-b66360cbf707";
      
      String url = baseUrl_1 + language + baseUrl_2 + word + baseUrl_3;

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // dynamic jsonResponse = json.decode(response.body);
        final String decodedBody = utf8.decode(response.bodyBytes);
        final Map<String,dynamic> jsonMap = json.decode(decodedBody);
        res = {
          "result": "success",
          "data": jsonMap['data']
        };
        // res = jsonMap['data'][0];
      } else {
        res = {
          "result" : "fail",
          "data": Helpers().translateText(language, "No definition available at this time",settingsState)
        };
        // res = Helpers().translateText(language, "No definition available at this time");
      }      
    }

    return res;
  }

  int getCountdownDuration(int level) {
    int res = 10;
    switch (level) {
      case 1:
        res = 10; 
        break;
      case 2:
        res = 9;
        break;
      case 3:
        res = 8;
        break;
      case 4:
        res = 7;
        break;
      case 5:
        res = 6;
        break;
      case 6:
        res = 5;
        break;
      case 7:
        res = 4;
        break;
      case 8:
        res = 3;
        break;
      case 9:
        res = 2;
        break;
      case 10:
        res = 1;
        break;
    }
    return res;
  }  

  String displayDemoTileLetter( List<Map<dynamic, dynamic>> letterState, String tileId, String language, Map<dynamic,dynamic> demoStateDynamicLetters) {
    String res = "";
    final Map<dynamic, dynamic> correspondingTileState = letterState.firstWhere((element) => element["tileId"] == tileId);
    String index = correspondingTileState["letter"];
    if (index != "") {
      res = demoStateDynamicLetters[language][index];
    }

    return res;
  }  

  Map<dynamic, dynamic> getTileState(List<Map<dynamic, dynamic>> letterState, String tileId) {
    return letterState.firstWhere((element) => element["tileId"] == tileId);
  }



  // THIS FUNCTION TAKES IN THE BOARD LETTER STATE AND DISPLAYS IT
  String displayTileLetter(
      List<Map<String, dynamic>> letterState, String tileId) {
    String res = "";
    final Map<String, dynamic> correspondingTileState =
        letterState.firstWhere((element) => element["tileId"] == tileId);
    res = correspondingTileState["letter"];
    return res;
  }

  String formatTimeDigit(int digit) {
    String res = "";
    if (digit >= 0 && digit <= 9) {
      res = "0$digit";
    } else {
      res = "$digit";
    }
    return res;
  }

  String formatTime(int timeInSeconds) {
    String res = "";

    late Map<String, dynamic> timeData = getTimeData(timeInSeconds);

    String formattedHours = formatTimeDigit(timeData['hours']);
    String formattedMinutes = formatTimeDigit(timeData['minutes']);
    String formattedSeconds = formatTimeDigit(timeData['seconds']);

    if (timeData['hours'] >= 1) {
      res = "$formattedHours:$formattedMinutes:$formattedSeconds";
    } else {
      res = "$formattedMinutes:$formattedSeconds";
    }

    return res;
  }


  Map<String, dynamic> getTimeData(int currentSeconds) {
    late double hours = 0;
    late double minutes = 0;
    late double seconds = 0;

    seconds = (currentSeconds % 60);

    late double absoluteMinutes = (currentSeconds - seconds) / 60;

    if (currentSeconds >= 3600) {
      late double secondsExtraFromHour = (currentSeconds % 3600);
      late double hoursInSeconds = currentSeconds - secondsExtraFromHour;

      hours = hoursInSeconds / 3600;
      minutes = (absoluteMinutes % 60);
    } else {
      minutes = (currentSeconds - seconds) / 60;
    }

    final Map<String, dynamic> res = {
      "hours": hours.round(),
      "minutes": minutes.round(),
      "seconds": seconds.round(),
    };
    return res;
  }



  void executeWordFoundSounds(AudioController audioController, int hits) {
    for (int i=0; i<hits; i++) {
      Future.delayed(Duration(milliseconds: i*200), () {
        audioController.playSfx(SfxType.wordFound);
      });      
    }
  }

  void executeStreakSound(AudioController audioController, GamePlayState gamePlayState) {
    late Map<String,dynamic> scoreLog = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1];
    if (scoreLog['streak'] >=2) {
      Future.delayed(Duration(milliseconds: 300), () {
        audioController.playSfx(SfxType.streak);
      });    
    }
  }  
  
  void executeCrossWordSound(AudioController audioController, GamePlayState gamePlayState) {
    late Map<String,dynamic> scoreLog = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1];
    if (scoreLog['crossWord'] ==2) {
      Future.delayed(Duration(milliseconds: 300), () {
        audioController.playSfx(SfxType.crossWord);
      });    
    }    
  }

  Map<int,dynamic> getTileAnimationOrder(GamePlayState gamePlayState) {

    /// find out if it's a cross word
    List<Map<String,dynamic>> validIds = gamePlayState.validIds;
    List<int> ids = [];
    List<Map<String,dynamic>> values = [];
    Map<int,dynamic> res = {};
    Map<int,dynamic> rowCounts = {1:0,  2:0,  3:0,  4:0,  5:0, 6:0};
    Map<int,dynamic> colCounts = {1:0,  2:0,  3:0,  4:0,  5:0, 6:0};
    for(Map<String,dynamic> validIdObject in validIds) {
      Map<dynamic,dynamic> correspondingTileObject = gamePlayState.tileState.firstWhere((e) => e['index']==validIdObject['id']);
      String tileId = correspondingTileObject['tileId'];
      int row = int.parse(tileId.split("_")[0]);
      int col = int.parse(tileId.split("_")[1]);      
      if (!ids.contains(validIdObject['id'])) {
        values.add({"index": validIdObject['id'], "id" :tileId, "row": row, "col": col, "order": 0});
        ids.add(validIdObject['id']);
        res[validIdObject['id']] = 0;
      }
      rowCounts[row]++;
      colCounts[col]++;
    }
    Map<String,dynamic> highestRow = getAxis(rowCounts);
    Map<String,dynamic> highestCol = getAxis(colCounts);
    /// IF CROSSWORD MIDDLE PIECE IS ORDER 0 
    if (highestRow['count'] > 1 && highestCol['count'] > 1) {
      int centerCol = highestCol["item"];
      int centerRow = highestRow["item"];
      for (Map<String,dynamic> valueObject in values) {
        int row = valueObject['row'];
        int col = valueObject['col']; 
        if (row == centerRow && col == centerCol ) {
          valueObject['order'] = 0;
          res[valueObject['index']] = 0;
        } else  if (row == centerRow) {
          // int col = col;
          int order = (centerCol - col).abs();
          valueObject['order'] = order;
          res[valueObject['index']] = order;
        } else if (col == centerRow) {
          int order = (centerRow - row).abs();
          valueObject['order'] = order;
          res[valueObject['index']] = order;
        }
      }
    }
    // IF ROW
    else  {
      List<dynamic> indexes = values.map((e) => e['index']).toList();
      indexes.sort();
      for (Map<String,dynamic> valueObject in values) {
        int order = indexes.indexOf(valueObject['index']);
        valueObject['order'] = order;
        res[valueObject['index']] = order;
      }
    }
    return res;
  }

  Map<String,dynamic> getAxis(Map<int,dynamic> values) {
    var thevalue=0;
    var thekey;
    values.forEach((k,v){
      if(v>thevalue) {
        thevalue = v;
        thekey = k;
      }
    });
    return {"item" : thekey, "count": thevalue}; 
  }


  double showEffectsTimerUnderThreeSeconds(GamePlayState gamePlayState, double duration) {
    double res = 0.0;
    if (duration < 3 && !gamePlayState.countDownController.isPaused) {
      res = 1.0;
    }
    return res;
  }  

  List<int> getUniqueValidIds(List<Map<String,dynamic>> validIds ) {
    List<int> uniques = [];
    for (Map<String,dynamic> item in validIds) {
      if (!uniques.contains(item['id'])) {
        uniques.add(item['id']);
      }
    }
    uniques.sort();
    return uniques;
  }

  void updateRandomLetterDataAfterWordFound(GamePlayState gamePlayState) {
    /// get the unique ids
    List<int> ids = [];
    List<String> letters = [];
    for (Map<String,dynamic> item in gamePlayState.validIds) {
      if (!ids.contains(item['id'])) {
        ids.add(item['id']);
        letters.add(item['body']);

      }
    }
    List<Map<String,dynamic>> copyOfAlphabetState = gamePlayState.alphabetState; 
    for (String letter in letters) {
      Map<String,dynamic> letterObject = copyOfAlphabetState.firstWhere((element) => element['letter']==letter);
      int inPlay = letterObject['inPlay'];
      int count = letterObject['count'];
      letterObject.update('inPlay', (value) => inPlay-1);
      letterObject.update('count', (value) => count+1);
    }
    gamePlayState.setAlphabetState(copyOfAlphabetState);
  }

  bool getWasCrossWord(GamePlayState gamePlayState) {
    bool res = false;
    
    List<int> rows = [];
    List<int> cols = [];
    List<int> ids = [];
    for (Map<String,dynamic> validIdObject in gamePlayState.validIds) {
      if (!ids.contains(validIdObject['id'])) {
        Map<dynamic,dynamic> tileObject = gamePlayState.tileState.firstWhere((element) => element['index']==validIdObject['id']);
        if (!rows.contains(tileObject['row'])) {
          rows.add(tileObject['row']);
        }

        if (!cols.contains(tileObject['column'])) {
          cols.add(tileObject['column']);
        }
      }
    }

    if (rows.length > 1 && cols.length > 1) {
      res = true;
    }
    return res;
  }


  void setEmptyTurnScoreLog(GamePlayState gamePlayState) {
    int currentScore = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1]['cumulativePoints']; 
    int currentWords = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1]['cumulativeWords']; 
    gamePlayState.setScoringLog(
      [
        ...gamePlayState.scoringLog,
        {
            "turn": gamePlayState.scoringLog.length,
            "points": 0,
            "cumulativePoints" : currentScore,
            "words": 0,
            "wordValues": [],
            "cumulativeWords" : currentWords,
            "streak" : 0,
            "crossWord": 0,
        }
      ]
    );
  }  
  

  int getWordLengthMultiplier(int wordLength) {
    int res = 0;
    if (wordLength == 3 || wordLength == 4) {
      res = 1;
    } else {
      res = wordLength - 3;
    }
    return res;
  }

  List<Map<String,dynamic>> getUniqueValidIdsMaps(List<Map<String,dynamic>> items,) {
    List<int> indexes = [];
    List<Map<String,dynamic>> filteredItems = [];
    for (Map<String,dynamic> item in items) {
      if (!indexes.contains(item["index"])) {
        // item['isDrag'] = isDrag;
        filteredItems.add(item);
        
        indexes.add(item['index']);
      }
    }
    return filteredItems;
  }


  Map<String,dynamic> getGameSummaryData(List<Map<String,dynamic>> scoringLog) {
    int turns = scoringLog.length;
    int points = scoringLog[scoringLog.length-1]['cumulativePoints'];
    List<String> words = [];
    int mostPoints = 0;
    int longestStreak = 0;
    int mostWords = 0;
    int crossWords = 0;

    for (Map<String,dynamic> scoreObject in scoringLog) {
      if (scoreObject['points'] > 0) {

        if (scoreObject['points'] > mostPoints) {
          mostPoints = scoreObject['points'];
        }

        if (scoreObject['words'] > mostWords) {
          mostWords = scoreObject['words'];
        }

        if (scoreObject['streak'] > longestStreak) {
          longestStreak = scoreObject['streak'];
        }

        crossWords = crossWords + (scoreObject['crossWord']-1) as int;

        for (Map<String,dynamic> wordObject in scoreObject["wordValues"]) {
          if (!words.contains(wordObject['word'])) {
            words.add(wordObject['word']);
          }
        }
      }
    }

    Map<String, dynamic> summary = {
      "turns": turns,
      "points": points,
      "uniqueWords": words,
      "mostPoints": mostPoints,
      "longestStreak": longestStreak,
      "mostWords": mostWords,
      "crosswords": crossWords,
    };   
    return summary; 
  }


  List<Map<String,dynamic>> getPointsSummary(List<Map<String,dynamic>> scoringLog) {

    int count = 1;

    late List<Map<String,dynamic>> res  = [];
    for (int i=0; i<scoringLog.length; i++) {
      
      Map<String,dynamic> item = scoringLog[i];
      if (item['points'] > 0) {

        for (Map<String,dynamic> word in item['wordValues']) {
          int totalScore = word['points'] * item['crossWord'] * item['streak'] * item['words'];
          word['totalScore'] = totalScore;
          word['index'] = count;
          count++;
        }

        item['index'] = i;


        res.add(item);
      }
    }
    return res;
  }

  void clearTilesFromBoard(GamePlayState gamePlayState) {
    for (Map<dynamic,dynamic> item in gamePlayState.tileState) {
      item.update("letter", (value) => "");
      item.update("alive", (value) => true);
    }
  } 

  List<Tile> parseTiles(String jsonString) {
    final parsed = jsonDecode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Tile>((json) => Tile.fromJson(json)).toList();
  }          

  Widget wordValuesTable(List<dynamic> alphabet, String language, SettingsState settings, ColorPalette palette, double tileSize) {
    List<TableRow> rows = [
      TableRow(
        children: [
          Align(
            alignment: Alignment.center,
            child: DefaultTextStyle(
              child: Text(
                Helpers().translateText(language, "Alphabet", settings),
              ),
              style: GoogleFonts.roboto(
                color: palette.textColor2,
                fontSize: tileSize*0.32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: DefaultTextStyle(
              child: Text(
                Helpers().translateText(language, "Values", settings),
              ),
              style: GoogleFonts.roboto(
                color: palette.textColor2,
                fontSize: tileSize*0.32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: DefaultTextStyle(
              child: Text(
                Helpers().translateText(language, "Count", settings),
              ),
              style: GoogleFonts.roboto(
                color: palette.textColor2,
                fontSize: tileSize*0.32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),        
        ]
      ),
    ];
    for (dynamic item in alphabet) {
      final TableRow rowWidget = TableRow(
        children: [
          Align(
            alignment: Alignment.center,
            child: DefaultTextStyle(
              child: Text(
                item['letter'],
              ),
              style: Helpers().customTextStyle(palette.textColor2, tileSize*0.3),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: DefaultTextStyle(
              child: Text(
                item['points'].toString(),
              ),
              style: Helpers().customTextStyle(palette.textColor2, tileSize*0.3),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: DefaultTextStyle(
              child: Text(
                item['count'].toString(),
              ),
              style: Helpers().customTextStyle(palette.textColor2, tileSize*0.3),
            ),
          ),        
        ]
      );
      rows.add(rowWidget);
    }
    return Table(
      border: TableBorder.all(
        color: palette.textColor2,
        width: tileSize*0.01,
        borderRadius: BorderRadius.all(Radius.circular(tileSize*0.2))
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows,
    );



  }
  List<Map<String,dynamic>> getInitialBoardState() {
    List<Map<String,dynamic>> boardState = [];
    Random _rand = Random();  
    int count = 0;
    for (int j=1;j<7;j++) {
      for (int k=1;k<7;k++) {
        int shade = _rand.nextInt(4);
        int angle = _rand.nextInt(4);
        Map<String,dynamic> data ={
          "index": count, 
          "tileId": "${j}_${k}",
          "row": j,
          "column": k,
          "letter": "",
          "active": false,
          "alive": true, 
          "shade": shade, 
          "angle": angle
        };
        boardState.add(data);
        count = count+1;
      }    
    }
    return boardState;
  }



  Widget instructionsHeading(Color color, String body, String language, double fontSize,SettingsState settingsState) {
    String res = "";
    res = Helpers().translateText(language, body,settingsState);
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DefaultTextStyle(
          child: Text(
            res,
          ),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: color
          ),
        ),
      ),
    );
  }

  Widget instructionsText(
    Color color, 
    String body, 
    String language, 
    bool dynamicValue, 
    double fontSize, 
    Map<dynamic,dynamic> translateDemoSequence,
    SettingsState settingsState
    ) {
    String res = "";
    if (dynamicValue) {
      res = Helpers().translateDemoSequence(language, body, translateDemoSequence,settingsState);
    } else {
      res = Helpers().translateText(language, body,settingsState);
    }
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: DefaultTextStyle(
        child: Text(
          res,
        ),
        style: TextStyle(fontSize: fontSize, color: color),
      ),
    );
  }


  Color getDemoTileBorderColor(String tileLetter, Color color) {
    late Color res = Colors.transparent;
    if (tileLetter == "") {
      res = color;
    }
    return res;
  }

  Color getDemoTileTextColor(String tileLetter, ColorPalette palette, bool isActive) {
    late Color res = palette.fullTileTextColor;
    if (isActive) {
      res = palette.emptyTileBorderColor;
    }
    return res;
  }

  BoxDecoration getBoxDecoration(double tileSize, ColorPalette palette, String tileLetter, bool active) {
    BoxDecoration res = Decorations().getTileDecoration(tileSize, palette, 1, 1);
    if (tileLetter == "" ) {
      res = Decorations().getEmptyTileDecoration(tileSize, palette,0,1);
    } else {
      if (active) {
        res = BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(tileSize*0.2)),
          border: Border.all(
            color: palette.emptyTileBorderColor,
            width: tileSize*0.04
          )
        );
      }
    }
    return res;
  }








}
