import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/loading_image.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/screens/authentication/login_or_register_screen.dart';
import 'package:scribby_flutter_v2/screens/home_screen/home_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  @override
  void initState() {
    super.initState();
  }  
  @override
  Widget build(BuildContext context) {

    // final SettingsController settings = Provider.of<SettingsController>(context,listen:false);
    // final ColorPalette palette = Provider.of<ColorPalette>(context,listen:false);
    // final settings = context.read<SettingsController>();
    // final palette = context.read<ColorPalette>();    

    
  
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
    
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint("streaming auth state changes --- loading...");
            return loadingImage(context);
          }

          if (snapshot.hasError) {
            debugPrint("an error occured at auth screen : ${snapshot.error} | ${snapshot.stackTrace}");
            return errorScreen(context, 'Error: ${snapshot.error} | ${snapshot.stackTrace}');
          }

          if (!snapshot.hasData) {
            debugPrint("no authenticated user --- go to login or register screen");
            return LoginOrRegisterScreen();
          }

          final settings = context.read<SettingsController>();
          final palette  = context.read<ColorPalette>();          


          return FutureBuilder(
            future: Initializations().initializeAppData2(settings, palette, snapshot.data), 
            builder: (context, AsyncSnapshot<void> futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                debugPrint("initializing app data --- loading ...");
                return loadingImage(context);                   
              } 
              
              if (futureSnapshot.hasError) {
                debugPrint("An error during app initialization --- ${futureSnapshot.error} | ${futureSnapshot.stackTrace}");
                return errorScreen(context, 'Error: ${futureSnapshot.error} | ${futureSnapshot.stackTrace}');
              } 
              
              return HomeScreen();
            }
          );

        },
      );
    
  }
}


Widget loadingImage(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: SizedBox(
      width:MediaQuery.of(context).size.width, 
      height:MediaQuery.of(context).size.height,
      child: LoadingImage()
    )
  );   
}

Widget errorScreen(BuildContext context, String error) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: SizedBox(
      width:MediaQuery.of(context).size.width, 
      height:MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          children: [
            Text("An error occured"),
            Text(error)
          ],
        ) 
      )
    )
  );   
}