import 'dart:math';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/welcome_user.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:vector_math/vector_math.dart' show radians;
// import 'dart:math';

// import 'package:vector_math/vector_math_64.dart';

class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({super.key});

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> with TickerProviderStateMixin{

  late bool isLoading = false;
  // late Map<String,dynamic> _userData = {};

  // late AnimationController _languageSelectedBorderController;
  // late Animation<double> _languageSelectedBorderAnimation;     


  // Future<void> getUserFromFirebase() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final Map<String,dynamic>? userData = await FirestoreMethods().getUserData(AuthService().currentUser!.uid);
  //   if (userData!.isNotEmpty) {
  //     setState(() {
  //       // _userData = userData;
  //       isLoading = false;
  //     });
  //   }

  // }  

  @override
  void initState() {
    super.initState();
    // getUserFromFirebase();
  }


  String getPrimaryLanguage(List<Map<String,dynamic>> dataList) {
    String res = "";
    if (dataList.where((element) => element['primary'] == true).toList().isNotEmpty) {
      res = dataList.firstWhere((element) => element['primary'] == true)['body'];
    } 
    return res;
  }

  String getPrimaryLanguageName(List<Map<String,dynamic>> dataList) {
    String res = "";
    if (dataList.where((element) => element['primary'] == true).toList().isNotEmpty) {
      res = dataList.firstWhere((element) => element['primary'] == true)['flag'];
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


  void processLanguageSelection(SettingsState settingsState) {
    List<Map<String, dynamic>>  allLanguagesList = getAllSelectedLanguages(settingsState.languageDataList);
    List<String> languages = []; 
    for (var element in allLanguagesList) {languages.add(element['flag']);}
    String currentLanguage = getPrimaryLanguageName(settingsState.languageDataList);
    

    FirestoreMethods().selectLanguage(AuthService().currentUser!.uid, currentLanguage, languages);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const WelcomeUser()
      )
    );
  }

  // void _runAnimations() {
  //   _languageSelectedBorderController.reset();
  //   _languageSelectedBorderController.forward();
  // }


  @override
  Widget build(BuildContext context) {

    final palette = context.watch<ColorPalette>();
    final double screenWidth = MediaQuery.of(context).size.width; 

    return isLoading ? const Center(child: CircularProgressIndicator(),) :    
    Consumer<SettingsState>(
      builder: (context, settingsState, child) {

        List<String> allLanguagesList = allLanguagesStringList(settingsState.languageDataList);

        return Scaffold(
          body: Container(
            width: double.infinity,
            // color: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "screen_background"),
            color : palette.screenBackgroundColor,
            child: Column(
              children: [
                const Expanded(flex: 3, child: SizedBox()),

                // getAllSelectedLanguages(settingsState.languageDataList).isEmpty ? SizedBox() :
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: allLanguagesList.isNotEmpty ? 1.0 : 0.0,
                  child: DropdownMenu<String>(
                    width: screenWidth*0.5,
                    label: const Text(
                      "Primary Language",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white
                    ),
                    initialSelection: getPrimaryLanguage(settingsState.languageDataList),
                    onSelected: (value) {
                      changePrimaryLanguage(settingsState, value!);
                    },
                    inputDecorationTheme: InputDecorationTheme(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      constraints: BoxConstraints.tight(const 
                      Size.fromHeight(60)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),                                    
                    dropdownMenuEntries: allLanguagesList.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                            
                        value: value, 
                        label: value,                                       
                      );
                    }).toList(),
                  ),
                ),

                const Expanded(flex: 1, child: SizedBox()),

                // allLanguagesList.isEmpty ? SizedBox() :
                
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: allLanguagesList.isNotEmpty ? 1.0 : 0.0 ,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(12.0,2.0,12.0,2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Select all languages you would play with",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                ),                
                const Expanded(flex: 1, child: SizedBox()),

                SizedBox(
                  width: double.infinity,
                  height: screenWidth,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      for (int i=0; i<settingsState.languageDataList .length; i++)
                        
                        LanguageButton(
                          angle:((360/settingsState.languageDataList.length)*i) ,
                          size: screenWidth,
                          langData: settingsState.languageDataList[i],
                          settingsState: settingsState,
                        ),

                                
                    ],
                  ),
                ),


                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: allLanguagesList.isNotEmpty ? 1.0 : 0.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          processLanguageSelection(settingsState);
                        },
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "option_button_bg"), //olor.fromARGB(255, 248, 175, 175) ,
                          // foregroundColor: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "option_button_text"),
                          backgroundColor: palette.optionButtonBgColor , 
                          foregroundColor: palette.optionButtonTextColor,
                          shadowColor: const Color.fromRGBO(123, 123, 123, 0.7),
                          shape:  RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            side: BorderSide(
                              // color: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "option_button_bg"),
                              color: palette.optionButtonBgColor,
                              width: 1,
                              style: BorderStyle.solid
                            ), 
                          ),                            
                        ),
                        child: const Text("Proceed"),
                      ),
                    
                    ),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox()),                                                                             
              ],
            )
          )
        );
      },
    );
  }
}




bool isSelection(dataList) {
  bool res = false;
  for (Map<String,dynamic> item in dataList) {
    if (item['selected']) {
      res = true;
    }
  }
  return res;
}

void updatePrimarySelection(SettingsState settingsState, ) {
  List<Map<String,dynamic>> dataList = settingsState.languageDataList;
  List<Map<String,dynamic>> selected = dataList.where((element) => element['selected'] == true).toList();
  List<Map<String,dynamic>> primary = dataList.where((element) => element['primary'] == true).toList();
  List<Map<String,dynamic>> newList  = [];
  if (selected.isNotEmpty) {
    if (primary.isEmpty) {
      for (Map<String,dynamic> item in dataList) {
        if (item['body'] == selected[0]['body']) {
          newList.add({'primary': true, 'selected': true, 'body': selected[0]['body'], 'flag':selected[0]['flag'] , 'url': selected[0]['url']});
        } else {
          newList.add(item);
        }
      }
    } else {
      newList = dataList;
    }
  } else {
    newList = dataList;
  }
  settingsState.setLanguageDataList(newList);
}


void selectLanguage(SettingsState settingsState, Map<String,dynamic> selectedItem, AnimationState animationState) {
  List<Map<String,dynamic>> newList = [];
  String currentSelection = "";
  List<String> currentList = settingsState.selectedLanguagesList;
  for (Map<String,dynamic> item in settingsState.languageDataList) {
    if (item['body'] == selectedItem['body']) {
      if (selectedItem['selected'] == true) {
        // if (currentList.length > 1) {
          // if the item you're iterating through is already selected, then unselect it
          newList.add({'primary': false, 'selected': false, 'body': selectedItem['body'], 'flag':selectedItem['flag'] , 'url': selectedItem['url']},);
          currentList.removeWhere((element) => element == selectedItem['body']);
        // } else {
        //   newList.add({'primary': selectedItem['primary'], 'selected': selectedItem['selected'], 'body': selectedItem['body'], 'flag':selectedItem['flag'] , 'url': selectedItem['url']},);
        //   // currentList.removeWhere((element) => element == selectedItem['body']);          
        // }
      } else if (selectedItem['selected'] == false) {
        // if the item  you're iterating through has not been selected but is also not the first to be selected, then select it but not as a primary
        if (isSelection(settingsState.languageDataList)) {
          newList.add({'primary': false, 'selected': true, 'body': selectedItem['body'], 'flag':selectedItem['flag'] , 'url': selectedItem['url']},);
          currentList.add(selectedItem['body']);
          currentSelection = selectedItem['body'];
          
          
        // if the item  you're iterating through has not been selected AND there are no selected items yet, make this a primary as well
        } else {
          newList.add({'primary': true, 'selected': true, 'body': selectedItem['body'], 'flag':selectedItem['flag'] , 'url': selectedItem['url']},);
          currentList.add(selectedItem['body']);
          currentSelection = selectedItem['body'];
        }
        
      }
    } else {
      newList.add(item);
    }
  }
  settingsState.setLanguageDataList(newList);
  settingsState.setSelectedLanguagesList(currentList);
  settingsState.setCurrentLanguageSelection(currentSelection);
}  


class LanguageButton extends StatefulWidget {
  final double angle;
  final double size;
  final Map<String,dynamic> langData; 
  final SettingsState settingsState;

  const LanguageButton({
    super.key,
    required this.angle,
    required this.size,
    required this.langData,
    required this.settingsState
  });

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> with SingleTickerProviderStateMixin {
  
  late AnimationState _animationState; 
  late AnimationController _languageSelectedController;
  late Animation<double> _languageSelectedAnimation;


  late double spreadFactor;
  late double rad;

  late bool pressed = false;


  @override
  void initState() {
    super.initState();
    initializeAnimations();
    _animationState = Provider.of<AnimationState>(context, listen: false);
    _languageSelectedController.addListener(_animationListener);
    spreadFactor = widget.size*0.33;
    rad = radians(widget.angle);    

  }

  void initializeAnimations() {
    _languageSelectedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500)
    );

    final List<TweenSequenceItem<double>> selectLanguageSequence = [

      TweenSequenceItem<double>(tween: Tween(begin: 0.0, end: 1.0), weight: 1.0),
    ];

    _languageSelectedAnimation = TweenSequence<double>(
      selectLanguageSequence
    ).animate(_languageSelectedController);
    widget.langData['selected'] ? _languageSelectedController.forward() : _languageSelectedController.reset(); 
  }


  void _animationListener() {
    if (_languageSelectedController.status == AnimationStatus.completed) {
    }    
  }


  @override
  void dispose() {
    _languageSelectedController.dispose();
    super.dispose();
  }


  
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsState>(
      builder: (context,settingsState, child) {
        return Transform(
          transform: Matrix4.identity()..translate(
            (spreadFactor) * cos(rad), 
            (spreadFactor) * sin(rad)        
          ),
        
        
          child: GestureDetector(
            onTap: (){ 
              if (widget.langData['selected']) {
                if (settingsState.selectedLanguagesList.length > 1) {
                  selectLanguage(settingsState,widget.langData,_animationState);
                  updatePrimarySelection(settingsState);                  
                  _languageSelectedController.reverse();
                }
              } else {
                selectLanguage(settingsState,widget.langData,_animationState);
                updatePrimarySelection(settingsState);                
                _languageSelectedController.forward();
              }
            },
            child: AnimatedBuilder(
              animation: _languageSelectedAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
        
        
                    Container(
                      width:  90 ,
                      height: 90 ,
                      decoration: BoxDecoration(
                        // color: Colors.green,
                        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          width: 3 ,
                          color: Color.fromRGBO(255, 255, 255, _languageSelectedAnimation.value),
                          // color: widget.langData['selected'] ? Color.fromRGBO(255, 255, 255, _languageSelectedAnimation.value) :  Color.fromRGBO(255, 255, 255, _languageSelectedAnimation.value) 
                        ),
                      ),
                    ),
                
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        // child: Text(body),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                          image: DecorationImage(
                            opacity: widget.langData['selected'] ? 1.0 : 0.8,
                            image: NetworkImage(widget.langData['url']), 
                          ),
                        ),
                      ),
                    ),                   
                  ]
                );
              },
            )
          ),
        
        );
      },
    );
  }
}
