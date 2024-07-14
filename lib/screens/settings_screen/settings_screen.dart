import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/screens/settings_screen/choose_username_dialog.dart';
import 'package:scribby_flutter_v2/screens/settings_screen/language_selection_widget.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/no_internet_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  final bool darkMode;
  const SettingsScreen({super.key, required this.darkMode});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {

  late SettingsState settingsState;


  @override
  void initState() {
    super.initState();
    settingsState = Provider.of<SettingsState>(context,listen: false);
    getConnectivityStatus(settingsState);
  }

  Future<void> getConnectivityStatus(SettingsState settingsState) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    final bool isConnected = connectivityResult[0] != ConnectivityResult.none;
    settingsState.setIsPlayingOffline(!isConnected);
  }

  Future<Map<String,dynamic>> getData() async {

    late Map<String,dynamic> res = {};

    try {
      final userData = await FirestoreMethods().getUserData(AuthService().currentUser!.uid) as Map<String, dynamic>;

      res = userData;
    } catch (e) {
    }
    return res;
  }


  @override
  Widget build(BuildContext context) {

    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    final AudioController audioController =Provider.of<AudioController>(context, listen: false);
    final SettingsController settings =Provider.of<SettingsController>(context, listen: false);
    final List<Map<String,dynamic>> decorationDetails = gamePlayState.decorationData;   

    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        } else if (snapshot.hasError ) {
          return const Center(child: Text("Error"),);
        } else if (snapshot.data!.isEmpty) {
          return const Center(child: Text("Error"),);
        } else {

          return Consumer<SettingsState>(
            builder: (context,settingsState,child) {          
              final Map<String,dynamic> userData = settingsState.userData;
              final double ts = gamePlayState.tileSize;

              final List<dynamic> selectedLanguages = userData['parameters']['languages'];
              late String username = userData['username'];

              final bool darkMode = userData['parameters']['darkMode'];
              final bool soundOn = userData['parameters']['soundOn'];

              getParameterCardGradient(darkMode,palette);         
              return SafeArea(
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: getScreenBackgroundGradient(darkMode,palette),                       
                        )
                      )
                    ),
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
                                      iconSize: gamePlayState.tileSize*0.44,
                                      color: palette.textColor1,
                                      onPressed: () {
                                        audioController.playSfx(SfxType.optionSelected);
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => const MenuScreen(),
                                          ), (Route<dynamic> route) => false
                                        );                                        
                                      },
                                    ),                                         
                                    Text(Helpers().translateText(gamePlayState.currentLanguage, 'Settings',settingsState),
                                      style: TextStyle(
                                        color: darkMode ? palette.dark_textColor2 : palette.light_textColor2,
                                        fontSize: gamePlayState.tileSize*0.4
                                      ),
                                                                      
                                    ),
                                  ],
                                ),
                              ), 
                          ),
                        ),              
                        // backgroundColor: palette.screenBackgroundColor,
                        backgroundColor: Colors.transparent,
                        body: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 600,
                              minWidth: gamePlayState.tileSize*6
                            ),
                            child: Container(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(ts*0.3),
                                  child: Column(
                                    children: [
                                                        
                                      /// USERNAME
                                      Text(
                                        Helpers().translateText(gamePlayState.currentLanguage, "Username", settingsState),
                                        style: TextStyle(
                                          fontSize: ts*0.4,
                                          color: palette.textColor1
                                        ),
                                      ),
                                        /// USERNAME CARD
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        width: double.infinity,
                                        height: ts,
                                        decoration: getCustomBoxDecoration(ts, palette,3,darkMode),
                                        child: Padding(
                                          padding: EdgeInsets.all(ts*0.2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                username,
                                                style: TextStyle(
                                                  fontSize: ts*0.3,
                                                  color: darkMode ? palette.dark_settingsScreenOptionTextColor : palette.light_settingsScreenOptionTextColor,
                                                ),
                                              ),
                                              IconButton(
                                                icon:Icon(
                                                  Icons.edit, 
                                                  color: darkMode ? palette.dark_settingsScreenOptionTextColor : palette.light_settingsScreenOptionTextColor,
                                                  size: gamePlayState.tileSize*0.3,
                                                ),
                                                onPressed: () {
                                                  try {
                                                    if (settingsState.isPlayingOffline) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            Helpers().translateText(gamePlayState.currentLanguage, "Can't change username in offline mode", settingsState)
                                                            ,
                                                            style: TextStyle(
                                                              color: palette.fullTileTextColor,
                                                              fontSize: gamePlayState.tileSize*0.3
                                                            ),
                                                          ),
                                                          duration: const Duration(milliseconds: 3000),
                                                        )
                                                      ); 
                                                    } else {
                                                      showDialog(
                                                        context: context, 
                                                        builder: (child) {
                                                          return ChooseUsernameDialog();
                                                        }
                                                      );
                                                    }  
                                                  } catch (e) {
                                                    Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) => const NoInternetScreen()
                                                      )
                                                    );
                                                  }                                              
                                                }
                                              )                                    
                                            ],
                                          ),
                                        ),
                                      ),
                                          
                                      SizedBox(height: ts*0.5,),
                                             
                                      /// PARAMETERS
                                      Text(
                                        Helpers().translateText(gamePlayState.currentLanguage, "Parameters", settingsState),
                                        style: TextStyle(
                                          fontSize: ts*0.4,
                                          color: darkMode ? palette.dark_textColor2 : palette.light_textColor2,
                                        ),
                                      ),                                 
                                        /// COLOR THEME
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        width: double.infinity,
                                        height: ts,
                                        decoration: getCustomBoxDecoration(ts, palette,3,darkMode),
                                        child: Padding(
                                          padding: EdgeInsets.all(ts*0.2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Helpers().translateText(gamePlayState.currentLanguage, "Color Theme", settingsState),
                                                style: TextStyle(
                                                  color: darkMode ? palette.dark_settingsScreenOptionTextColor : palette.light_settingsScreenOptionTextColor,
                                                  fontSize: ts*0.3
                                                ),
                                              ),
                                              IconButton(
                                                icon:Icon(
                                                  darkMode ? Icons.light_mode :Icons.dark_mode, 
                                                  color: darkMode ? palette.dark_settingsScreenOptionTextColor : palette.light_settingsScreenOptionTextColor,
                                                  size: gamePlayState.tileSize*0.3,
                                                ),
                                                onPressed: () async {
                                                  try {
                                                    if (!settingsState.isPlayingOffline) {
                                                      await FirestoreMethods().updateParameters(AuthService().currentUser!.uid, 'darkMode', !darkMode);
                                                    }
                                                    late Map<String,dynamic> newParams = {...userData['parameters'],'darkMode': !darkMode};
                                                    late Map<String,dynamic> newUserData = {...userData,'parameters':newParams};
                                                    palette.getThemeColors(!darkMode);
                                                    settings.toggleDarkTheme();
                                                    settingsState.updateUserData(newUserData);
                                                  } catch (e) {
                                                    Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) => const NoInternetScreen()
                                                      )
                                                    );
                                                  }    
                                                }
                                              )                                    
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: ts*0.2,),
                                        /// SOUND ON 
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        width: double.infinity,
                                        height: ts,
                                        decoration: getCustomBoxDecoration(ts, palette,3,darkMode),
                                        child: Padding(
                                          padding: EdgeInsets.all(ts*0.2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                soundOn ? Helpers().translateText(gamePlayState.currentLanguage, "Sound On",settingsState) 
                                                : Helpers().translateText(gamePlayState.currentLanguage, "Sound Off",settingsState),
                                                style: TextStyle(
                                                  color: darkMode ? palette.dark_settingsScreenOptionTextColor : palette.light_settingsScreenOptionTextColor,
                                                  fontSize: ts*0.3
                                                ),
                                              ),
                                              IconButton(
                                                icon:Icon(
                                                  soundOn ? Icons.volume_up :Icons.volume_off, 
                                                  color: darkMode ? palette.dark_settingsScreenOptionTextColor : palette.light_settingsScreenOptionTextColor,
                                                  size: gamePlayState.tileSize*0.3,
                                                ),
                                                onPressed: () async {
                                                  try {
                                                    if (!settingsState.isPlayingOffline) {
                                                      await FirestoreMethods().updateParameters(AuthService().currentUser!.uid, 'soundOn', !soundOn);
                                                    }
                                                    late Map<String,dynamic> newParams = {...userData['parameters'],'soundOn': !soundOn};
                                                    late Map<String,dynamic> newUserData = {...userData,'parameters':newParams};                                                
                                                    settings.toggleSoundsOn();
                                                    settingsState.updateUserData(newUserData);
                                                  } catch (e) {
                                                    Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) => const NoInternetScreen()
                                                      )
                                                    );
                                                  }    
                                                }
                                              )                                    
                                            ],
                                          ),
                                        ),
                                      ),                                       
                                      
                            
                                      SizedBox(height: ts*0.5,),
                            
                                      /// LANGUAGE
                                      Text(
                                        Helpers().translateText(gamePlayState.currentLanguage, "Language", settingsState),
                                        style: TextStyle(
                                          fontSize: ts*0.4,
                                          color: darkMode ? palette.dark_textColor2 : palette.light_textColor2,
                                        ),
                                      ),                                          
                                        /// LANGUAGE DROPDOWN
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        width: double.infinity,
                                        height: ts,
                                        decoration: getCustomBoxDecoration(ts, palette,3,darkMode),
                                        child: Padding(
                                          padding: EdgeInsets.all(ts*0.2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Helpers().translateText(gamePlayState.currentLanguage, "Current", settingsState),
                                                style: TextStyle(
                                                  fontSize: ts*0.3,
                                                  color: darkMode ? palette.dark_settingsScreenOptionTextColor : palette.light_settingsScreenOptionTextColor,
                                                ),
                                              ),
                            
                            
                                              DropdownButton(
                                                value: gamePlayState.currentLanguage,
                                                // dropdownColor: palette.optionButtonBgColor,
                                                dropdownColor: palette.tileGradientShade3Color1,
                                                items: selectedLanguages.map<DropdownMenuItem<dynamic>>(
                                                  (dynamic val) {
                                                    return DropdownMenuItem<dynamic>(
                                                      value: val,
                                                      child: Text(
                                                        Helpers().translateText(gamePlayState.currentLanguage,val,settingsState),
                                                        // Helpers().capitalize(val),
                                                        style: TextStyle(
                                                          fontSize: ts*0.3,
                                                          color: darkMode ? palette.dark_settingsScreenOptionTextColor : palette.light_settingsScreenOptionTextColor,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).toList(),
                                                onChanged: (val) {
                                                  try {
                                                    if (settingsState.isPlayingOffline) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            Helpers().translateText(gamePlayState.currentLanguage, "Can't change language in offline mode", settingsState),
                                                            style: TextStyle(
                                                              color: palette.fullTileTextColor,
                                                              fontSize: gamePlayState.tileSize*0.3
                                                            ),
                                                          ),
                                                          duration: const Duration(milliseconds: 3000),
                                                        )
                                                      ); 
                                                    } else {
                                                      changeCurrentLanguage(val,gamePlayState,settingsState,settings);
                                                    }
                                                  } catch (e) {
                                                    Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) => const NoInternetScreen()
                                                      )
                                                    );
                                                  }  
                                                },
                                              )                                
                                            ],
                                          ),
                                        ),
                                      ),                                      
                                          ///  ADD LANGUAGE BUTTON   
                                      Row(
                                        children: [
                                          Expanded(child: SizedBox()),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: ts*0.2),
                                            child: GestureDetector(
                                              onTap: () {
                                                try {
                                                  if (settingsState.isPlayingOffline) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          Helpers().translateText(gamePlayState.currentLanguage, "Can't change language in offline mode", settingsState),
                                                          style: TextStyle(
                                                            color: palette.fullTileTextColor,
                                                            fontSize: gamePlayState.tileSize*0.3
                                                          ),
                                                        ),
                                                        duration: const Duration(milliseconds: 3000),
                                                      )
                                                    ); 
                                                  } else {
                                                    showPickLanguageDialog(
                                                      context,
                                                      settingsState.languageDataList,
                                                      ts,
                                                      palette,
                                                      gamePlayState,
                                                      settingsState
                                                    );
                                                  }
                                                } catch (e) {
                                                  Navigator.of(context).pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) => const NoInternetScreen()
                                                    )
                                                  );
                                                }
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 300),
                                                height: ts*0.8,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: ts*0.2),
                                                  child: Center(
                                                    child: Text(
                                                      Helpers().translateText(gamePlayState.currentLanguage, "Add / Remove Language", settingsState),
                                                      style: TextStyle(
                                                        fontSize: ts*0.3,
                                                        color: darkMode ? palette.dark_settingsScreenOptionTextColor : palette.light_settingsScreenOptionTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                decoration: getCustomBoxDecoration(ts, palette, 4, darkMode),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                            
                                      SizedBox(height: ts*0.5,),                                    
                                      /// LINK TO PRIVACY POLICY
                                      Text(
                                        Helpers().translateText(gamePlayState.currentLanguage, "Link to Privacy Policy", settingsState),
                                        style: TextStyle(
                                          fontSize: ts*0.4,
                                          color: darkMode ? palette.dark_textColor2 : palette.light_textColor2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),                                        
                                        /// LINK TO PRIVACY POLICY 
                                      GestureDetector(
                                        onTap: () {
                                          _launchURL("https://nodamngoodstudios.com/games/scribby/privacy-policy");
                                        },                                      
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          width: double.infinity,
                                          height: ts,
                                          decoration: getCustomBoxDecoration(ts, palette,3,darkMode),
                                          child: Padding(
                                            padding: EdgeInsets.all(ts*0.2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  Helpers().translateText(gamePlayState.currentLanguage, "Privacy Policy", settingsState),
                                                  style: TextStyle(
                                                    color: darkMode ? palette.dark_settingsScreenOptionTextColor : palette.light_settingsScreenOptionTextColor,
                                                    fontSize: ts*0.3
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.link, 
                                                  color: darkMode ? palette.dark_settingsScreenOptionTextColor : palette.light_settingsScreenOptionTextColor,
                                                  size: gamePlayState.tileSize*0.3,
                                                ),                                 
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),                                       
                            
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      )
                    )       
                  ],
                )
              );
            }
          );
        }        
      }
    );
  }
}



BoxDecoration getCustomBoxDecoration(double tileSize, ColorPalette palette, int angleIndex, bool darkMode) {

  late Map<int,dynamic> angles = {
    0: {"begin": Alignment.bottomLeft, "end": Alignment.topRight,},
    1: {"begin": Alignment.bottomRight, "end": Alignment.topLeft,},
    2: {"begin": Alignment.topLeft, "end": Alignment.bottomRight,},
    3: {"begin": Alignment.topRight, "end": Alignment.bottomLeft,},
    4: {"begin": Alignment.topCenter, "end": Alignment.bottomCenter,},
  };
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(tileSize*0.20)),
    gradient: LinearGradient(
      begin: angles[angleIndex]['begin'],
      end: angles[angleIndex]['end'],
      colors: <Color>[        
        darkMode ? palette.dark_settingsScreenOptionColor1 : palette.light_settingsScreenOptionColor1,
        darkMode ? palette.dark_settingsScreenOptionColor2 : palette.light_settingsScreenOptionColor2,
        // color1Animation.value,
        // color2Animation.value
      ],
    ),
    border: Border(
      bottom: BorderSide(
        color: palette.fullTileBorderColor,
        width: tileSize*0.03,
      ),
      left: BorderSide(
        color: palette.fullTileBorderColor,
        width: tileSize*0.03,
      )
    ),
    boxShadow:  <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(15, 15, 15, tileSize*0.003),
        offset: Offset(0.0, 2.0),
        blurRadius: tileSize*0.04,
        spreadRadius: 1,
      )
    ]
  );
}

Future<void> _launchURL(url_string) async {
   final Uri url = Uri.parse(url_string);
  //  print("okay go to $url");
   if (!await launchUrl(url)) {
        throw Exception('Could not launch privacy policy');
    }
}


List<Color> getScreenBackgroundGradient(bool darkMode, ColorPalette palette) {
  late List<Color> res = [Colors.transparent,Colors.transparent];

    if (darkMode) {
      res = [
        palette.dark_screenBackgroundColor1,
        palette.dark_screenBackgroundColor2
      ];
    } else {
      res = [
        palette.light_screenBackgroundColor2,
        palette.light_screenBackgroundColor1
      ];
    }
  return res;
}
Future<void> changeCurrentLanguage(dynamic newLanguage, GamePlayState gamePlayState, SettingsState settingsState, SettingsController settings) async {
  await FirestoreMethods().updateParameters(AuthService().currentUser!.uid, "currentLanguage", newLanguage);
  final Map<String, dynamic>? userData = await FirestoreMethods().getUserData(AuthService().currentUser!.uid);
      // saving a copy of the user data in firebase to a Provider class
  settingsState.updateUserData(userData!);
  // Saving a copy of the user data to shared preferences
  settings.setUserData(userData);

  gamePlayState.setCurrentLanguage(newLanguage);

  await FirestoreMethods().saveAlphabetToLocalStorage(AuthService().currentUser!.uid, settings, settingsState);

  List<String> listOfWords = await StorageMethods().downloadWordList(newLanguage);
  await FirestoreMethods().saveWordListToLocalStorage(listOfWords, 'dictionary');

  gamePlayState.setDictionary(listOfWords);  
}

void showPickLanguageDialog(
  BuildContext context, 
  List<Map<String,dynamic>> languageDataList, 
  double ts, 
  ColorPalette palette,
  GamePlayState gamePlayState,
  SettingsState settingsState,
  ) {
  showDialog(
    context: context, 
    builder: (child) {
      return Dialog(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(ts*0.2))
        ),
        child: Container(
          width: ts*6,
          decoration: BoxDecoration(
            color: palette.modalBgColor,
            borderRadius: BorderRadius.all(Radius.circular(ts*0.2))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: ts*0.8,
                child: Center(
                  child: Text(
                    Helpers().translateText(gamePlayState.currentLanguage, "Add / Remove Language", settingsState),
                    style: TextStyle(
                      fontSize: ts*0.3,
                      color: palette.modalTextColor
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ts*0.15),
                child: Divider(
                  thickness: ts*0.01,
                  color: palette.modalTextColor,
                ),
              ),
              LanguageSelectionWidget(),
            ],
          ),
        ),
      );
    }
  );                                    
}

List<Color> getParameterCardGradient(bool darkMode, ColorPalette palette) {

  List<Color> darkOptions = [
    palette.dark_settingsScreenOptionColor1,
    palette.dark_settingsScreenOptionColor2,
    palette.dark_settingsScreenOptionColor3,
    palette.dark_settingsScreenOptionColor4,
  ];
  List<Color> lightOptions = [
    palette.dark_settingsScreenOptionColor1,
    palette.dark_settingsScreenOptionColor2,
    palette.dark_settingsScreenOptionColor3,
    palette.dark_settingsScreenOptionColor4,
  ];  
  Random _rand = Random();

  List<Color> res = [];
  if (darkMode) {
    res = darkOptions;
  } else {
    res = lightOptions;
  }
  for (int i=0; i<2; i++) {
    int randomIndex1 = _rand.nextInt(res.length);
    res.removeAt(randomIndex1);
  }
  return res;
}