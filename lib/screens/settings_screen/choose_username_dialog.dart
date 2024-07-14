import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class ChooseUsernameDialog extends StatefulWidget {
  const ChooseUsernameDialog({super.key});

  @override
  State<ChooseUsernameDialog> createState() => _ChooseUsernameDialogState();
}

class _ChooseUsernameDialogState extends State<ChooseUsernameDialog> {

  late TextEditingController _userNameController;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
  }  



  @override
  Widget build(BuildContext context) {

    late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen:false);
    late SettingsState settingsState = Provider.of<SettingsState>(context, listen:false);
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen:false);
    late double ts = gamePlayState.tileSize;

    late String currentLanguage = gamePlayState.currentLanguage;


      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(ts*0.25)
          )
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(ts*0.25)),
            color: palette.modalBgColor,
          ),                      
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                ts*0.05,
                ts*0.20,
                ts*0.05,
                ts*0.20,
            
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:ts*0.15),
                    child: Center(
                      child: Text(
                        Helpers().translateText(currentLanguage, "Choose new Username",settingsState),
                        style: TextStyle(
                          color: palette.modalTextColor,
                          fontSize: (ts*0.35)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ts*0.05,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ts*0.15),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Helpers().translateText(currentLanguage, "No bad words",settingsState),
                            style: TextStyle(
                              color: palette.modalTextColor
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            Helpers().translateText(currentLanguage, "No unoriginal names ('user', 'player', etc.)",settingsState),
                            style: TextStyle(
                              color: palette.modalTextColor
                            ),
                            textAlign: TextAlign.start,                                    
                          ),
                          Text(
                            Helpers().translateText(currentLanguage, "Minimum 3 characters",settingsState),
                            style: TextStyle(
                              color: palette.modalTextColor
                            ),
                            textAlign: TextAlign.start,                                    
                          ),
                          Text(
                            Helpers().translateText(currentLanguage, "Maximum 40 characters",settingsState),
                            style: TextStyle(
                              color: palette.modalTextColor
                            ),
                            textAlign: TextAlign.start,                                    
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(ts*0.25),
                    child: SizedBox(
                      // height: 30,
                      width: double.infinity,
                      child: TextField(
                        cursorColor: palette.modalTextColor,
                        style: TextStyle(
                          color: palette.modalTextColor,
                          decorationColor: Colors.transparent
                        ),
                                        
                        controller: _userNameController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(ts*0.25,),
                            borderSide: BorderSide(
                              color: palette.modalTextColor,
                            ),                                  
                          ),                                  
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:  palette.modalTextColor
                            )
                          ),
                          labelText: Helpers().translateText(currentLanguage,"Username",settingsState),
                          labelStyle: TextStyle(
                            color:palette.modalTextColor, //  palette.modalTextColor
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
                            // toggleUserNameEditView();
                          },
                          child: Text(
                            Helpers().translateText(currentLanguage, "Cancel",settingsState),
                            style: TextStyle(
                              fontSize: ts*0.3,
                              color: palette.modalTextColor
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
                            if (forbiddenNames.contains(_userNameController.text.toLowerCase())) {
                              Helpers().showUserNameSnackBar(
                                context,palette,ts,Helpers().translateText(currentLanguage, "Pick something more original",settingsState)
                              );
                            } else if (Helpers().checkForBadWords(_userNameController.text.toLowerCase())) {
                              Helpers().showUserNameSnackBar(
                                context,palette,ts,Helpers().translateText(currentLanguage, "Hey! No bad words!",settingsState)
                              );                                        
                            } else if (_userNameController.text.toLowerCase().length  < 3) {
                              Helpers().showUserNameSnackBar(
                                context,palette,ts,Helpers().translateText(currentLanguage, "Username must be at least 3 characters",settingsState)
                              );                                                         
                            } else if (_userNameController.text.toLowerCase().length  > 40) {
                              Helpers().showUserNameSnackBar(
                                context,palette,ts,Helpers().translateText(currentLanguage, "Username must be at most 40 characters",settingsState)
                              );
                            } else {
                              AuthService().updateUsername(AuthService().currentUser!.uid ,_userNameController.text.toString());
                              late Map<String,dynamic> newUserData = {...settingsState.userData,'username':_userNameController.text.toString()};
                              settingsState.updateUserData(newUserData);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    Helpers().translateText(currentLanguage, "username successfully updated",settingsState),
                                    style: TextStyle(
                                      color: palette.overlayText,
                                      fontSize: ts*0.3
                                    ),
                                  ),
                                  duration: const Duration(milliseconds: 3000),
                                )
                              );                                
                              Navigator.of(context).pop();
                              // toggleUserNameEditView();
                            }
                          },
                          child: Text(
                            Helpers().translateText(currentLanguage, "Save",settingsState),
                            style: TextStyle(
                              fontSize: ts*0.3,
                              color: palette.modalTextColor
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
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }  
}