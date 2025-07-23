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

    final SettingsController settings = Provider.of<SettingsController>(context,listen:false);
    final ColorPalette palette = Provider.of<ColorPalette>(context,listen:false);

    print("in the initstate func of the auth screen. device size data: ${settings.deviceSizeInfo.value} | language: ${settings.language.value} ");
    

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // StorageMethods().saveDeviceSizeInfoToSettings(settings);
        final SettingsController settings = Provider.of<SettingsController>(context, listen: false);
        StorageMethods().saveDeviceSizeInfoToSettings(settings);
        StorageMethods().saveLanguageLocalesToSettings(settings);
        StorageMethods().initializeThemeColor(settings);
        print("in auth screen: theme value = ${settings.theme.value}");        
        palette.getThemeColors(settings.theme.value);
      });
    });        
  }  
  @override
  Widget build(BuildContext context) {

    final SettingsController settings = Provider.of<SettingsController>(context,listen:false);
    final ColorPalette palette = Provider.of<ColorPalette>(context,listen:false);

    
  
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // print("Snapshot: $snapshot");

          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting");
            // return Scaffold(body: Center(child: CircularProgressIndicator()));
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: SizedBox(
                width:MediaQuery.of(context).size.width, 
                height:MediaQuery.of(context).size.height,
                child: LoadingImage()
              )
            );            
          } else {
            if (snapshot.hasData) {
              

              return FutureBuilder(
                future: Initializations().initializeAppData(settings, palette, snapshot.data), 
                builder: (context, AsyncSnapshot<void> futureSnapshot) {
                  if (futureSnapshot.connectionState == ConnectionState.waiting) {
                    // return Scaffold(body: Center(child: CircularProgressIndicator()));
                    return Scaffold(
                      backgroundColor: Colors.transparent,
                      body: SizedBox(
                        width:MediaQuery.of(context).size.width, 
                        height:MediaQuery.of(context).size.height,
                        child: LoadingImage()
                      )
                    );                    
                  } else if (futureSnapshot.hasError) {
                    return Scaffold(body: Center(child: Text('Error: ${futureSnapshot.error} | ${futureSnapshot.stackTrace}')));
                  } else {
                    return HomeScreen(); // Only return after getScreenSizeData() completes

                  }
                }
              );
              // return HomeScreen();
            }else {
              print("============================================");
              print("hm! ");
              print("============================================");
              // setScreenSizeData(context);
              return LoginOrRegisterScreen();
            }
          } 
        },
      );
    
  }
}
