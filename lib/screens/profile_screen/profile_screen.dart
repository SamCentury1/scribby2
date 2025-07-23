import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/background_painter.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  File? _avatarImage;
  // late String _displayName = "";
  // late String _email = "";
  late String _username = "";
  late String _rank = "";
  late String _selectedLanguage = "";
  late String _selectedTheme = "";
  late bool _soundOn = false;

  final List<Map<String,dynamic>> _languages = [
    {'code':'en','label':'English'}, 
    {'code':'es','label':'Espanol'}, 
    {'code':'fr','label':'Francais'}, 
    {'code':'de','label':'Deutsch'}
  ]; // ['english', 'Español', 'Français', 'Deutsch'];
  final List<String> _colorThemes = ['default', 'light', 'dark', 'nature','techno','beach',]; // ['english', 'Español', 'Français', 'Deutsch'];

  Future<void> _pickImage(SettingsController settings) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final pickedFilePath = pickedFile?.path;

    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    // await userData.update("photoUrl", (v) => pickedFilePath);
    userData["photoUrl"] = pickedFilePath;
    
    if (pickedFile != null ) {
      setState(() {
        _avatarImage = File(pickedFile.path);
        settings.setUserData(userData);
      });
    }
  }

  Future<void> _pickLanguage(SettingsController settings, String? value) async {

    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    
    setState(() {
      userData["language"] = value!;
      _selectedLanguage = value!;
      settings.setUserData(userData);
    });    
  }



  Future<void> _toggleSound(SettingsController settings, bool value) async {

    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    
    setState(() {
      // userData["soundOn"] = value;
      userData["parameters"].update("soundOn", (v) => value);
      settings.setUserData(userData);
      FirestoreMethods().updateParameters(settings,"soundOn",value);
      _soundOn = value;
      settings.toggleSoundOn();
      
    });    
  }

  Future<void> _pickColorTheme(SettingsController settings, ColorPalette palette, String? value) async {

    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    
    setState(() {
      // userData["colorTheme"] = value!;
      _selectedTheme = value!;
      settings.setTheme(value);
      // settings.setUserData({...userData, "parameters.theme": value});
      userData["parameters"].update("theme", (v) => value);
      settings.setUserData(userData);
      FirestoreMethods().updateParameters(settings,"theme",value);
      palette.getThemeColors(_selectedTheme);
    });    
  }


  @override
  void dispose() {
    super.dispose();
  }
  
    
  @override
  Widget build(BuildContext context) {

    
    return Consumer<SettingsController>(
      builder: (context,settings,child) {

        // ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);



        late double scalor = 1.0;
        final double menuPositionTop = MediaQuery.of(context).padding.top-5;

        final Map<dynamic,dynamic> userData = settings.userData.value as Map<dynamic,dynamic>;

        print("user Data: $userData");
        // _displayName = userData["displayName"];
        // _email = userData["email"];
        _username = userData["username"];
        _rank = userData["rank"] ?? "1_1";
        print("rank: ${_rank}");
        _selectedLanguage = userData["language"]??"en";
        _soundOn = settings.soundsOn.value;
        
        _selectedTheme = userData["parameters"]["theme"]??"default";
        
        Map<dynamic,dynamic> rankObject = settings.rankData.value.firstWhere((e)=>e["key"]==_rank,orElse: ()=>{});
        int rankIndex = rankObject["rank"];
        int _level = rankObject["level"];
        if (userData["photoUrl"] != null && File(userData["photoUrl"]).existsSync()) {
          _avatarImage = File(userData["photoUrl"]);
        }        

        


        return PopScope(
          canPop: true,
          child: Consumer<ColorPalette>(
            builder: (context,palette,child) {
              Map<String,Map<String,Color>> colorsDictionary = palette.colorsDictionary;
              return SizedBox(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,            
                child: SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                        // top: 1,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,//-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
                          child: CustomPaint(
                            painter: GradientBackground(settings: settings, palette: palette, decorationData: []),
                          ),
                        ),
                      ),             
                      Scaffold(
                        backgroundColor: Colors.transparent,
                        onDrawerChanged: (var details) {},
                        appBar: AppBar(
                          backgroundColor: const Color.fromARGB(0, 49, 49, 49),
                          title: Text("Profile", style: TextStyle(color: palette.text2, fontSize: 28*scalor),),
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back, color: palette.text2),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ),
              
                        body: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                
                                    SizedBox(height: 60 * scalor,),
                                    // Avatar
                                    Align(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: () => _pickImage(settings),
                                        child: CircleAvatar(
                                          radius: 50*scalor,
                                          backgroundColor: const Color.fromARGB(47, 255, 255, 255),
                                          foregroundColor: const Color.fromARGB(214, 243, 243, 243),
                                          backgroundImage: _avatarImage != null ? FileImage(_avatarImage!) : null,
                                          child: _avatarImage == null
                                              ? const Icon(Icons.camera_alt, size: 40)
                                              : null,
                                        ),
                                      ),
                                    ),
                                    // _usernameTile(scalor: scalor,settings: settings),
                                    // UsernameCard(),
                                    ValueListenableBuilder(
                                      valueListenable: settings.userData,
                                      builder: (context, value, child) {
                                        final userData = value as Map<String, dynamic>;
                                        final username = userData["username"] ?? "Unknown";
              
                                        return UsernameCard(username: username,palette: palette,);
                                      },
                                    ),
                                    // Helpers().displayRankTitle(_rank, _selectedLanguage)
                                    _rankCard(rank: "Level $_level ${Helpers().translateRankTitle(rankIndex, _selectedLanguage)}", scalor: scalor,palette: palette),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12.0*scalor),
                                      child: Divider(),
                                    ),
                                    const SizedBox(height: 20),
                                
                                    // Display Name (non-editable)
                                    // _infoTile(icon: Icons.person, value: _displayName, scalor: scalor, palette:palette),
                                
                                    // Email (non-editable)
                                    // _infoTile(icon: Icons.email, value: _email, scalor: scalor, palette:palette),
                                
                                    // Username (editable)
                                    // _infoTile(label: 'Username', value: _username, scalor: scalor),                              
                                
                                    // Language (dropdown)
                                
                                    Padding(
                                      padding: EdgeInsets.all(8.0*scalor),
                                      child: Container(
                                        height: 60 * scalor,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
                                          color: palette.widget1,
                                          boxShadow: [
                                            BoxShadow(
                                              color: palette.widgetShadow1,
                                              spreadRadius: 2.0 * scalor,
                                              blurRadius: 15.0 * scalor,
                                              offset: Offset(0.0, 5.0 * scalor),
                                            )
                                          ]                                          
                                        ),
                                
                                        child: ListTile(
                                          leading: Icon(Icons.language,color: palette.widgetText1),
                                          title: DropdownButtonFormField<String>(
                                            value: _selectedLanguage,
                                            alignment: AlignmentDirectional.centerStart,

                                            dropdownColor: palette.widget1,
                                            decoration: InputDecoration(
                                              border: null,
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: palette.widgetText1)
                                              )
                                            ),                                            
                                            items: _languages.map((lang) {
                                              return DropdownMenuItem(
                                                value: lang["code"] as String, 
                                                child: Text(
                                                  lang["label"] as String,
                                                  style: TextStyle(color: palette.widgetText1),
                                                )
                                              );
                                            }).toList(),
                                            onChanged: (value) => _pickLanguage(settings,value),
                                          ),
                                        ),                                  
                                
                                      ),
                                    ),
              
                                    Padding(
                                      padding: EdgeInsets.all(8.0*scalor),
                                      child: Container(
                                        height: 60 * scalor,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
                                          color: palette.widget1,
                                          boxShadow: [
                                            BoxShadow(
                                              color: palette.widgetShadow1,
                                              spreadRadius: 2.0 * scalor,
                                              blurRadius: 15.0 * scalor,
                                              offset: Offset(0.0, 5.0 * scalor),
                                            )
                                          ]                                          
                                        ),
                                        child: ListTile(
                                          leading: Icon(Icons.volume_up,color: palette.widgetText1),
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              settings.soundsOn.value
                                                ? Text("Sound On", style: TextStyle(fontSize: 18 * scalor, color: palette.widgetText1),)
                                                : Text("Sound Off", style: TextStyle(fontSize: 18 * scalor, color: palette.widgetText1),),
              
                                                Transform.scale(
                                                  scale: 0.8 * scalor,
                                                  child: Switch(
                                                    // activeColor: Colors.blue,
                                                    activeColor: palette.widgetParticulars1,
                                                    materialTapTargetSize:  MaterialTapTargetSize.shrinkWrap,
                                                    value: _soundOn, 
                                                    onChanged: (value) => _toggleSound(settings, value)
                                                  ),
                                                )
                                            ],
                                          ) 
              
                                        ),
                                      ),
                                    ),
              
                                    
                                
                                    Padding(
                                      padding: EdgeInsets.all(8.0*scalor),
                                      child: Container(
                                        height: 60 * scalor,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
                                          color: palette.widget1,
                                          boxShadow: [
                                            BoxShadow(
                                              color: palette.widgetShadow1,
                                              spreadRadius: 2.0 * scalor,
                                              blurRadius: 15.0 * scalor,
                                              offset: Offset(0.0, 5.0 * scalor),
                                            )
                                          ]
                                        ),
                                
                                        child: ListTile(
                                          leading: Icon(Icons.color_lens,color: palette.widgetText1),
                                          title: DropdownButtonFormField<String>(
                                            value: _selectedTheme,
                                            alignment: AlignmentDirectional.centerStart,
                                            dropdownColor: palette.widget1,
                                            padding: EdgeInsets.all(0.0),
                                            items: _colorThemes.map((theme) {
                                              return DropdownMenuItem(
                                                value: theme, 
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${Helpers().formatWord(theme)} Theme",
                                                      style: TextStyle(
                                                        color: palette.widgetText1,
                                                      ),
                                                    ),
                                                    SizedBox(width: 50,),
                                                    
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 20 * scalor, 
                                                          height: 20 * scalor,
                                                          child: CircleAvatar(backgroundColor: colorsDictionary[theme]!["bg2"],),
                                                        ),
                                                    
                                                        SizedBox(
                                                          width: 20 * scalor, 
                                                          height: 20 * scalor,
                                                          child: CircleAvatar(backgroundColor: colorsDictionary[theme]!["dialog1"],),
                                                        ),
                                                    
                                                        SizedBox(
                                                          width: 20 * scalor, 
                                                          height: 20 * scalor,
                                                          child: CircleAvatar(backgroundColor: colorsDictionary[theme]!["dialog2"],),
                                                        ),
                                                    
                                                        SizedBox(
                                                          width: 20 * scalor, 
                                                          height: 20 * scalor,
                                                          child: CircleAvatar(backgroundColor: colorsDictionary[theme]!["widget1"],),
                                                        ),
                                                    
                                                        SizedBox(
                                                          width: 20 * scalor, 
                                                          height: 20 * scalor,
                                                          child: CircleAvatar(backgroundColor: colorsDictionary[theme]!["widget2"],),
                                                        ),
                                                      ],
                                                    )
                                                                                                                                                                                                                        
                                                    
                                                                                                                                               
                                                
                                                  ],
                                                )
                                              );
                                            }).toList(),
                                            onChanged: (value) => _pickColorTheme(settings,palette,value),
                                            decoration: InputDecoration(
                                              border: null,
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: palette.widgetText1)
                                              )
                                            ),
                                          ),
                                        ),                                  
                                
                                      ),
                                    ),                            
                                
                                    const SizedBox(height: 30),
                                
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }




}

class UsernameCard extends StatelessWidget {
  final String username;
  final ColorPalette palette;
  const UsernameCard({
    super.key,
    required this.username,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context,settings,child) {

        final double scalor = Helpers().getScalor(settings);

        Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
        String username = userData["username"]??"";
        return Center(
          child: Padding(
            padding: EdgeInsets.all(8.0*scalor),
            child: Container(
              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
                color: palette.widget1,
                boxShadow: [
                  BoxShadow(
                    color: palette.widgetShadow1,
                    spreadRadius: 2.0 * scalor,
                    blurRadius: 15.0 * scalor,
                    offset: Offset(0.0, 5.0 * scalor),
                  )
                ]                
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0*scalor),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0 * scalor),
                      child: Text(username, style: TextStyle(
                        fontSize: 22*scalor, 
                        // fontWeight: FontWeight.bold,
                        color: palette.widgetText1
                      )),
                    ),
                      
                    SizedBox(
                      width: 40 * scalor,
                      child: IconButton(
                        onPressed: () {
                          print("open dialog to edit username");
                          // openUpdateUsernameDialog(context,scalor,settings);
                          showDialog(
                            context: context, 
                            builder: (_) => UsernameDialog(currentUsername: username,scalor: scalor,palette: palette,)
                          );
                        }, 
                        icon: Icon(Icons.edit,size: 25 * scalor,color: palette.widgetText1)
                      ),
                    ),            
                  ],
                ),
              ),
            ),
          ),
        );      
      }
    );
  }
}


Widget _rankCard({required String rank, required double scalor, required ColorPalette palette}) {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(8.0*scalor),
      child: Container(
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
          color: palette.widget1,
          boxShadow: [
            BoxShadow(
              color: palette.widgetShadow1,
              spreadRadius: 2.0 * scalor,
              blurRadius: 15.0 * scalor,
              offset: Offset(0.0, 5.0 * scalor),
            )
          ]          
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0*scalor),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
                
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0 * scalor),
                child: Text(
                  rank, style: TextStyle(
                    fontSize: 18*scalor, 
                    // fontWeight: FontWeight.bold,
                    color: palette.widgetText1
                  )),
              ),
                          
            ],
          ),
        ),
      ),
    ),
  );     
}

Widget _infoTile({required IconData icon, required String value, required double scalor, required ColorPalette palette}) {
  return Padding(
    padding: EdgeInsets.all(8.0*scalor),
    child: Container(
      height: 60 * scalor,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
        color: palette.widget2,
      ),
      child: ListTile(
        leading: Icon(icon,color: palette.text1,),
        title: Text(
          value, 
          style:TextStyle(
            // fontWeight: FontWeight.bold,
            color: palette.text1
          )
        ),

      ),
    ),
  );
}







class UsernameDialog extends StatefulWidget {
  final String currentUsername;
  final double scalor;
  final ColorPalette palette;
  const UsernameDialog({
    super.key, 
    required this.currentUsername, 
    required this.scalor, 
    required this.palette
  });

  @override
  State<UsernameDialog> createState() => _UsernameDialogState();
}

class _UsernameDialogState extends State<UsernameDialog> {
  late TextEditingController _controller;
  late String _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentUsername);
    _errorText = '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveUsername(BuildContext context) {
    final newUsername = _controller.text.trim();
    if (newUsername.isEmpty) {
      setState(() {
        _errorText = 'Username cannot be empty.';
      });
      return;
    }

    final settings = Provider.of<SettingsController>(context, listen: false);
    final userData = Map<String, dynamic>.from(settings.userData.value as Map<String,dynamic>);

    userData["username"] = newUsername;
    settings.setUserData(userData); // trigger rebuild

    Navigator.of(context).pop(); // close the dialog
  }

  void _generateRandomUsername(BuildContext context) {

    final newUsername = Helpers().generateRandomUsername();


    if (newUsername.isEmpty) {
      setState(() {
        _errorText = 'Username cannot be empty.';
      });
      return;
    }

    final settings = Provider.of<SettingsController>(context, listen: false);
    final userData = Map<String, dynamic>.from(settings.userData.value as Map<String,dynamic>);

    userData["username"] = newUsername;
    settings.setUserData(userData); // trigger rebuild

    Navigator.of(context).pop(); // close the dialog
  } 



  @override
  Widget build(BuildContext context) {
    

      return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0*widget.scalor))),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 0.6*widget.scalor,
              colors: [widget.palette.dialogBg1,widget.palette.dialogBg2]
            ),
            borderRadius: BorderRadius.all(Radius.circular(12.0*widget.scalor))
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(12.0*widget.scalor,12.0*widget.scalor,12.0*widget.scalor,22.0*widget.scalor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0*widget.scalor),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "UPDATE USERNAME",
                      style: GoogleFonts.lilitaOne(
                        color: widget.palette.text1,
                        fontSize: 22*widget.scalor
                      ),
                    ),
                  ),
                ),
                Divider(color: widget.palette.text1),
                SizedBox(height: 20*widget.scalor,),
                TextField(
                  controller: _controller,
                  style: TextStyle(
                    color: widget.palette.text1,
                    fontSize: 22*widget.scalor
                  ),
                  enableInteractiveSelection: false, //  No selection handles or menu
                  cursorColor: widget.palette.text2,
                  cursorWidth: 1.5,
                  cursorRadius: Radius.circular(2),                  
                  decoration: InputDecoration(
                    border: null,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.palette.text1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.palette.text4),
                    ),
                    
                    labelText: 'New Username',
                    labelStyle: TextStyle(color: widget.palette.text1, fontSize: 18*widget.scalor),
                    contentPadding: EdgeInsets.all(8.0 * widget.scalor)
                  ),
                ),

                SizedBox(height: 20*widget.scalor,),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      
                      backgroundColor: widget.palette.widget2,
                      foregroundColor: widget.palette.text3,                      

                      minimumSize: Size(double.infinity, 0.0),
                      shape: RoundedRectangleBorder(
                        
                        borderRadius: BorderRadius.all(Radius.circular(8*widget.scalor))
                      )
                    ),
                    
                    onPressed: () => _generateRandomUsername(context),
                    
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8.0*widget.scalor,4.0*widget.scalor,8.0*widget.scalor,4.0*widget.scalor),
                      child: Text(
                        "Random Username",
                        style: GoogleFonts.lilitaOne(
                          // color: Colors.white,
                          fontSize: 22*widget.scalor,
                          color: widget.palette.text1
                        ),),
                    )
                  ),

                Divider(color: widget.palette.text1),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.palette.widget1,
                      foregroundColor: widget.palette.text1,
                      minimumSize: Size(0.0, 0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8*widget.scalor))
                      )
                    ),
                    onPressed: () =>_saveUsername(context),
                    
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8.0*widget.scalor,4.0*widget.scalor,8.0*widget.scalor,4.0*widget.scalor),
                      child: Text(
                        "SAVE",
                        style: GoogleFonts.lilitaOne(
                          // color: Colors.white,
                          fontSize: 22*widget.scalor,
                          color: widget.palette.text1
                        ),),
                    )
                  ),
                )
              ]
            ),
          )
        ),
      );    
  }
}
