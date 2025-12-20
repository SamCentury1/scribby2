import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scribby_flutter_v2/components/background_painter.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/screens/authentication/components/auth_error_dialog.dart';
import 'package:scribby_flutter_v2/screens/authentication/components/auth_provider_tile.dart';
import 'package:scribby_flutter_v2/screens/authentication/components/login_button.dart';
// import 'package:scribby_flutter_v2/screens/authentication/components/login_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/screens/authentication/login_textfield.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';


class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final List<String> errors = [];

    if (password1Controller.text != password2Controller.text) {
      errors.add("Passwords don't match");
    }

    if (password1Controller.text.length < 7) {
      errors.add("Password must be at least 7 characters");
    }

    if (errors.isNotEmpty) {
      AuthService().showLoginFailedDialog(context, "Errors", errors);
      return;
    }

    final String langCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;

    final result = await AuthService().registerUserManually(
      emailController.text.trim(),
      password1Controller.text,
      usernameController.text.trim(),
      langCode,
    );

    if (!mounted) return;

    if (!result.isSuccess) {
      AuthService().showLoginFailedDialog(
        context,
        "Registration Failed",
        [result.errorMessage ?? "Something went wrong"],
      );
    }
  }

  void onGooglePressed() async {
    final result = await AuthService().signInWithGoogle();

    if (!mounted) return;

    if (!result.isSuccess) {
      showDialog(
        context: context,
        builder: (_) => AuthErrorDialog(
          errorTitle: "Google Sign-in Error",
          errors: [result.errorMessage!],
        ),
      );
    }
  }  

  void onApplePressed() async {
    final result = await AuthService().signInWithApple();

    if (!mounted) return;

    if (!result.isSuccess) {
      showDialog(
        context: context,
        builder: (_) => AuthErrorDialog(
          errorTitle: "Apple Sign-in Error",
          errors: [result.errorMessage!],
        ),
      );
    }
  }      

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen:false);
    // late SettingsController settings = Provider.of<SettingsController>(context, listen:false);
    return Consumer<SettingsController>(
      builder: (context,settings,child) {
        final double scalor = Helpers().getScalor(settings);
        return Stack(
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
              resizeToAvoidBottomInset: true,
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context,constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.25,
                            child: Center(
                              child: Image.asset('assets/images/scribby_label_1.png'),
                            ),
                          ),
                              
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Welcome!",
                                style: palette.mainAppFont(
                                  textStyle: TextStyle(
                                    fontSize: 34 * scalor, 
                                    color: palette.text1
                                  ),
                                ),
                              ),
                            
                              LoginTextField(controller: usernameController, hintText: 'Username', obscureText: false, palette: palette,),
                          
                              LoginTextField(controller: emailController, hintText: 'Email', obscureText: false, palette: palette,),
                            
                              LoginTextField(controller: password1Controller, hintText: 'Password', obscureText: true, palette: palette,),
                          
                              LoginTextField(controller: password2Controller, hintText: 'Confirm Password', obscureText: true, palette: palette,),
                            
                              LoginButton(onTap: registerUser, body: "Register", palette: palette,),
                          
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25.0 * scalor),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Divider(thickness: 0.5*scalor, color: palette.text1),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.0 * scalor, vertical: 18.0 * scalor),
                                      child: Text(
                                        "or continue with",
                                        style: palette.authFont(
                                          textStyle: TextStyle(
                                            fontSize: 16 * scalor, 
                                            color: palette.text1
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(thickness: 0.5*scalor, color: palette.text1),
                                    )                      
                                  ],
                                )
                              ),
                          
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AuthProviderTile(
                                    palette: palette, 
                                    // onTap: () => AuthService().signInWithGoogle(), 
                                    onTap: () => onGooglePressed(),
                                    iconData: Icons.g_mobiledata,
                                  ),
                                  SizedBox(width: 10,),
                            
                                  AuthProviderTile(
                                    palette: palette, 
                                    onTap: () => onApplePressed(),
                                    iconData: Icons.apple,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0 * scalor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("already a member?", 
                                      style: palette.authFont(
                                        textStyle: TextStyle(
                                          fontSize: 16 * scalor, 
                                          color: palette.text1
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    InkWell(
                                      onTap: widget.onTap,
                                      child: Text(
                                        "login now",
                                        style: palette.authFont(
                                          textStyle: TextStyle(
                                            fontSize: 16 * scalor,
                                            fontWeight: FontWeight.bold,
                                            color: palette.text1
                                          ),
                                        ),
                                      ),
                                    )
                                                              
                                  ],
                                ),
                              )
                            ],
                          ),
                              
                          // Expanded(flex: 4, child:SizedBox())
                        ],
                      ),
                    );
                  }
                ),
              )
            ),
          ],
        );
      }
    );
  }
}