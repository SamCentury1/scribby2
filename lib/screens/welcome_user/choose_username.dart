// import 'dart:ffi';

import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
// import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/welcome_user.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
// import 'package:vector_math/vector_math.dart' show radians, Vector3;
// import 'dart:math';

class ChooseUsername extends StatefulWidget {
  const ChooseUsername({super.key});

  @override
  State<ChooseUsername> createState() => _ChooseUsernameState();
}

class _ChooseUsernameState extends State<ChooseUsername> {

  late bool isLoading = false;
  late bool languageSelected = false;
  late TextEditingController _userNameController;
  // late Map<String,dynamic> _userData = {};

  late List<String> forbiddenNames = [
    "player", "user", "username",
  ];







  // Future<void> getUserFromFirebase() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final Map<String,dynamic>? userData = await FirestoreMethods().getUserData(AuthService().currentUser!.uid);
  //   if (userData!.isNotEmpty) {
  //     setState(() {
  //       _userData = userData;
  //       isLoading = false;
  //     });
  //   }

  // }


  @override
  void initState() {
    super.initState();
    // getUserFromFirebase();
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

    // final settings = context.watch<SettingsController>();
    // final palette = context.watch<Palette>();
    // final double screenWidth = MediaQuery.of(context).size.width;
    // final lightPalette = context.watch<LightPalette>();
    // final darkPalette = context.watch<DarkPalette>();
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);

    return isLoading ? const Center(child: CircularProgressIndicator(),) :    
    Consumer<SettingsState>(
      builder: (context, settingsState, child) {
        // List<String> allLanguagesList = allLanguagesStringList(settingsState.languageDataList);

        return Scaffold(
          // appBar: AppBar(
          //   title: Text('Settings'),
          //   backgroundColor: _userData['parameters']['darkMode'] ? Colors.black : Colors.grey,
          // ),
          
          body: Container(
            // color: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "screen_background"),
            color: palette.screenBackgroundColor,
            // child: !languageSelected ?  
            

            
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
              
                  const Expanded(flex: 2, child: SizedBox()),
              
                  Text(
                    // "Welcome!",
                    Helpers().translateWelcomeText(
                      getPrimaryLanguage(settingsState.languageDataList), 
                      "Welcome!"
                    ),                  
                    style: TextStyle(
                      fontSize: 32,
                      // color: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "tile_bg"),
                      color: palette.textColor2,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      Helpers().translateWelcomeText(
                        getPrimaryLanguage(settingsState.languageDataList), 
                        "Pick an original username"
                      ),                  
                          
                      style: TextStyle(
                        fontSize: 22,
                        // color: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "tile_bg"),
                        color: palette.textColor2
                      ),
                    ),
                  ),            
                  Consumer<SettingsController>(
                    builder: (context, settings, child) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16.0,8.0,16.0,8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 80,
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
                                          borderRadius: BorderRadius.circular(25.0),
                                        ),
                                        labelStyle: TextStyle(color: palette.textColor2, fontSize: 12),
                                        labelText: Helpers().translateWelcomeText(
                                          getPrimaryLanguage(settingsState.languageDataList), "Username"),
                                      ),
                                      style: TextStyle(
                                        fontSize: 18* settingsState.sizeFactor,
                                        // color: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "tile_bg"),
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
                  ElevatedButton(
                    onPressed: () {
                      String language = getPrimaryLanguage(settingsState.languageDataList);
                      if (forbiddenNames.contains(_userNameController.text.toLowerCase())) {
                        Helpers().showBadNameDialog(
                          context,
                          Helpers().translateWelcomeText(language, "Hold On"),
                          Helpers().translateWelcomeText(language, "Pick something more original"),
                          Helpers().translateWelcomeText(language, "Okay"),
                          palette,                   
                          
                        );
                      } else if (Helpers().checkForBadWords(_userNameController.text.toLowerCase())) {
                        Helpers().showBadNameDialog(
                          context,
                          Helpers().translateWelcomeText(language, "Excuse me!"),
                          Helpers().translateWelcomeText(language, "Hey! No bad words!"),
                          Helpers().translateWelcomeText(language, "Okay"),
                          palette,       
                        );
                      } else if (_userNameController.text.toLowerCase() == "") {
                        Helpers().showBadNameDialog(
                          context,
                          Helpers().translateWelcomeText(language, "Hold On"),
                          Helpers().translateWelcomeText(language, "Pick something more original"),
                          Helpers().translateWelcomeText(language, "Okay"),
                          palette,      
                        );                        

                      } else if (_userNameController.text.toLowerCase().length  < 3) {
                        Helpers().showBadNameDialog(
                          context,
                          Helpers().translateWelcomeText(language, "Hold On"),
                          Helpers().translateWelcomeText(language, "Pick something more original"),
                          Helpers().translateWelcomeText(language, "Okay"),
                          palette,        
                        );                        

                      } else {
                        // settings.setUser(_userNameController.text.toLowerCase());
                        AuthService().updateUsername(AuthService().currentUser!.uid, _userNameController.text.toLowerCase());
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const WelcomeUser()
                          )
                        );                    
                      }
                      
                      
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "option_button_bg"),
                      // foregroundColor: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "option_button_text"),
                      backgroundColor: palette.optionButtonBgColor,
                      foregroundColor: palette.optionButtonTextColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                    ),
                    child: Text(
                      Helpers().translateWelcomeText(
                        getPrimaryLanguage(settingsState.languageDataList), 
                        "Save"
                      ),                     
                      
                    ),
                  ),
                  const Expanded(flex: 3, child: SizedBox()),             
                ],
              ),
            ),            

          )
        );
      },
    );

  }
}



// Future<void> _showBadNameDialog(BuildContext context, String textBody,) async {
  
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false, // user must tap button!
//     builder: (BuildContext context) {

//       return Theme(
//         data: ThemeData.dark().copyWith(
//           // Set the background color of the AlertDialog
//           dialogBackgroundColor: Colors.grey[800],
//           // Set the text color of the AlertDialog
//           textTheme: const TextTheme().copyWith(
//             bodyMedium: const TextStyle(color: Colors.white),
//           ),
//         ),      
//         child: AlertDialog(
//           title: const Text('Aye hold up'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(
//                   textBody,
//                   style: const TextStyle(
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Okay'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         )
//       );
//     },
//   );
// }


Widget languageButton(String body) {
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 60,
            color: Colors.amber,
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


