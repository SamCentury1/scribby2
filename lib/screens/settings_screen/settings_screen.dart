import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool userNameEditView = false;
  late bool isLoading;
  // late Map<String,dynamic> _userData = {};
  late ColorPalette _palette;
  late TextEditingController _userNameController;

  @override
  void initState() {
    super.initState();
    getUserFromFirebase();
    _userNameController = TextEditingController();
    _palette = Provider.of<ColorPalette>(context, listen: false);
  }

  Future<void> getUserFromFirebase() async {
    setState(() {
      isLoading = true;
    });
    try {
      final SettingsState settingsState =
          Provider.of<SettingsState>(context, listen: false);
      final Map<String, dynamic> userData = await FirestoreMethods()
          .getUserData(AuthService().currentUser!.uid) as Map<String, dynamic>;
      if (userData.isNotEmpty) {
        settingsState.updateUserData(userData);
        _palette.getThemeColors(userData['parameters']['darkMode']);
        setState(() {
          // _userData = userData;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Future<void> toggleDarkTheme(ColorPalette palette, bool value) async {
  //   await FirestoreMethods().toggleDarkTheme(AuthService().currentUser!.uid, value);
  //   palette.getThemeColors(value);
  // }

  Future<void> updateParameter(
      String parameter, dynamic parameterData, ColorPalette palette) async {
    if (parameter == 'darkMode') {
      palette.getThemeColors(parameterData);
    }
    await FirestoreMethods().updateParameters(
        AuthService().currentUser!.uid, parameter, parameterData);
  }

  void updateSettingsState(List<dynamic> languages, String currentLanguage) {
    late SettingsState settingsState =
        Provider.of<SettingsState>(context, listen: false);
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Consumer<ColorPalette>(
            builder: (context, palette, child) {
              return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: palette.textColor2,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MenuScreen(),
                          ),
                        );
                      },
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(color: palette.textColor2),
                    ),
                    backgroundColor: palette.modalNavigationBarBgColor,
                  ),
                  body: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .doc("users/${AuthService().currentUser!.uid}")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        var document = snapshot.data;
                        String username = document?['username'];
                        var darkMode = document?['parameters']['darkMode'];
                        var soundOn = document?['parameters']['soundOn'];
                        var muted = document?['parameters']['muted'];
                        var currentLanguage =
                            document?['parameters']['currentLanguage'];
                        List<dynamic> languages =
                            document?['parameters']['languages'];

                        return Container(
                          color: palette.screenBackgroundColor,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Username",
                                style: TextStyle(
                                    fontSize: 22, color: _palette.textColor1),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 8.0, 16.0, 8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 80,
                                  child: Card(
                                    color: palette.optionButtonBgColor,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          26.0, 8.0, 26.0, 8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: !userNameEditView
                                            ? Row(
                                                children: [
                                                  Text(
                                                    Helpers().capitalizeName(
                                                        username),
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        color:
                                                            palette.textColor2),
                                                  ),
                                                  const Expanded(
                                                      flex: 1,
                                                      child: SizedBox()),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          userNameEditView =
                                                              true;
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit),
                                                      color:
                                                          palette.textColor2),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Center(
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.65,
                                                      child: TextField(
                                                        controller:
                                                            _userNameController,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText: 'Username',
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // Expanded(flex: 1, child: SizedBox()),
                                                  IconButton(
                                                      onPressed: () {
                                                        AuthService().updateUsername(
                                                            AuthService()
                                                                .currentUser!
                                                                .uid,
                                                            _userNameController
                                                                .text
                                                                .toString());
                                                        // settings.setUser(_userNameController.text.toString());
                                                        setState(() {
                                                          userNameEditView =
                                                              false;
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.save),
                                                      color: darkMode
                                                          ? Colors.grey[350]
                                                          : Colors.amber[600]),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Parameters",
                                style: TextStyle(
                                    fontSize: 22, color: _palette.textColor1),
                              ),
                              parameterCard(
                                palette,
                                "Color Theme",
                                () {
                                  // toggleDarkTheme(_palette,!darkMode);
                                  updateParameter(
                                      "darkMode", !darkMode, _palette);
                                },
                                [
                                  const Icon(Icons.nightlight),
                                  const Icon(Icons.sunny),
                                ],
                                darkMode,
                              ),
                              parameterCard(
                                palette,
                                "Muted",
                                () {
                                  updateParameter("muted", !muted, _palette);
                                },
                                [
                                  const Icon(Icons.volume_mute),
                                  const Icon(Icons.volume_up),
                                ],
                                muted,
                              ),
                              parameterCard(
                                palette,
                                "Sound",
                                () {
                                  updateParameter(
                                      "soundOn", !soundOn, _palette);
                                },
                                [
                                  const Icon(Icons.music_note),
                                  const Icon(Icons.music_off),
                                ],
                                soundOn,
                              ),
                              Text(
                                "Language",
                                style: TextStyle(
                                    fontSize: 22, color: _palette.textColor1),
                              ),
                              languageCard(
                                palette,
                                "Current",
                                currentLanguage,
                                languages,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 26.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            palette.optionButtonBgColor,
                                        foregroundColor:
                                            palette.optionButtonTextColor,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        )),
                                    child: const Text("Add / Remove Language"),
                                    onPressed: () {
                                      displayLanguagesDialog(context, palette,
                                          languages, currentLanguage);

                                      updateSettingsState(
                                          languages, currentLanguage);
                                      // print()
                                    },
                                  ),
                                ),
                              ),
                              const Expanded(flex: 1, child: SizedBox()),
                            ],
                          ),
                        );
                      }));
            },
          );
  }
}

Widget parameterCard(ColorPalette palette, String cardBody,
    VoidCallback onPressed, List<Icon> iconList, var value) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
    child: SizedBox(
      width: double.infinity,
      height: 80,
      child: Card(
        color: palette.optionButtonBgColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26.0, 8.0, 26.0, 8.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    cardBody,
                    style: TextStyle(fontSize: 22, color: palette.textColor2),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                  IconButton(
                      onPressed: onPressed,
                      icon: value ? iconList[0] : iconList[1],
                      color: value
                          ? const Color.fromARGB(255, 15, 214, 214)
                          : Colors.amber[600]),
                ],
              )),
        ),
      ),
    ),
  );
}

Widget languageCard(
    ColorPalette palette, String cardBody, var value, List<dynamic> languages) {
  Future<void> changeCurrentLanguage(dynamic newLanguage) async {
    await FirestoreMethods().updateParameters(
        AuthService().currentUser!.uid, "currentLanguage", newLanguage);
  }

  return Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
    child: SizedBox(
      width: double.infinity,
      height: 80,
      child: Card(
        color: palette.optionButtonBgColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26.0, 8.0, 26.0, 8.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    cardBody,
                    style: TextStyle(
                      fontSize: 22,
                      color: palette.optionButtonTextColor,
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
                            Helpers().capitalize(val),
                            style: TextStyle(
                              color: palette.textColor2,
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

Future<void> displayLanguagesDialog(BuildContext context, ColorPalette palette,
    List<dynamic> languages, String currentLanguage) async {
  return showDialog(
    context: context,
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
  late SettingsState _settingsState;

  @override
  void initState() {
    super.initState();
    _settingsState = Provider.of<SettingsState>(context, listen: false);

    getLatestSelection(widget.languages, _settingsState);
  }

  void getLatestSelection(
      List<dynamic> languages, SettingsState settingsState) {
    late List<Map<String, dynamic>> selected = settingsState.languageDataList
        .where((element) => element['selected'] == true)
        .toList();
    late List<Map<String, dynamic>> unSelected = settingsState.languageDataList
        .where((element) => element['selected'] == false)
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

  void updateList(List<Map<String, dynamic>> languages,
      Map<String, dynamic> targetObject, String currentLanguage) {
    if (targetObject['flag'] == currentLanguage) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Can't remove the current language!"),
        duration: Duration(milliseconds: 1000),
      ));
    } else {
      late String result = "";
      for (int i = 0; i < languages.length; i++) {
        late Map<String, dynamic> languageObject = languages[i];
        if (languageObject["flag"] == targetObject["flag"]) {
          if (targetObject['selected'] == true) {
            languageObject.update("change", (value) => "removed");
            languageObject.update("selected", (value) => false);
            result = "Removed";
          } else {
            languageObject.update("change", (value) => "added");
            languageObject.update("selected", (value) => true);
            result = "Added";
          }
        }
      }
      setState(() {
        currentSelection = languages;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$result ${targetObject['flag']} !'),
        duration: const Duration(milliseconds: 1000),
      ));
    }
  }

  void setUpdatedLanguages(
      List<Map<String, dynamic>> currentSelection, String currentLanguage) {
    List<String> newLanguages = [];

    for (Map<String, dynamic> languageObject in currentSelection) {
      if (languageObject['selected'] == true) {
        newLanguages.add(languageObject['flag']);
      }
    }

    FirestoreMethods().updateParameters(
        AuthService().currentUser!.uid, "languages", newLanguages);
    Navigator.of(context).pop();

    debugPrint("current language $newLanguages");
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
    return AlertDialog(
      title: Text(
        "Add / Remove Language",
        style: TextStyle(color: widget.palette.optionButtonTextColor),
      ),
      backgroundColor: widget.palette
          .modalNavigationBarBgColor, //widget.palette.optionButtonBgColor,
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height *0.6,
        child: ListView.builder(
          itemCount: currentSelection.length,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> language = currentSelection[index];
            return Card(
              color: getLanguageColor(language["change"],
                  language["originalSelection"], widget.palette),
              child: ListTile(
                  leading: Container(
                    // child: Text(body),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50.0)),
                      image: DecorationImage(
                        // opacity: widget.langData['selected'] ? 1.0 : 0.8,
                        image: NetworkImage(language['url']),
                      ),
                    ),
                  ),
                  title: Text(
                    language['body'],
                    style:
                        TextStyle(color: widget.palette.optionButtonTextColor),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        updateList(
                            currentSelection, language, widget.currentLanguage);
                        // updateList(settingsState.languageDataList, language);
                      },
                      icon: Icon(
                        language['selected']
                            ? Icons.remove_circle
                            : Icons.add_circle,
                        color: widget.palette.optionButtonTextColor,
                        size: 30,
                      ))),
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: widget.palette.optionButtonTextColor),
            )),
        TextButton(
            onPressed: () {
              setUpdatedLanguages(currentSelection, widget.currentLanguage);
            },
            child: Text(
              "Save",
              style: TextStyle(color: widget.palette.optionButtonTextColor),
            )),
      ],
    );
  }
}
