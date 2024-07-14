import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/test.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:vector_math/vector_math_64.dart';

class LanguageSelectionWidget extends StatefulWidget {
  const LanguageSelectionWidget({super.key});

  @override
  State<LanguageSelectionWidget> createState() => _LanguageSelectionWidgetState();
}

class _LanguageSelectionWidgetState extends State<LanguageSelectionWidget> {
  @override
  Widget build(BuildContext context) {

    late GamePlayState gamePlayState = Provider.of<GamePlayState>(context,listen: false);
    late ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);

    return Consumer<SettingsState>(
      builder: (context,settingsState,child) {

        late List<Map<String,dynamic>> currentLanguageDataList = createLanguageDataList(settingsState);

        return SizedBox(
          width: gamePlayState.tileSize*5,
          height: gamePlayState.tileSize*5,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              for (int i=0; i<currentLanguageDataList.length; i++)
        
                Builder(
                  builder: (child) {
                    final Map<String,dynamic> language = currentLanguageDataList[i];
                    late  double spreadFactor = (gamePlayState.tileSize*5)*0.33;
                    late double angle = ((360/currentLanguageDataList.length)*i);
                    late double rad = radians(angle); 
        
                    
        
                    return Transform(
                      transform: Matrix4.identity()..translate(
                        (spreadFactor) * cos(rad), 
                        (spreadFactor) * sin(rad)        
                      ),
                              
                      child: GestureDetector(
                        onTap: () async {
                          updateList(settingsState,currentLanguageDataList, language, context,gamePlayState);
                        },
                        child: Container(
                          width: gamePlayState.tileSize,
                          height: gamePlayState.tileSize,
                          child: Stack(
                            children: [
        
                              Positioned(
                                top: 0,
                                left: 0,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: getSelectedLanguageCircleOpacity(language['flag'],settingsState),                                         
                                  child: Container(
                                    width: gamePlayState.tileSize,
                                    height: gamePlayState.tileSize,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: palette.textColor1, width: 2.0),
                                      borderRadius: BorderRadius.all(Radius.circular(100.0))
                                    ),
                                  ),
                                )
                              ),
        
                              Positioned(
                                top: gamePlayState.tileSize*0.1,
                                left: gamePlayState.tileSize*0.1,
                                child: Container(
                                  width: gamePlayState.tileSize*0.8,
                                  height: gamePlayState.tileSize*0.8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                                  ),
                                  child: FlagWidget(radius: gamePlayState.tileSize*0.8, flag: language['flag'],), 
                                )
                              )                                        
                            ],
                          ),
                        ),                                  
                      )
                    );
                  }
                ),
            ],
          ),
        );
      }
    );
  }
}

double getSelectedLanguageCircleOpacity(String flag, SettingsState settingsState) {
  double res = 0.0;
  if (settingsState.userData['parameters']['languages'].contains(flag)) {
    res = 1.0;
  }; 
  return res;
}

void updateList(
  SettingsState settingsState, 
  List<Map<String,dynamic>> currentLanguageDataList, 
  Map<String,dynamic> language, 
  BuildContext context,
  GamePlayState gamePlayState) async {

  // List<Map<String,dynamic>> updatedLanguageDataList = getUpdatedListAfterSelection(currentLanguageDataList,language);
  Map<String,dynamic> updatedLanguageObject = {};
  late String result = "";
  if (language['primary']) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Can't remove the current language!"),
        duration: Duration(milliseconds: 1000),
      )
    );
  } else {
    if (language['selected']) {
      updatedLanguageObject = {...language, 'selected':false};
      result = Helpers().translateText(gamePlayState.currentLanguage, "new_language was removed from languages",settingsState);
    } else {
      updatedLanguageObject = {...language, 'selected':true};
      result = Helpers().translateText(gamePlayState.currentLanguage, "new_language was added to languages",settingsState);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        translateDynamicLanguage(gamePlayState.currentLanguage, result, updatedLanguageObject['flag'],settingsState)
      ),
      duration: const Duration(milliseconds: 1000),
    ));     
  }

  List<Map<String,dynamic>> updatedLanguageList = [];
  for (Map<String,dynamic> languageObject in currentLanguageDataList) {
    if (languageObject['flag'] == updatedLanguageObject['flag']) {
      updatedLanguageList.add(updatedLanguageObject);
    } else {
      updatedLanguageList.add(languageObject);
    }
  }
    
  List<dynamic> selectedLanguages = [];
  for (Map<String,dynamic> languageObject in updatedLanguageList) {
    if (languageObject['selected']) {
      selectedLanguages.add(languageObject['flag']);
    }
  }
  Map<String,dynamic> oldParameters = settingsState.userData['parameters'];
  Map<String,dynamic> newParameters = {...oldParameters, 'languages':selectedLanguages};
  Map<String,dynamic> userData = {...settingsState.userData, 'parameters':newParameters};
  settingsState.updateUserData(userData);

  await FirestoreMethods().updateParameters(AuthService().currentUser!.uid, 'languages', selectedLanguages);
}


List<Map<String,dynamic>> createLanguageDataList(SettingsState settingsState) {
  late List<Map<String,dynamic>> res = [];
  for (Map<String,dynamic> languageObject in settingsState.languageDataList) {
    if (settingsState.userData['parameters']['languages'].contains(languageObject['flag'])) {
      if (languageObject['flag'] == settingsState.userData['parameters']['currentLanguage']) {
        Map<String,dynamic> updatedLanguageObject = {...languageObject, 'primary':true, 'selected':true};
        res.add(updatedLanguageObject);
      } else {
        Map<String,dynamic> updatedLanguageObject = {...languageObject, 'selected':true};
        res.add(updatedLanguageObject);
      }
    } else {
      res.add(languageObject);
    }
  }
  return res;
}


  String translateDynamicLanguage(String language, String originalString, String flag, SettingsState settingsState) {
    String tranlatedFlag = Helpers().translateText(language, flag, settingsState);
    String res = originalString.replaceAll('new_language', tranlatedFlag);
    return res;
  }      