import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/screens/authentication/login_screen.dart';
import 'package:scribby_flutter_v2/screens/authentication/register_screen.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {

  late bool showLoginScreen = true;

  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }



  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      print("login");
      return LoginScreen(onTap: toggleScreens,);
    } else {
      print("register");
      return RegisterScreen(onTap: toggleScreens,);
    }    
  }
}


// Future<void> setScreenSizeData(BuildContext context) async {
//   // Set the screen size data directly
//   SettingsState settingsState = context.read<SettingsState>();
  
//   final Size size = MediaQuery.of(context).size;   
  
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     final double sizeFactor = size.height < 600 ? 0.7 : 1.0;
//     settingsState.setSizeFactor(sizeFactor);

//   });
// }
