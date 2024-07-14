import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/welcome_user.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class ChooseUsername extends StatefulWidget {
  const ChooseUsername({super.key});

  @override
  State<ChooseUsername> createState() => _ChooseUsernameState();
}

class _ChooseUsernameState extends State<ChooseUsername> {

  late bool isLoading = false;
  late bool languageSelected = false;
  late TextEditingController _userNameController;

  late List<String> forbiddenNames = [
    "player", "user", "username",
  ];

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  String getPrimaryLanguage(List<Map<String,dynamic>> dataList) {
    String res = "";
    if (dataList.where((element) => element['primary'] == true).toList().isNotEmpty) {
      res = dataList.firstWhere((element) => element['primary'] == true)['body'];
    } 
    return res;
  }

  List<Map<String,dynamic>> getAllSelectedLanguages(List<Map<String,dynamic>> dataList) {
    List<Map<String,dynamic>>  res = [];
    List<Map<String,dynamic>> selected = dataList.where((element) => element['selected']==true).toList();
    if (selected.isNotEmpty) {
      res = selected;
    }
    return res;
  }

  List<String> allLanguagesStringList(List<Map<String,dynamic>> dataList) {
    List<String>  res = [];
    List<Map<String,dynamic>> selected = dataList.where((element) => element['selected']==true).toList();
    if (selected.isNotEmpty) {
      for (Map<String,dynamic> item in selected) {
        res.add(item['body']);
      }
    } else {
      res = [];
    }
    return res;    
  }


  void changePrimaryLanguage(SettingsState settingsState, String newChoice) {
    List<Map<String,dynamic>> newList = [];
    for (Map<String,dynamic> item in settingsState.languageDataList) {
      if (item['body'] == newChoice) {
        newList.add({
          'primary': true,
          'selected': true, 
          'body': item['body'] , 
          'flag':item['flag'] , 
          'url': item['url']
        });
      } else {
        newList.add({
          'primary': false,
          'selected': item['selected'], 
          'body': item['body'] , 
          'flag':item['flag'] , 
          'url': item['url']          
        });
      }
    }
    settingsState.setLanguageDataList(newList);
  }


  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);

    return isLoading ? const Center(child: CircularProgressIndicator(),) :    
    Consumer<SettingsState>(
      builder: (context, settingsState, child) {
        final double screenWidth = settingsState.screenSizeData['width'];
        final double screenHeight = settingsState.screenSizeData['height'];
        final List<Map<String,dynamic>> decorationDetails = gamePlayState.decorationData;
        final String currentLanguage = getPrimaryLanguage(settingsState.languageDataList);
        return SafeArea(
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
                    // color: palette.screenBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                      
                          const Expanded(flex: 2, child: SizedBox()),
                      
                          Text(
                            // "Welcome!",
                            Helpers().translateWelcomeText(
                              currentLanguage,
                              "Welcome!",
                              settingsState
                            ),                  
                            style: TextStyle(
                              fontSize: gamePlayState.tileSize*0.45,
                              color: palette.textColor2,
                            ),
                          ),
                          const SizedBox(height: 20,),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              Helpers().translateWelcomeText(
                                currentLanguage,
                                "Pick an original username",
                                settingsState
                              ),                  
                                  
                              style: TextStyle(
                                fontSize: gamePlayState.tileSize*0.3,
                                color: palette.textColor2
                              ),
                            ),
                          ),

                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Helpers().translateWelcomeText(currentLanguage, "No bad words",settingsState),
                                  style: TextStyle(
                                    color: palette.textColor2,
                                    fontSize: gamePlayState.tileSize*0.27
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  Helpers().translateWelcomeText(currentLanguage, "No unoriginal names ('user', 'player', etc.)",settingsState),
                                  style: TextStyle(
                                    color: palette.textColor2,
                                    fontSize: gamePlayState.tileSize*0.27
                                  ),
                                  textAlign: TextAlign.start,                                    
                                ),
                                Text(
                                  Helpers().translateWelcomeText(currentLanguage, "Minimum 3 characters",settingsState),
                                  style: TextStyle(
                                    color: palette.textColor2,
                                    fontSize: gamePlayState.tileSize*0.27
                                  ),
                                  textAlign: TextAlign.start,                                    
                                ),
                                Text(
                                  Helpers().translateWelcomeText(currentLanguage, "Maximum 40 characters",settingsState),
                                  style: TextStyle(
                                    color: palette.textColor2,
                                    fontSize: gamePlayState.tileSize*0.27
                                  ),
                                  textAlign: TextAlign.start,                                    
                                ),
                              ],
                            ),
                          ),                          
                          Consumer<GamePlayState>(
                            builder: (context, gamePlayState, child) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(16.0,8.0,16.0,8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: gamePlayState.tileSize,
                                  child: Align(
                                    alignment: Alignment.center,
                                                                
                                    child : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width*0.8,
                                            child: TextField(
                                              controller: _userNameController,
                                              decoration: InputDecoration(
                                                fillColor: palette.textColor2,
                                                focusColor: palette.textColor2,
                                                hoverColor: palette.textColor2,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(color: palette.textColor2, width: 1.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: palette.textColor2, width: 2.0),
                                                  borderRadius: BorderRadius.circular(gamePlayState.tileSize*0.2),
                                                ),
                                                labelStyle: TextStyle(color: palette.textColor2, fontSize: gamePlayState.tileSize*0.28),
                                                labelText: Helpers().translateWelcomeText(
                                                  getPrimaryLanguage(settingsState.languageDataList), "Username",settingsState),
                                              ),
                                              style: TextStyle(
                                                fontSize: gamePlayState.tileSize*0.3,
                                                color: palette.textColor2
                                              ),
                                            ),
                                          ),
                                        ),
                                                      
                                        // Expanded(flex: 1, child: SizedBox()),                                                 
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                          SizedBox(height: gamePlayState.tileSize*0.5,),
                          GestureDetector(
                            onTap: () {
                                      late List<String> forbiddenNames = [
                                        "player", "user", "username",
                                      ];
                                      if (forbiddenNames.contains(_userNameController.text.toLowerCase())) {
                                        Helpers().showUserNameSnackBar(
                                          context,
                                          palette,
                                          gamePlayState.tileSize,
                                          Helpers().translateText(currentLanguage, "Pick something more original",settingsState)
                                        );
                                      } else if (Helpers().checkForBadWords(_userNameController.text.toLowerCase())) {
                                        Helpers().showUserNameSnackBar(
                                          context,
                                          palette,
                                          gamePlayState.tileSize,
                                          Helpers().translateText(currentLanguage, "Hey! No bad words!",settingsState)
                                        );                                        
                                      } else if (_userNameController.text.toLowerCase().length  < 3) {
                                        Helpers().showUserNameSnackBar(
                                          context,
                                          palette,
                                          gamePlayState.tileSize,
                                          Helpers().translateText(currentLanguage, "Username must be at least 3 characters",settingsState)
                                        );                                                         
                                      } else if (_userNameController.text.toLowerCase().length  > 40) {
                                        Helpers().showUserNameSnackBar(
                                          context,
                                          palette,
                                          gamePlayState.tileSize,
                                          Helpers().translateText(currentLanguage, "Username must be at most 40 characters",settingsState)
                                        );
                                      } else {
                                AuthService().updateUsername(AuthService().currentUser!.uid, _userNameController.text.toLowerCase());
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const WelcomeUser()
                                  )
                                );                    
                              }
                            },
                            child: Container(
                              width: gamePlayState.tileSize*4,
                              height: gamePlayState.tileSize*0.8,
                              decoration: Decorations().getTileDecoration(gamePlayState.tileSize, palette, 3, 2),
                              child: Center(
                                child: Text(
                                  Helpers().translateWelcomeText(
                                    getPrimaryLanguage(settingsState.languageDataList), 
                                    "Save",
                                    settingsState
                                  ),                     
                                  style: TextStyle(
                                    fontSize: gamePlayState.tileSize*0.3,
                                    color: palette.fullTileTextColor
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Expanded(flex: 3, child: SizedBox()),             
                        ],
                      ),
                    ),            
                  
                  ),
                ),
              ],
            )
          ),
        );
      },
    );

  }
}


Widget languageButton(String body) {
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 60,
            child: Center(
              child: Text(
                body,
                style: const TextStyle(
                  fontSize: 22
                ),
              ),
            ),
          ),
        )
      )
    ],
  );
}


