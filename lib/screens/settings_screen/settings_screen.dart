import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/welcome_user.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  final bool darkMode;
  const SettingsScreen({super.key, required this.darkMode});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  late bool userNameEditView = false;
  late bool isLoading;
  late ColorPalette _palette;
  late TextEditingController _userNameController;
  late AnimationController colorChangeController; 

  late Animation<Color?> screenBgColorChangeAnimation1;
  late Animation<Color?> screenBgColorChangeAnimation2;

  late Animation<Color?> cardBgColorChangeAnimation1;
  late Animation<Color?> cardBgColorChangeAnimation2;
  // late AnimationController cardBgColorChangeController;   

  late Animation<Color?> cardTextColorChangeAnimation;
  // late AnimationController cardTextColorChangeController;

  late Animation<Color?> appBarColorChangeAnimation;
  // late AnimationController appBarColorChangeController;

  late Animation<Color?> textColorChangeAnimation;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _palette = Provider.of<ColorPalette>(context, listen: false);
    initializeAnimations(_palette, widget.darkMode);
  }

  void initializeAnimations(ColorPalette palette, bool darkMode) {
        
    colorChangeController = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 300));

    screenBgColorChangeAnimation1 = ColorTween(
      begin: darkMode ? palette.dark_screenBackgroundColor1 : palette.light_screenBackgroundColor1 ,
      end: darkMode ? palette.light_screenBackgroundColor1 : palette.dark_screenBackgroundColor1,
    ).animate(colorChangeController);

    screenBgColorChangeAnimation2 = ColorTween(
      begin: darkMode ? palette.dark_screenBackgroundColor2 : palette.light_screenBackgroundColor2 ,
      end: darkMode ? palette.light_screenBackgroundColor2 : palette.dark_screenBackgroundColor2,
    ).animate(colorChangeController);      

    cardBgColorChangeAnimation1 = ColorTween(
      begin: darkMode ? palette.dark_settingsScreenOptionColor1 : palette.light_settingsScreenOptionColor1,
      end: darkMode ? palette.light_settingsScreenOptionColor1 : palette.dark_settingsScreenOptionColor1,
    ).animate(colorChangeController);  

    cardBgColorChangeAnimation2 = ColorTween(
      begin: darkMode ? palette.dark_settingsScreenOptionColor2 : palette.light_settingsScreenOptionColor2,
      end: darkMode ? palette.light_settingsScreenOptionColor2 : palette.dark_settingsScreenOptionColor2,
    ).animate(colorChangeController);

    cardTextColorChangeAnimation = ColorTween(
      begin: darkMode ? palette.dark_settingsScreenOptionTextColor : palette.light_settingsScreenOptionTextColor,
      end: darkMode ? palette.light_settingsScreenOptionTextColor : palette.dark_settingsScreenOptionTextColor,
    ).animate(colorChangeController);  

    appBarColorChangeAnimation = ColorTween(
      begin: darkMode ? palette.dark_appBarColor : palette.light_appBarColor,
      end: darkMode ? palette.light_appBarColor : palette.dark_appBarColor,
    ).animate(colorChangeController);  

    textColorChangeAnimation = ColorTween(
      begin: darkMode ? palette.dark_textColor1 : palette.light_textColor1,
      end: darkMode ? palette.light_textColor1 : palette.dark_textColor1,
    ).animate(colorChangeController);                  

  }


  void toggleUserNameEditView() {
    setState(() {
      userNameEditView = !userNameEditView;
    });
  }



  Future<void> updateParameter( String parameter, dynamic parameterData, ColorPalette palette) async {
    if (parameter == 'darkMode') {
      palette.getThemeColors(parameterData);
    }
    await FirestoreMethods().updateParameters(
        AuthService().currentUser!.uid, parameter, parameterData);
  }

  void updateSettingsState(List<dynamic> languages, String currentLanguage) {

    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);

    late List<Map<String, dynamic>> selected = settingsState.languageDataList
        .where((element) => languages.contains(element['flag']))
        .toList();

    late List<Map<String, dynamic>> unSelected = settingsState.languageDataList
        .where((element) => !languages.contains(element['flag']))
        .toList();

    late List<Map<String, dynamic>> newList = [...selected, ...unSelected];

    late List<Map<String, dynamic>> sortedList = [];

    for (int i = 0; i < newList.length; i++) {
      Map<String, dynamic> newObject = newList[i];
      if (languages.contains(newObject['flag'])) {
        newObject.update("selected", (value) => true);
        if (newObject['flag'] == currentLanguage) {
          newObject.update("primary", (value) => true);
        }
      }
      sortedList.add(newObject);
    }
    settingsState.setLanguageDataList(sortedList);
  }



  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    late SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
    late SettingsController settings = Provider.of<SettingsController>(context,listen: false);
    final AudioController audioController = Provider.of<AudioController>(context, listen: false);
    final GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);

    // return isLoading? const Center(child: CircularProgressIndicator(),): 
    return PopScope(
      canPop: false,
    
      // onPopInvoked: (details) {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const WelcomeUser())
      //   );
      // },        
      child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .doc("users/${AuthService().currentUser!.uid}")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return  const Center(child: CircularProgressIndicator());
                }
                var document = snapshot.data;
                String username = document?['username'];
                var darkMode = document?['parameters']['darkMode'];
                var soundOn = document?['parameters']['soundOn'];
                // var muted = document?['parameters']['muted'];
                var currentLanguage = document?['parameters']['currentLanguage'];
                List<dynamic> languages = document?['parameters']['languages'];
      
                final double screenWidth = settingsState.screenSizeData['width'];
                final double screenHeight = settingsState.screenSizeData['height'];      
                final List<Map<String,dynamic>> decorationDetails = gamePlayState.decorationData;

                return Consumer<ColorPalette>(
                  builder: (context, palette, child) {
                    return SafeArea(
                      child: AnimatedBuilder(
                        animation: colorChangeController,
                        builder: (context, child) {                        
                          return Stack(                            
                            children: [
                              CustomPaint(
                                size: Size(screenWidth, screenHeight), 
                                painter: SettingsScreenCustomBackground(
                                  gradientColor1: screenBgColorChangeAnimation1.value!, 
                                  gradientColor2: screenBgColorChangeAnimation2.value!,
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
                                      preferredSize: Size(double.infinity, gamePlayState.tileSize),
                                      child: AppBar(
                                        leading: SizedBox(),
                                        // backgroundColor: appBarColorChangeAnimation.value,
                                        backgroundColor: Colors.transparent,
                                        flexibleSpace: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.arrow_back),
                                                iconSize: gamePlayState.tileSize*0.4,
                                                color: textColorChangeAnimation.value, // palette.textColor2,
                                                onPressed: () {
                                                  audioController.playSfx(SfxType.optionSelected);
                                                  Navigator.of(context).pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) => const WelcomeUser(),
                                                    ),
                                                  );
                                                },
                                              ),                                         
                                              Text(Helpers().translateText(currentLanguage, 'Settings',settingsState),
                                                style: TextStyle(
                                                  color: textColorChangeAnimation.value, //palette.textColor2,
                                                  fontSize: gamePlayState.tileSize*0.4
                                                ),
                                                                                
                                              ),
                                            ],
                                          ),
                                        ),                                  
                                        // backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    // backgroundColor: screenBgColorChangeAnimation.value,                          
                                    body: SingleChildScrollView(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxWidth: 600
                                          ),
                                          child: Container(
                                            // color: screenBgColorChangeAnimation.value,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: gamePlayState.tileSize*0.35,
                                                ),
                                                Text(
                                                  Helpers().translateText(
                                                    currentLanguage, "Username",settingsState
                                                    
                                                  ),                               
                                                  style: TextStyle(
                                                      fontSize: (gamePlayState.tileSize*0.41), 
                                                      color: textColorChangeAnimation.value, //_palette.textColor1
                                                    ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0.33*gamePlayState.tileSize, 
                                                      0.03*gamePlayState.tileSize, 
                                                      0.33*gamePlayState.tileSize, 
                                                      0.03*gamePlayState.tileSize
                                                    ),
                                                  child: Padding(
                                                    padding: EdgeInsets.fromLTRB(
                                                        0.03*gamePlayState.tileSize, 
                                                        0.03*gamePlayState.tileSize, 
                                                        0.03*gamePlayState.tileSize, 
                                                        0.03*gamePlayState.tileSize
                                                      ),
                                                    child: Container(
                                                      height: gamePlayState.tileSize*1,
                                                      decoration: getCustomBoxDecoration(
                                                        gamePlayState.tileSize, 
                                                        palette, 
                                                        cardBgColorChangeAnimation1,
                                                        cardBgColorChangeAnimation2,
                                                        4
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.fromLTRB(
                                                          gamePlayState.tileSize*0.25,
                                                          gamePlayState.tileSize*0.05,
                                                          gamePlayState.tileSize*0.05,
                                                          gamePlayState.tileSize*0.05,
                                                        ),
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: usernameCard(
                                                            userNameEditView,
                                                            username,
                                                            _userNameController,
                                                            toggleUserNameEditView,
                                                            palette,
                                                            // settingsState,
                                                            gamePlayState.tileSize,
                                                            currentLanguage,
                                                            context,
                                                            cardBgColorChangeAnimation1,
                                                            cardBgColorChangeAnimation2,
                                                            cardTextColorChangeAnimation,
                                                            settingsState
                                                          )
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: gamePlayState.tileSize*0.35,
                                                ),
                                                Text(
                                                  Helpers().translateText(
                                                    currentLanguage,
                                                    "Parameters",
                                                    settingsState
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: (gamePlayState.tileSize*0.41), 
                                                      color: textColorChangeAnimation.value, //_palette.textColor1
                                                    ),
                                                ),
                                                parameterCard(
                                                  palette,
                                                  Helpers().translateText(currentLanguage, "Color Theme",settingsState),
                                                  
                                                  () {
                                                    // toggleDarkTheme(_palette,!darkMode);
                                                    /// super complicated but basically, what happens without the nested if statement
                                                    /// is that when darkmode is initially true, then the first time changing the
                                                    /// theme doesn't work
                                                    if (darkMode) {
                                                      if (widget.darkMode) {
                                                        colorChangeController.reset();
                                                        colorChangeController.forward();                                            
                                                      } else {
                                                        colorChangeController.reverse();
                                                      }
                                                      // colorChangeController.forward();                                          
                                                    } else {
                                                      if (widget.darkMode) {
                                                        colorChangeController.reverse();
                                                      } else {
                                                        colorChangeController.reset();
                                                        colorChangeController.forward();
                                                      }
                                                      // colorChangeController.fling();
                                                    }
                                                    updateParameter("darkMode", !darkMode, _palette, );
                                                  },
                                                  [
                                                    Icon(Icons.nightlight, size: (gamePlayState.tileSize*0.38)),
                                                    Icon(Icons.sunny, size: (gamePlayState.tileSize*0.38)),
                                                  ],
                                                  darkMode,
                                                  gamePlayState.tileSize,
                                                  cardBgColorChangeAnimation1,
                                                  cardBgColorChangeAnimation2,
                                                  cardTextColorChangeAnimation,
                                                  2                                      
                                                ),
                                                parameterCard(
                                                  palette,
                                                  soundOn ? Helpers().translateText(currentLanguage, "Sound On",settingsState) 
                                                  : Helpers().translateText(currentLanguage, "Sound Off",settingsState),
                                                  
                                                  () {
                                                    settings.toggleSoundsOn();
                                                    updateParameter("soundOn", !soundOn, _palette);
                                                  },
                                                  [
                                                    Icon(Icons.volume_up, size: (gamePlayState.tileSize*0.38)),
                                                    Icon(Icons.volume_off, size: (gamePlayState.tileSize*0.38)),
                                                  ],
                                                  soundOn,
                                                  gamePlayState.tileSize,
                                                  cardBgColorChangeAnimation1,
                                                  cardBgColorChangeAnimation2,
                                                  cardTextColorChangeAnimation,
                                                  3                                   
                                                ),
                                                Text(
                                                  Helpers().translateText(currentLanguage, "Language",settingsState),
                                                  style: TextStyle(
                                                      fontSize: (gamePlayState.tileSize*0.41), color: textColorChangeAnimation.value),
                                                ),
                                                                    
                                                
                                                languageCard(
                                                  palette,
                                                  Helpers().translateText(currentLanguage, "Current",settingsState),
                                                  currentLanguage,
                                                  languages,
                                                  currentLanguage,
                                                  gamePlayState.tileSize,
                                                  cardBgColorChangeAnimation1,
                                                  cardBgColorChangeAnimation2,
                                                  cardTextColorChangeAnimation,
                                                  settingsState
                                                ),
                                                                    
                                                
                                                SizedBox(
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: gamePlayState.tileSize*0.35),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          displayLanguagesDialog(context, palette, languages, currentLanguage);  
                                                          updateSettingsState(languages, currentLanguage);
                                                        },
                                                        child: Container(
                                                          decoration: getCustomBoxDecoration(
                                                            gamePlayState.tileSize, 
                                                            palette, 
                                                            cardBgColorChangeAnimation1, 
                                                            cardBgColorChangeAnimation2, 
                                                            4
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.all(gamePlayState.tileSize*0.15),
                                                            child: Text(
                                                              Helpers().translateText(currentLanguage, "Add / Remove Language",settingsState),
                                                              style: TextStyle(
                                                                fontSize: gamePlayState.tileSize*0.3,
                                                                color: cardTextColorChangeAnimation.value,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: gamePlayState.tileSize*0.25,),
                                                                    
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: Text(
                                                      // "Privacy Policy",
                                                      Helpers().translateText(currentLanguage, "Link to Privacy Policy",settingsState),
                                                      style: TextStyle(
                                                          fontSize: (gamePlayState.tileSize*0.38), color: textColorChangeAnimation.value),
                                                          textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap:() {
                                                      _launchURL("https://nodamngoodstudios.com/games/scribby/privacy-policy");
                                                    },
                                                  child: parameterCard(
                                                    palette,
                                                    Helpers().translateText(currentLanguage, "Privacy Policy",settingsState),
                                                    // "Link to privacy policy",
                                                    () {
                                                      _launchURL("https://nodamngoodstudios.com/games/scribby/privacy-policy");
                                                    },
                                                    [
                                                      Icon(Icons.insert_link_rounded, size: (gamePlayState.tileSize*0.35) ,),
                                                      Icon(Icons.insert_link_rounded, size: (gamePlayState.tileSize*0.35) ,),
                                                    ],
                                                    soundOn,
                                                    gamePlayState.tileSize,
                                                    cardBgColorChangeAnimation1,
                                                    cardBgColorChangeAnimation2,
                                                    cardTextColorChangeAnimation,
                                                    4                                 
                                                  ),
                                                ),                                                                     
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
      }),
    );
  }
}


Widget usernameCard(
  bool userNameEditView, 
  String username, 
  TextEditingController userNameController, 
  VoidCallback toggleUserNameEditView, 
  ColorPalette palette,
  // SettingsState settingsState,
  double tileSize,
  String currentLanguage,
  BuildContext context,
  Animation bgColor1,
  Animation bgColor2,
  Animation textColor,
  SettingsState settingsState,
  ) {
  if (userNameEditView) {
    return Row(
      children: [
        Flexible( // Use Flexible here to allow the text to resize if needed
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              Helpers().capitalizeName(username),
              style: TextStyle(
                fontSize: (tileSize*0.3),
                color: textColor.value, //palette.textColor2
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: (){}, 
          icon: Icon(
            Icons.edit,
            color: userNameEditView ? Colors.transparent : textColor.value,
            // color: textColor.value,
            size: tileSize*0.3,
          )
        ),        
      ],
    );
    
  } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible( // Use Flexible here to allow the text to resize if needed
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              Helpers().capitalizeName(username),
              style: TextStyle(
                fontSize: (tileSize*0.3),
                color: textColor.value, //palette.textColor2
              ),
            ),
          ),
        ),

        IconButton(
          onPressed: () {
            toggleUserNameEditView();
            showDialog(
              barrierDismissible: false,
              context: context, 
              builder:(context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(tileSize*0.25)
                    )
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                    ),
                    child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.25)),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topLeft,
                        colors: [
                          palette.tileGradientShade4Color1,
                          palette.tileGradientShade4Color2,
                        ]
                      ),
                      border: Border(
                        bottom: BorderSide(color: palette.fullTileBorderColor ,width: tileSize*0.05),
                        left: BorderSide(color: palette.fullTileBorderColor ,width: tileSize*0.05),
                        top: BorderSide(color: palette.fullTileBorderColor ,width: tileSize*0.02),
                        right: BorderSide(color: palette.fullTileBorderColor ,width: tileSize*0.02),
                      )
                    ),                      
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          tileSize*0.05,
                          tileSize*0.20,
                          tileSize*0.05,
                          tileSize*0.20,
                      
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal:tileSize*0.15),
                              child: Center(
                                child: Text(
                                  Helpers().translateText(currentLanguage, "Choose new Username",settingsState),
                                  style: TextStyle(
                                    color: textColor.value,
                                    fontSize: (tileSize*0.35)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: tileSize*0.05,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: tileSize*0.15),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Helpers().translateText(currentLanguage, "No bad words",settingsState),
                                      style: TextStyle(
                                        color: palette.fullTileTextColor
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      Helpers().translateText(currentLanguage, "No unoriginal names ('user', 'player', etc.)",settingsState),
                                      style: TextStyle(
                                        color: palette.fullTileTextColor
                                      ),
                                      textAlign: TextAlign.start,                                    
                                    ),
                                    Text(
                                      Helpers().translateText(currentLanguage, "Minimum 3 characters",settingsState),
                                      style: TextStyle(
                                        color: palette.fullTileTextColor
                                      ),
                                      textAlign: TextAlign.start,                                    
                                    ),
                                    Text(
                                      Helpers().translateText(currentLanguage, "Maximum 40 characters",settingsState),
                                      style: TextStyle(
                                        color: palette.fullTileTextColor
                                      ),
                                      textAlign: TextAlign.start,                                    
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.all(tileSize*0.25),
                              child: SizedBox(
                                // height: 30,
                                width: double.infinity,
                                child: TextField(
                                  cursorColor: textColor.value,
                                  style: TextStyle(
                                    color: textColor.value,
                                    decorationColor: Colors.transparent
                                  ),
                                                  
                                  controller: userNameController,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      // borderRadius: BorderRadius.circular(tileSize*0.25,),
                                      borderSide: BorderSide(
                                        color: textColor.value,
                                      ),                                  
                                    ),
                                    // border: OutlineInputBorder(
                                    //   borderRadius: BorderRadius.circular(10.0),
                                    // ),                                    
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:  textColor.value
                                      )
                                    ),
                                    labelText: Helpers().translateText(currentLanguage,"Username",settingsState),
                                    labelStyle: TextStyle(
                                      color:textColor.value, //  palette.textColor2
                                    )
                                  ),
                                  
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Expanded(child: SizedBox()),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      toggleUserNameEditView();
                                    },
                                    child: Text(
                                      Helpers().translateText(currentLanguage, "Cancel",settingsState),
                                      style: TextStyle(
                                        fontSize: tileSize*0.3,
                                        color: textColor.value
                                      ),                           
                                    ),
                                  ),
                                ),                              
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      late List<String> forbiddenNames = [
                                        "player", "user", "username",
                                      ];
                                                  
                                                  
                                      if (forbiddenNames.contains(userNameController.text.toLowerCase())) {
                                        showUserNameSnackBar(
                                          context,palette,tileSize,Helpers().translateText(currentLanguage, "Pick something more original",settingsState)
                                        );
                                        // Helpers().showBadNameDialog(
                                        //   context,
                                        //   Helpers().translateText(currentLanguage, "Hold On"),
                                        //   Helpers().translateText(currentLanguage, "Pick something more original"),
                                        //   Helpers().translateText(currentLanguage, "Okay"),
                                        //   palette
                                                  
                                        // );
                                      } else if (Helpers().checkForBadWords(userNameController.text.toLowerCase())) {
                                        showUserNameSnackBar(
                                          context,palette,tileSize,Helpers().translateText(currentLanguage, "Hey! No bad words!",settingsState)
                                        );                                        
                                        // Helpers().showBadNameDialog(
                                        //   context,
                                        //   Helpers().translateText(currentLanguage, "Excuse me!"),
                                        //   Helpers().translateText(currentLanguage, "Hey! No bad words!"),
                                        //   Helpers().translateText(currentLanguage, "Okay"),
                                        //   palette 
                                        // );
                                      } else if (userNameController.text.toLowerCase().length  < 3) {
                                        showUserNameSnackBar(
                                          context,palette,tileSize,Helpers().translateText(currentLanguage, "Username must be at least 3 characters",settingsState)
                                        );                                        
                                        // Helpers().showBadNameDialog(
                                        //   context,
                                        //   Helpers().translateText(currentLanguage, "Hold On"),
                                        //   Helpers().translateText(currentLanguage, "Pick something more original"),
                                        //   Helpers().translateText(currentLanguage, "Okay"),
                                        //   palette
                                        // );                        
                                      } else if (userNameController.text.toLowerCase().length  > 40) {
                                        showUserNameSnackBar(
                                          context,palette,tileSize,Helpers().translateText(currentLanguage, "Username must be at most 40 characters",settingsState)
                                        );                                        
                                        // Helpers().showBadNameDialog(
                                        //   context,
                                        //   Helpers().translateText(currentLanguage, "Hold On"),
                                        //   Helpers().translateText(currentLanguage, "Pick something more original"),
                                        //   Helpers().translateText(currentLanguage, "Okay"),
                                        //   palette
                                        // );                        
                                                  
                                                                                        
                                      } else {
                                      
                                        AuthService().updateUsername(AuthService().currentUser!.uid ,userNameController.text.toString());
                                                  
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              Helpers().translateText(currentLanguage, "username successfully updated",settingsState),
                                              style: TextStyle(
                                                color: palette.focusedTutorialTile,
                                                fontSize: tileSize*0.3
                                              ),
                                            ),
                                            duration: const Duration(milliseconds: 3000),
                                          )
                                        );                                
                                        Navigator.of(context).pop();
                                        toggleUserNameEditView();
                                      }
                                    },
                                    child: Text(
                                      Helpers().translateText(currentLanguage, "Save",settingsState),
                                      style: TextStyle(
                                        fontSize: tileSize*0.3,
                                        color: textColor.value
                                      ),                           
                                    ),
                                  ),
                                ),
                                                  
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }, 
          icon: Icon(
            Icons.edit,
            color: userNameEditView ? Colors.transparent : textColor.value,
            size: tileSize*0.3,
          )
        ),
      ],
    );
  }

}

Widget parameterCard(
  ColorPalette palette, 
  String cardBody, 
  VoidCallback onPressed, 
  List<Icon> iconList, 
  var value, 
  double tileSize,
  Animation bgColor1,
  Animation bgColor2,
  Animation textColor,
  int angleIndex
  ) {

  return Padding(
    padding: EdgeInsets.fromLTRB((tileSize*0.33), (tileSize*0.03), (tileSize*0.33), (tileSize*0.03)),
    child: Padding(
      padding: EdgeInsets.fromLTRB((tileSize*0.03), (tileSize*0.03), (tileSize*0.03), (tileSize*0.03)),
      child: Container(
        height: tileSize,
        decoration: getCustomBoxDecoration(tileSize, palette, bgColor1, bgColor2, angleIndex),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(tileSize*0.25,tileSize*0.05,tileSize*0.05,tileSize*0.05),
              child: Row(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      cardBody,
                      style: TextStyle(fontSize: (tileSize*0.30), color: textColor.value),
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                  IconButton(
                      onPressed: onPressed,
                      icon: value ? iconList[0] : iconList[1],
                      color: textColor.value,
                  ),
                      // color: value
                          // ? const Color.fromARGB(255, 15, 214, 214)
                          // : Colors.amber[600]),
                ],
              ),
            )),
      ),
    ),
  );
}

Widget languageCard(
  ColorPalette palette, 
  String cardBody, 
  var value, 
  List<dynamic> languages, 
  String currentLanguage, 
  double tileSize,
  Animation bgColor1,
  Animation bgColor2,
  Animation textColor,
  SettingsState settingsState
  ) {

  Future<void> changeCurrentLanguage(dynamic newLanguage) async {
    await FirestoreMethods().updateParameters(AuthService().currentUser!.uid, "currentLanguage", newLanguage);
  }

  return Padding(
    padding: EdgeInsets.fromLTRB(tileSize*0.33, tileSize*0.03, tileSize*0.33, tileSize*0.03),
    child: Card(
      // color: bgColor.value,
      child: Container(
        height: tileSize,
        decoration: getCustomBoxDecoration(tileSize, palette, bgColor1, bgColor2, 3),
        child: Padding(
          padding: EdgeInsets.fromLTRB(tileSize*0.36, tileSize*0.06, tileSize*0.36, tileSize*0.06),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    cardBody,
                    style: TextStyle(
                      fontSize: (tileSize*0.35),
                      color: textColor.value,
                      // height: 3,
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                  DropdownButton(
                    value: value,
                    // dropdownColor: palette.optionButtonBgColor,
                    dropdownColor: palette.tileGradientShade3Color1,
                    items: languages.map<DropdownMenuItem<dynamic>>(
                      (dynamic val) {
                        return DropdownMenuItem<dynamic>(
                          value: val,
                          child: Text(
                            Helpers().translateText(currentLanguage,val,settingsState),
                            // Helpers().capitalize(val),
                            style: TextStyle(
                              fontSize: tileSize*0.3,
                              color: textColor.value,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (val) {
                      // print(" change to $val ");
                      changeCurrentLanguage(val);
                    },
                  )
                ],
              )),
        ),
      ),
    ),
  );
}


  BoxDecoration getCustomBoxDecoration(double tileSize, ColorPalette palette, Animation color1Animation, Animation color2Animation, int angleIndex) {

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
          color1Animation.value,
          color2Animation.value
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

Future<void> displayLanguagesDialog(BuildContext context, ColorPalette palette, List<dynamic> languages, String currentLanguage) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return LanguageDialog(
        languages: languages,
        palette: palette,
        currentLanguage: currentLanguage,
      );
    },
  );
}

class LanguageDialog extends StatefulWidget {
  final List<dynamic> languages;
  final ColorPalette palette;
  final String currentLanguage;

  const LanguageDialog(
      {super.key,
      required this.languages,
      required this.palette,
      required this.currentLanguage});

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  late List<Map<String, dynamic>> currentSelection = [];
  late List<Map<String, dynamic>> originalSelection;
  late SettingsState _settingsState;

  @override
  void initState() {
    super.initState();
    _settingsState = Provider.of<SettingsState>(context, listen: false);

    getLatestSelection(widget.languages, _settingsState);
  }



  void getLatestSelection( List<dynamic> languages, SettingsState settingsState) {

    late List<Map<String, dynamic>> selected = settingsState.languageDataList
        // .where((element) => element['selected'] == true)
        .where((element) => languages.contains(element['flag']))
        .toList();
    late List<Map<String, dynamic>> unSelected = settingsState.languageDataList
        // .where((element) => element['selected'] == false)
        .where((element) => !languages.contains(element['flag']))
        .toList();

    late List<Map<String, dynamic>> newList = [...selected, ...unSelected];

    late List<Map<String, dynamic>> sortedList = [];

    for (int i = 0; i < newList.length; i++) {
      Map<String, dynamic> newObject = newList[i];
      if (newObject['selected']) {
        newObject['originalSelection'] = "added";
      } else {
        newObject['originalSelection'] = "removed";
      }
      newObject['change'] = 'null';
      sortedList.add(newObject);
    }

    setState(() {
      currentSelection = sortedList;
    });
  }

  void cancelSelections(List<dynamic> languages, SettingsState settingsState) {
    late List<Map<String, dynamic>> selected = settingsState.languageDataList
        .where((element) => languages.contains(element['flag']))
        .toList();
    late List<Map<String, dynamic>> unSelected = settingsState.languageDataList
        .where((element) => !languages.contains(element['flag']))
        .toList();
  

    // get the langs that are not part of the original selected but were marked selected = true
    late List<Map<String,dynamic>> newUnSelected = [];
    for (Map<String,dynamic> item in unSelected) {
      if (item['selected'] == true) {
        item.update('selected', (value) => false);
      }
      newUnSelected.add(item);
    }


    late List<Map<String,dynamic>> newSelected = [];
    for (Map<String,dynamic> item in selected) {
      if (item['selected'] == false) {
        item.update('selected', (value) => true);
      }
      newSelected.add(item);
    }    

    late List<Map<String, dynamic>> newList = [...newSelected, ...newUnSelected];


    setState(() {
      currentSelection = newList;
    });

  }


  String translateDynamicLanguage(String language, String originalString, String flag, SettingsState settingsState) {
      String tranlatedFlag = Helpers().translateText(language, flag, settingsState);
      String res = originalString.replaceAll('new_language', tranlatedFlag);
      return res;
  }



  void updateList(List<Map<String, dynamic>> languages,Map<String, dynamic> targetObject, String currentLanguage, SettingsState settingsState) {

    // late List<Map<String,dynamic>> languagesCopy = languages.map((e) => e ).toList();

    if (targetObject['flag'] == currentLanguage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Can't remove the current language!"),
          duration: Duration(milliseconds: 1000),
        )
      );
    } else {
      late String result = "";
      for (int i = 0; i < languages.length; i++) {
        late Map<String, dynamic> languageObject = languages[i];
        if (languageObject["flag"] == targetObject["flag"]) {
          if (targetObject['selected'] == true) {
            languageObject.update("change", (value) => "removed");
            languageObject.update("selected", (value) => false);
            // result = "Removed";
            result = Helpers().translateText(currentLanguage, "new_language was removed from languages",settingsState);
          } else {
            languageObject.update("change", (value) => "added");
            languageObject.update("selected", (value) => true);
            // result = "Added";
            result = Helpers().translateText(currentLanguage, "new_language was added to languages",settingsState);
          }
        }
      }
      setState(() {
        currentSelection = languages;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          translateDynamicLanguage(currentLanguage, result, targetObject['flag'],settingsState)
        ),
        duration: const Duration(milliseconds: 1000),
      ));
    }
  }

  void setUpdatedLanguages(List<Map<String, dynamic>> currentSelection, String currentLanguage) {
    List<String> newLanguages = [];

    for (Map<String, dynamic> languageObject in currentSelection) {
      if (languageObject['selected'] == true) {
        newLanguages.add(languageObject['flag']);
      }
    }

    FirestoreMethods().updateParameters(AuthService().currentUser!.uid, "languages", newLanguages);
    Navigator.of(context).pop();

  }

  // Color getLanguageColor(
  //     String status, String originalSelection, ColorPalette palette) {
  //   Color? res = Colors.transparent;
  //   if (originalSelection == "added") {
  //     switch (status) {
  //       case "null":
  //         res = palette.optionButtonBgColor;
  //         break;
  //       case "added":
  //         res = palette.optionButtonBgColor;
  //         break;
  //       case "removed":
  //         res = const Color.fromARGB(90, 239, 154, 154);
  //     }
  //   } else if (originalSelection == "removed") {
  //     switch (status) {
  //       case "null":
  //         res = palette.optionButtonBgColor;
  //         break;
  //       case "added":
  //         res = const Color.fromARGB(108, 165, 214, 167);
  //         break;
  //       case "removed":
  //         res = palette.optionButtonBgColor;
  //     }
  //   }

  //   return res;
  // }

  @override
  Widget build(BuildContext context) {

    late SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
    late ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);
    late GamePlayState gamePlayState = Provider.of<GamePlayState>(context,listen: false);
    final double maxHeight = settingsState.screenSizeData['height']*0.7;
    final double ts = gamePlayState.tileSize;
    
    return Dialog(
      // backgroundColor: widget.palette.modalNavigationBarBgColor ,
      
      // backgroundColor: widget.palette.optionButtonBgColor ,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(gamePlayState.tileSize*0.35)
        )
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          // maxHeight: settingsState.screenSizeData['height']*0.5
        ),
        child: Container(
          width: gamePlayState.tileSize*6,
          // height: gamePlayState.tileSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topRight,
              colors: <Color>[
                palette.tileGradientShade5Color1,
                palette.tileGradientShade5Color2
              ]
            ),
            borderRadius: BorderRadius.all(Radius.circular(gamePlayState.tileSize*0.35)),
            border: Border(
              bottom: BorderSide(color: palette.fullTileBorderColor ,width: gamePlayState.tileSize*0.05),
              left: BorderSide(color: palette.fullTileBorderColor ,width: gamePlayState.tileSize*0.05),
              top: BorderSide(color: palette.fullTileBorderColor ,width: gamePlayState.tileSize*0.02),
              right: BorderSide(color: palette.fullTileBorderColor ,width: gamePlayState.tileSize*0.02),
            )
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Container(
                  height: ts,
                  child: Center(
                    child: Text(
                      Helpers().translateText(widget.currentLanguage, "Add / Remove Language", settingsState),
                      style: TextStyle(
                        color: widget.palette.fullTileTextColor,
                        fontSize: gamePlayState.tileSize*0.35
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: maxHeight
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (Map<String,dynamic> language in  currentSelection)
                      
                        GestureDetector(
                          onTap: () {
                            updateList(currentSelection, language, widget.currentLanguage, settingsState);
                            // print("caca butt ${language['flag']}");
                          },
                          child: Container(
                            width: ts*4.5,
                            height: ts*1.1,                              
                            child: Stack(
                              children: [
                            
                                Positioned(
                                  top: (ts-(ts*0.75))/2,
                                  left: ((ts*4.5)-(ts*4.2))/2,
                                  child: Container(
                                    width: ts*4.2,
                                    height: ts*0.75,
                                    decoration: getCustomCountryGradients(gamePlayState.tileSize, language['flag'],language['selected']),
                                    child: Center(
                                      child: Text(
                                        language['body'],
                                        style:TextStyle(
                                          // color: widget.palette.optionButtonTextColor,
                                          color: Colors.black,
                                          fontSize: gamePlayState.tileSize*0.34
                                        ),                                
                                      ),
                                    ),                                    
                                  ),
                                ),
                            
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: language['selected'] ? 1.0 : 0.0,
                                    child: Container(
                                      width: ts*4.5,
                                      height: ts*1,
                                      // color: ui.Color.fromARGB(66, 255, 153, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(ts*0.20)),
                                        border: Border.all(
                                          width: ts*0.04,
                                          color: Colors.black.withOpacity(1.0)
                                        )
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: ts,
                    width: ts*4.2,
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox(),),
                        TextButton(
                          onPressed: () {
                            cancelSelections(widget.languages, _settingsState);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            Helpers().translateText(widget.currentLanguage, "Cancel",settingsState),
                            style: TextStyle(
                              color: widget.palette.fullTileTextColor,
                              fontSize: gamePlayState.tileSize*0.3
                            ),
                          )
                        ),
                        TextButton(
                          onPressed: () {
                            setUpdatedLanguages(currentSelection, widget.currentLanguage);
                          },
                          child: Text(
                            Helpers().translateText(widget.currentLanguage, "Save",settingsState),
                            style: TextStyle(
                              color: widget.palette.fullTileTextColor,
                              fontSize: gamePlayState.tileSize*0.3
                            ),
                          )
                        ),                  
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _launchURL(url_string) async {
   final Uri url = Uri.parse(url_string);
  //  print("okay go to $url");
   if (!await launchUrl(url)) {
        throw Exception('Could not launch privacy policy');
    }
}


class SettingsScreenCustomBackground extends CustomPainter {
  final Color gradientColor1;
  final Color gradientColor2;
  SettingsScreenCustomBackground({required this.gradientColor1,required this.gradientColor2});

  @override
  void paint(Canvas canvas, Size size) {
  final paint = Paint()
    ..shader = ui.Gradient.linear(
      Offset(0,0),
      Offset(size.width, size.height),
      [
        gradientColor1,
        gradientColor2
      ],
    );
    // Draw background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


BoxDecoration getCustomCountryGradients(double tileSize, String flag, bool selected) {
  double selectedVal = selected ? 1.0 : 0.5;
  Color red = ui.Color.fromRGBO(241, 135, 127, selectedVal);
  Color green = ui.Color.fromRGBO(145, 240, 148, selectedVal);
  Color blue = ui.Color.fromRGBO(135, 187, 230, selectedVal);
  Color yellow = ui.Color.fromRGBO(238, 230, 156, selectedVal);
  Color black = ui.Color.fromRGBO(77, 76, 76, selectedVal);
  Color white = ui.Color.fromRGBO(255, 255, 255, selectedVal);

  late BoxDecoration res = BoxDecoration();


  if (flag == 'french') {
    res = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [blue,white,red]
      ),
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.15)),
      border: Border.all(width: tileSize*0.01, color: Colors.black)
    );
  } else if (flag == 'spanish') {
    res = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [red,yellow,red]
      ), 
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.15)),
      border: Border.all(width: tileSize*0.01, color: Colors.black)
    );
  } else if (flag == 'portuguese') {
    res = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [green,red,red]
      ), 
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.15)),
      border: Border.all(width: tileSize*0.01, color: Colors.black)
    );
  } else if (flag == 'english') {
    res = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [blue,white,red,white,blue]
      ), 
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.15)),
      border: Border.all(width: tileSize*0.01, color: Colors.black)
    );
  } else if (flag == 'greek') {
    res = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [blue,white,blue,white,blue]
      ), 
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.15)),
      border: Border.all(width: tileSize*0.01, color: Colors.black)
    );    
  } else if (flag == 'german') {
    res = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [black, red, yellow]
      ), 
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.15)),
      border: Border.all(width: tileSize*0.01, color: Colors.black)
    );
  } else if (flag == 'dutch') {
    res = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [red, white, blue]
      ), 
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.15)),
      border: Border.all(width: tileSize*0.01, color: Colors.black)
    );
  } else if (flag == 'italian') {
    res = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [green,white,red]
      ), 
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.15)),
      border: Border.all(width: tileSize*0.01, color: Colors.black)
    );
  }
  return res;

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