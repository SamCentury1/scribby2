// import 'dart:ffi';

import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
// import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
// import 'package:vector_math/vector_math.dart' show radians, Vector3;
// import 'dart:math';

class WelcomeUser extends StatefulWidget {
  const WelcomeUser({super.key});

  @override
  State<WelcomeUser> createState() => _WelcomeUserState();
}

class _WelcomeUserState extends State<WelcomeUser> {

  late bool isLoading = false;
  late bool languageSelected = false;
  late TextEditingController _userNameController;
  // late Map<String,dynamic> _userData = {};

  late List<String> forbiddenNames = [
    "player", "user", "username",
  ];




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
            

            
            child: Column(
              children: <Widget>[

                const Expanded(flex: 2, child: SizedBox()),

                Text(
                  "Welcome!",
                  style: TextStyle(
                    fontSize: 32,
                    // color: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "tile_bg"),
                    color: palette.tileBgColor,
                  ),
                ),
                const SizedBox(height: 20,),
                Text(
                  "Pick an original username",
                  style: TextStyle(
                    fontSize: 22,
                    // color: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "tile_bg"),
                    color: palette.tileBgColor
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
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Username',
                                    ),
                                    style: TextStyle(
                                      fontSize: 18,
                                      // color: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "tile_bg"),
                                      color: palette.tileBgColor
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
                    
                    if (forbiddenNames.contains(_userNameController.text.toLowerCase())) {
                      _showBadNameDialog(context, "pick something more original");
                    } else if (checkForBadWords(_userNameController.text.toLowerCase())) {
                      _showBadNameDialog(context, "hey! no bad words!");
                    } else {
                      // settings.setUser(_userNameController.text.toLowerCase());
                      AuthService().updateUsername(AuthService().currentUser!.uid, _userNameController.text.toLowerCase());
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MenuScreen()
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
                  child: const Text("Save User"),
                ),
                const Expanded(flex: 3, child: SizedBox()),             
              ],
            ),            

          )
        );
      },
    );

  }
}



Future<void> _showBadNameDialog(BuildContext context, String textBody,) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {

      return Theme(
        data: ThemeData.dark().copyWith(
          // Set the background color of the AlertDialog
          dialogBackgroundColor: Colors.grey[800],
          // Set the text color of the AlertDialog
          textTheme: const TextTheme().copyWith(
            bodyMedium: const TextStyle(color: Colors.white),
          ),
        ),      
        child: AlertDialog(
          title: const Text('Aye hold up'),
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
              child: const Text('Okay'),
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




// Widget _buildButton(double angle, String body, double size,  String flag) {

//   final List<Map<String,dynamic>> imageUrls = [
//     {'flag':'french', 'url': 'https://cdn-icons-png.flaticon.com/512/197/197560.png'},
//     {'flag':'english' , 'url': 'https://cdn-icons-png.flaticon.com/512/197/197374.png'},
//     {'flag':'spanish' , 'url': 'https://cdn-icons-png.flaticon.com/512/197/197593.png'},
//     {'flag':'portuguese' , 'url': 'https://cdn-icons-png.flaticon.com/512/1795/1795606.png'},
//     {'flag':'greek' , 'url': 'https://cdn-icons-png.flaticon.com/512/5921/5921998.png'},
//     {'flag':'german' , 'url': 'https://cdn-icons-png.flaticon.com/512/4855/4855806.png'},
//     {'flag':'dutch' , 'url': 'https://cdn-icons-png.flaticon.com/512/197/197441.png'},
//     {'flag':'italian' , 'url': 'https://cdn-icons-png.flaticon.com/512/9906/9906483.png'},
//   ];

//   final Map<String,dynamic> imageObject = imageUrls.firstWhere((element) => element['flag'] == flag);

//   final double spreadFactor = size*0.36;
//   final double rad = radians(angle);
//   return Transform(
//     transform: Matrix4.identity()..translate(
//       (spreadFactor) * cos(rad), 
//       (spreadFactor) * sin(rad)        
//     ),


//     child: GestureDetector(
//       onTap: (){ print(body);},
//       child: Stack(
//         children: [
//           Container(
//             // color: Colors.green,
//             width: 90,
//             height: 90,
//           ),

//           Positioned(
//             left: 10,
//             child: Container(
//               // child: Text(body),
//               width: 75,
//               height: 75,
//               decoration: BoxDecoration(
//                 color: Colors.amber,
//                 borderRadius: BorderRadius.all(Radius.circular(50.0)),
//                 image: DecorationImage(
//                   image: NetworkImage(imageObject['url']), 
//                 )

//               ),
//             ),
//           ),    
//           Positioned(
//             bottom:-2,
//             child: Container(
//               width: 90,
//               child: Text(
//                 body,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             )
//           ),
                        
//         ]
//       )
//     ),

//   );
// }


// Widget _buildButton(double angle, double size, Map<String,dynamic> langData, SettingsState settingsState) {



//   final double spreadFactor = size*0.33;
//   final double rad = radians(angle);

//   bool isSelection(dataList) {
//     bool res = false;
//     for (Map<String,dynamic> item in dataList) {
//       if (item['selected']) {
//         res = true;
//       }
//     }
//     return res;
//   }

//   void updatePrimarySelection(SettingsState settingsState, ) {
//     List<Map<String,dynamic>> dataList = settingsState.languageDataList;
//     List<Map<String,dynamic>> selected = dataList.where((element) => element['selected'] == true).toList();
//     List<Map<String,dynamic>> primary = dataList.where((element) => element['primary'] == true).toList();
//     List<Map<String,dynamic>> newList  = [];
//     if (selected.isNotEmpty) {
//       if (primary.isEmpty) {
//         print("missing a primary!");
//         for (Map<String,dynamic> item in dataList) {
//           if (item['body'] == selected[0]['body']) {
//             newList.add({'primary': true, 'selected': true, 'body': selected[0]['body'], 'flag':selected[0]['flag'] , 'url': selected[0]['url']});
//           } else {
//             newList.add(item);
//           }
//         }
//       } else {
//         newList = dataList;
//       }
//     } else {
//       newList = dataList;
//     }
//     print(newList);
//     settingsState.setLanguageDataList(newList);
//   }


//   void selectLanguage(SettingsState settingsState, Map<String,dynamic> selectedItem) {
//     List<Map<String,dynamic>> newList = [];
//     List<String> currentList = settingsState.selectedLanguagesList;
//     for (Map<String,dynamic> item in settingsState.languageDataList) {
//       if (item['body'] == selectedItem['body']) {
//         if (selectedItem['selected'] == true) {
//           // if the item you're iterating through is already selected, then unselect it
//           newList.add({'primary': false, 'selected': false, 'body': selectedItem['body'], 'flag':selectedItem['flag'] , 'url': selectedItem['url']},);
//           currentList.removeWhere((element) => element == selectedItem['body']);
//         } else if (selectedItem['selected'] == false) {
//           // if the item  you're iterating through has not been selected but is also not the first to be selected, then select it but not as a primary
//           if (isSelection(settingsState.languageDataList)) {
//             newList.add({'primary': false, 'selected': true, 'body': selectedItem['body'], 'flag':selectedItem['flag'] , 'url': selectedItem['url']},);
//             currentList.add(selectedItem['body']);
//           // if the item  you're iterating through has not been selected AND there are no selected items yet, make this a primary as well
//           } else {
//             newList.add({'primary': true, 'selected': true, 'body': selectedItem['body'], 'flag':selectedItem['flag'] , 'url': selectedItem['url']},);
//             currentList.add(selectedItem['body']);

//           }
//         }
//       } else {
//         newList.add(item);
//       }
//     }
//     settingsState.setLanguageDataList(newList);
//     settingsState.setSelectedLanguagesList(currentList);
//   }  

//   return Transform(
//     transform: Matrix4.identity()..translate(
//       (spreadFactor) * cos(rad), 
//       (spreadFactor) * sin(rad)        
//     ),


//     child: GestureDetector(
//       onTap: (){ 
//         selectLanguage(settingsState,langData);
//         updatePrimarySelection(settingsState);
//         // selectLanguage(settings);
//         // print(langData['body']);

//         print(settingsState.selectedLanguagesList);

//       },
//       child: Stack(
//         children: [
//           Container(
//             width: 90,
//             height:90,
//             decoration: BoxDecoration(
//               // color: Colors.green,
//               borderRadius: BorderRadius.all(Radius.circular(50.0)),
//               border: Border.all(
//                 width: 3,
//                 color: langData['selected'] ? Colors.white: Colors.transparent,
//               ),
//             ),
//           ),

//           Positioned(
//             left: 10,
//             top: 10,
//             child: Container(
//               // child: Text(body),
//               width: 70,
//               height: 70,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(50.0)),
//                 image: DecorationImage(
//                   opacity: langData['selected'] ? 1.0 : 0.8,
//                   image: NetworkImage(langData['url']), 
//                 ),
//               ),
//             ),
//           ),    
//           // Positioned(
//           //   bottom:-2,
//           //   child: Container(
//           //     width: 100,
//           //     child: Text(
//           //       langData['body'],
//           //       style: TextStyle(
//           //         fontSize: 16,
//           //         color: Colors.white
//           //       ),
//           //       textAlign: TextAlign.center,
//           //     ),
//           //   )
//           // ),
                        
//         ]
//       )
//     ),

//   );
// }
