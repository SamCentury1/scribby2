
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/welcome_user.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';
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
  // late Map<String,dynamic> _userData = {};
  late ColorPalette _palette;
  late TextEditingController _userNameController;

  late Animation<Color?> screenBgColorChangeAnimation;
  late AnimationController colorChangeController; 

  late Animation<Color?> cardBgColorChangeAnimation;
  // late AnimationController cardBgColorChangeController;   

  late Animation<Color?> cardTextColorChangeAnimation;
  // late AnimationController cardTextColorChangeController;

  late Animation<Color?> appBarColorChangeAnimation;
  // late AnimationController appBarColorChangeController;

  late Animation<Color?> textColorChangeAnimation;

  @override
  void initState() {
    super.initState();
    // getUserFromFirebase();
    _userNameController = TextEditingController();
    _palette = Provider.of<ColorPalette>(context, listen: false);
    initializeAnimations(_palette, widget.darkMode);
  }

  void initializeAnimations(ColorPalette palette, bool darkMode) {

    colorChangeController = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 300));

    screenBgColorChangeAnimation = ColorTween(
      // streakSlideEnterTweenSequence
      begin: darkMode ? palette.dark_screenBackgroundColor : palette.light_screenBackgroundColor ,
      end: darkMode ? palette.light_screenBackgroundColor : palette.dark_screenBackgroundColor,
    ).animate(colorChangeController);  

    cardBgColorChangeAnimation = ColorTween(
      // streakSlideEnterTweenSequence
      begin: darkMode ? palette.dark_optionButtonBgColor2 : palette.light_optionButtonBgColor2,
      end: darkMode ? palette.light_optionButtonBgColor2 : palette.dark_optionButtonBgColor2,
    ).animate(colorChangeController);  

    cardTextColorChangeAnimation = ColorTween(
      // streakSlideEnterTweenSequence
      begin: darkMode ? palette.dark_textColor2 : palette.light_textColor2,
      end: darkMode ? palette.light_textColor2 : palette.dark_textColor2,
    ).animate(colorChangeController);  

    appBarColorChangeAnimation = ColorTween(
      // streakSlideEnterTweenSequence
      begin: darkMode ? palette.dark_appBarColor : palette.light_appBarColor,
      end: darkMode ? palette.light_appBarColor : palette.dark_appBarColor,
    ).animate(colorChangeController);  

    textColorChangeAnimation = ColorTween(
      // streakSlideEnterTweenSequence
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
                var muted = document?['parameters']['muted'];
                var currentLanguage = document?['parameters']['currentLanguage'];
                List<dynamic> languages = document?['parameters']['languages'];
      
      
                return Consumer<ColorPalette>(
                  builder: (context, palette, child) {
                    return SafeArea(
                      child: AnimatedBuilder(
                        animation: screenBgColorChangeAnimation,
                        builder: (context, child) {                        
                          return Scaffold(
                              appBar: AppBar(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(30.0)
                                  )
                                ),
                                leading: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  iconSize: 24*settingsState.sizeFactor,
                                  color: textColorChangeAnimation.value, // palette.textColor2,
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const WelcomeUser(),
                                      ),
                                    );
                                  },
                                ),                              
                                title: Text(Helpers().translateText(currentLanguage, 'Settings',),
                                  style: TextStyle(
                                    color: cardTextColorChangeAnimation.value, //palette.textColor2,
                                    fontSize: 24*settingsState.sizeFactor
                                  ),
                                ),
                                backgroundColor: appBarColorChangeAnimation.value,
                                // backgroundColor: Colors.transparent,
                              ),
                              backgroundColor: screenBgColorChangeAnimation.value,                          
                              body: SingleChildScrollView(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 600
                                    ),
                                    child: Container(
                                      color: screenBgColorChangeAnimation.value,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 20*settingsState.sizeFactor,
                                          ),
                                          Text(
                                            Helpers().translateText(
                                              currentLanguage, "Username",
                                            ),                               
                                            style: TextStyle(
                                                fontSize: (22 * settingsState.sizeFactor), 
                                                color: textColorChangeAnimation.value, //_palette.textColor1
                                              ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                16.0*settingsState.sizeFactor, 
                                                4.0*settingsState.sizeFactor, 
                                                16.0*settingsState.sizeFactor, 
                                                4.0*settingsState.sizeFactor
                                              ),
                                            child: Card(
                                              color: cardBgColorChangeAnimation.value,  // palette.optionButtonBgColor,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    26.0*settingsState.sizeFactor, 
                                                    4.0*settingsState.sizeFactor, 
                                                    4.0*settingsState.sizeFactor, 
                                                    4.0*settingsState.sizeFactor
                                                  ),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: usernameCard(
                                                    userNameEditView,
                                                    username,
                                                    _userNameController,
                                                    toggleUserNameEditView,
                                                    palette,
                                                    settingsState,
                                                    currentLanguage,
                                                    context,
                                                    cardBgColorChangeAnimation,
                                                    cardTextColorChangeAnimation,
                                                  )
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30*settingsState.sizeFactor,
                                          ),
                                          Text(
                                            Helpers().translateText(
                                              currentLanguage,
                                              "Parameters",
                                            ),
                                            style: TextStyle(
                                                fontSize: (22*settingsState.sizeFactor), 
                                                color: textColorChangeAnimation.value, //_palette.textColor1
                                              ),
                                          ),
                                          parameterCard(
                                            palette,
                                            Helpers().translateText(currentLanguage, "Color Theme",),
                                            
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
                                              Icon(Icons.nightlight, size: (22*settingsState.sizeFactor)),
                                              Icon(Icons.sunny, size: (22*settingsState.sizeFactor)),
                                            ],
                                            darkMode,
                                            settingsState.sizeFactor,
                                            cardBgColorChangeAnimation,
                                            cardTextColorChangeAnimation,                                      
                                          ),
                                          parameterCard(
                                            palette,
                                            Helpers().translateText(currentLanguage, "Muted",),
                                            
                                            () {
                                              updateParameter("muted", !muted, _palette);
                                            },
                                            [
                                              Icon(Icons.volume_mute, size: (22*settingsState.sizeFactor)),
                                              Icon(Icons.volume_up, size: (22*settingsState.sizeFactor)),
                                            ],
                                            muted,
                                            settingsState.sizeFactor,
                                            cardBgColorChangeAnimation,
                                            cardTextColorChangeAnimation,                                      
                                          ),
                                          Text(
                                            Helpers().translateText(currentLanguage, "Language",),
                                            style: TextStyle(
                                                fontSize: (22*settingsState.sizeFactor), color: textColorChangeAnimation.value),
                                          ),
                                                              
                                          
                                          languageCard(
                                            palette,
                                            Helpers().translateText(currentLanguage, "Current",),
                                            currentLanguage,
                                            languages,
                                            currentLanguage,
                                            settingsState.sizeFactor,
                                            cardBgColorChangeAnimation,
                                            cardTextColorChangeAnimation,                                       
                                          ),
                                                              
                                          
                                          SizedBox(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 26.0*settingsState.sizeFactor),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          cardBgColorChangeAnimation.value,
                                                          //palette.optionButtonBgColor,
                                                      foregroundColor:
                                                          cardBgColorChangeAnimation.value,
                                                          // palette.optionButtonTextColor,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(10.0)),
                                                      )),
                                                  child: Text(
                                                    Helpers().translateText(currentLanguage, "Add / Remove Language",),
                                                    style: TextStyle(
                                                      fontSize: 16 * settingsState.sizeFactor,
                                                      color: cardTextColorChangeAnimation.value,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    displayLanguagesDialog(context, palette, languages, currentLanguage);  
                                                    updateSettingsState(languages, currentLanguage);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20*settingsState.sizeFactor,),
                                                              
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: double.infinity,
                                              child: Text(
                                                // "Privacy Policy",
                                                Helpers().translateText(currentLanguage, "Link to Privacy Policy",),
                                                style: TextStyle(
                                                    fontSize: (24*settingsState.sizeFactor), color: textColorChangeAnimation.value),
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
                                              Helpers().translateText(currentLanguage, "Privacy Policy",),
                                              // "Link to privacy policy",
                                              () {
                                                _launchURL("https://nodamngoodstudios.com/games/scribby/privacy-policy");
                                              },
                                              [
                                                Icon(Icons.insert_link_rounded, size: (22*settingsState.sizeFactor) ,),
                                                Icon(Icons.insert_link_rounded, size: (22*settingsState.sizeFactor) ,),
                                              ],
                                              soundOn,
                                              settingsState.sizeFactor,
                                              cardBgColorChangeAnimation,
                                              cardTextColorChangeAnimation,                                      
                                            ),
                                          ),                                                                     
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
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
  SettingsState settingsState,
  String currentLanguage,
  BuildContext context,
  Animation bgColor,
  Animation textColor,
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
                fontSize: (22 * settingsState.sizeFactor),
                color: textColor.value, //palette.textColor2
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: (){}, 
          icon: Icon(
            Icons.edit,
            color: userNameEditView ? Colors.transparent : palette.textColor2,
            size: 22 * settingsState.sizeFactor,
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
                fontSize: (22 * settingsState.sizeFactor),
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
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 500,

                    ),
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.width*0.6,
                    // decoration: BoxDecoration(
                    //   borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    //   color:  palette.optionButtonBgColor,
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Choose new Username",
                                style: TextStyle(
                                  color: palette.textColor2,
                                  fontSize: (22 * settingsState.sizeFactor)
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              // height: 30,
                              width: double.infinity,
                              child: TextField(
                                cursorColor: palette.textColor2,
                                style: TextStyle(
                                  color: palette.textColor2,
                                  decorationColor: Colors.black 
                                ),
                                                
                                controller: userNameController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: palette.textColor2,
                                    ),                                  
                                  ),
                                  // border: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(10.0),
                                  // ),                                    
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:  palette.textColor2
                                    )
                                  ),
                                  labelText: Helpers().translateText(currentLanguage,"Username",),
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
                                    Helpers().translateText(currentLanguage, "Cancel"),
                                    style: TextStyle(
                                      fontSize: 18 * settingsState.sizeFactor,
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
                                      Helpers().showBadNameDialog(
                                        context,
                                        Helpers().translateText(currentLanguage, "Hold On"),
                                        Helpers().translateText(currentLanguage, "Pick something more original"),
                                        Helpers().translateText(currentLanguage, "Okay"),
                                        palette
                                                
                                      );
                                    } else if (Helpers().checkForBadWords(userNameController.text.toLowerCase())) {
                                      Helpers().showBadNameDialog(
                                        context,
                                        Helpers().translateText(currentLanguage, "Excuse me!"),
                                        Helpers().translateText(currentLanguage, "Hey! No bad words!"),
                                        Helpers().translateText(currentLanguage, "Okay"),
                                        palette 
                                      );
                                    } else if (userNameController.text.toLowerCase() == "") {
                                      Helpers().showBadNameDialog(
                                        context,
                                        Helpers().translateText(currentLanguage, "Hold On"),
                                        Helpers().translateText(currentLanguage, "Pick something more original"),
                                        Helpers().translateText(currentLanguage, "Okay"),
                                        palette
                                      );                        
                                                
                                    } else if (userNameController.text.toLowerCase().length  < 3) {
                                      Helpers().showBadNameDialog(
                                        context,
                                        Helpers().translateText(currentLanguage, "Hold On"),
                                        Helpers().translateText(currentLanguage, "Pick something more original"),
                                        Helpers().translateText(currentLanguage, "Okay"),
                                        palette
                                      );                        
                                                
                                    } else {
                                    
                                      AuthService().updateUsername(AuthService().currentUser!.uid ,userNameController.text.toString());
                                                
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            Helpers().translateText(currentLanguage, "username successfully updated"),
                                            style: TextStyle(
                                              color: palette.focusedTutorialTile,
                                              fontSize: 16 * settingsState.sizeFactor
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
                                    Helpers().translateText(currentLanguage, "Save"),
                                    style: TextStyle(
                                      fontSize: 18 * settingsState.sizeFactor,
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
                );
              },
            );
          }, 
          icon: Icon(
            Icons.edit,
            color: userNameEditView ? Colors.transparent : palette.textColor2,
            size: 22 * settingsState.sizeFactor,
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
  double sizeFactor,
  Animation bgColor,
  Animation textColor,
  ) {
  return Padding(
    padding: EdgeInsets.fromLTRB((16.0*sizeFactor), (4.0*sizeFactor), (16.0*sizeFactor), (4.0*sizeFactor)),
    child: Card(
      color: bgColor.value, //palette.optionButtonBgColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB((16.0*sizeFactor), (4.0*sizeFactor), (4.0*sizeFactor), (4.0*sizeFactor)),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    cardBody,
                    style: TextStyle(fontSize: (22*sizeFactor), color: textColor.value),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox()),
                IconButton(
                    onPressed: onPressed,
                    icon: value ? iconList[0] : iconList[1],
                    color: palette.textColor2,
                ),
                    // color: value
                        // ? const Color.fromARGB(255, 15, 214, 214)
                        // : Colors.amber[600]),
              ],
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
  double sizeFactor,
  Animation bgColor,
  Animation textColor,
  ) {

  Future<void> changeCurrentLanguage(dynamic newLanguage) async {
    await FirestoreMethods().updateParameters(AuthService().currentUser!.uid, "currentLanguage", newLanguage);
  }

  return Padding(
    padding: EdgeInsets.fromLTRB(16.0*sizeFactor, 4.0*sizeFactor, 16.0*sizeFactor, 4.0*sizeFactor),
    child: Card(
      color: bgColor.value,
      child: Padding(
        padding: EdgeInsets.fromLTRB(26.0*sizeFactor, 8.0*sizeFactor, 26.0*sizeFactor, 8.0*sizeFactor),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  cardBody,
                  style: TextStyle(
                    fontSize: (22 * sizeFactor),
                    color: textColor.value,
                    // height: 3,
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox()),
                DropdownButton(
                  value: value,
                  dropdownColor: palette.optionButtonBgColor,
                  items: languages.map<DropdownMenuItem<dynamic>>(
                    (dynamic val) {
                      return DropdownMenuItem<dynamic>(
                        value: val,
                        child: Text(
                          Helpers().translateText(currentLanguage,val),
                          // Helpers().capitalize(val),
                          style: TextStyle(
                            fontSize: 18 * sizeFactor,
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


  String translateDynamicLanguage(String language, String originalString, String flag) {
      String tranlatedFlag = Helpers().translateText(language, flag);
      String res = originalString.replaceAll('new_language', tranlatedFlag);
      return res;
  }



  void updateList(List<Map<String, dynamic>> languages,Map<String, dynamic> targetObject, String currentLanguage) {

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
            result = Helpers().translateText(currentLanguage, "new_language was removed from languages");
          } else {
            languageObject.update("change", (value) => "added");
            languageObject.update("selected", (value) => true);
            // result = "Added";
            result = Helpers().translateText(currentLanguage, "new_language was added to languages");
          }
        }
      }
      setState(() {
        currentSelection = languages;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          translateDynamicLanguage(currentLanguage, result, targetObject['flag'])
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

  Color getLanguageColor(
      String status, String originalSelection, ColorPalette palette) {
    Color? res = Colors.transparent;
    if (originalSelection == "added") {
      switch (status) {
        case "null":
          res = palette.optionButtonBgColor;
          break;
        case "added":
          res = palette.optionButtonBgColor;
          break;
        case "removed":
          res = const Color.fromARGB(90, 239, 154, 154);
      }
    } else if (originalSelection == "removed") {
      switch (status) {
        case "null":
          res = palette.optionButtonBgColor;
          break;
        case "added":
          res = const Color.fromARGB(108, 165, 214, 167);
          break;
        case "removed":
          res = palette.optionButtonBgColor;
      }
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {

    late SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
    final double maxHeight = MediaQuery.of(context).size.height * 0.5;
    
    return Dialog(
      backgroundColor: widget.palette.modalNavigationBarBgColor ,
      // backgroundColor: widget.palette.optionButtonBgColor ,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Helpers().translateText(widget.currentLanguage, "Add / Remove Language",),
                  style: TextStyle(
                    color: widget.palette.optionButtonTextColor,
                    fontSize: 22 * settingsState.sizeFactor
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: maxHeight,
                ),
                // width: double.infinity,
                // height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (Map<String,dynamic> language in  currentSelection)
                    
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: getLanguageColor(language["change"],language["originalSelection"], widget.palette),
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 20*settingsState.sizeFactor,
                                  height: 20*settingsState.sizeFactor,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:const BorderRadius.all(Radius.circular(50.0)),
                                    image: DecorationImage(
                                      image: NetworkImage(language['url']),
                                    ),
                                  ),
                                ),                                
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      language['body'],
                                      style:TextStyle(
                                        color: widget.palette.optionButtonTextColor,
                                        fontSize: 18 * settingsState.sizeFactor
                                      ),                                
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 32*settingsState.sizeFactor,
                                  child: IconButton(
                                    padding: EdgeInsets.all(0.0),
                                    onPressed: () {
                                      updateList(currentSelection, language, widget.currentLanguage);
                                    },
                                    icon: Icon( 
                                      language['selected']
                                          ? Icons.remove_circle
                                          : Icons.add_circle,
                                      color: widget.palette.optionButtonTextColor,
                                      size: 22*settingsState.sizeFactor,
                                    )
                                  ),
                                )                          
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    const Expanded(child: SizedBox(),),
                TextButton(
                    onPressed: () {
                      cancelSelections(widget.languages, _settingsState);
        
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      Helpers().translateText(widget.currentLanguage, "Cancel"),
                      style: TextStyle(
                        color: widget.palette.optionButtonTextColor,
                        fontSize: 16*settingsState.sizeFactor
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      setUpdatedLanguages(currentSelection, widget.currentLanguage);
                    },
                    child: Text(
                      Helpers().translateText(widget.currentLanguage, "Save"),
                      style: TextStyle(
                        color: widget.palette.optionButtonTextColor,
                        fontSize: 16*settingsState.sizeFactor
                      ),
                    )),                  
                  ],
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
   print("okay go to $url");
   if (!await launchUrl(url)) {
        throw Exception('Could not launch privacy policy');
    }
}
