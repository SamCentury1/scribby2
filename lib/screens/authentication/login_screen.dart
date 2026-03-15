import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/background_painter.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/screens/authentication/components/auth_error_dialog.dart';
import 'package:scribby_flutter_v2/screens/authentication/components/auth_provider_tile.dart';
import 'package:scribby_flutter_v2/screens/authentication/components/login_button.dart';
import 'package:scribby_flutter_v2/screens/authentication/login_textfield.dart';
// import 'package:scribby_flutter_v2/screens/authentication/components/login_textfield.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';


class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key,required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signInUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text
      );

    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (_) => AuthErrorDialog(
          errorTitle: "Google Sign-in Error",
          errors: [e.toString()],
        ),
      );
    }
    
    // Navigator.pop(context);
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

  void onFacebookPressed() async {
    print("sign in with facebook");
    final result = await AuthService().signInWithFacebook();

    if (!mounted) return;

    if (!result.isSuccess) {
      showDialog(
        context: context,
        builder: (_) => AuthErrorDialog(
          errorTitle: "Facebook Sign-in Error",
          errors: [result.errorMessage!],
        ),
      );
    }
  }      


  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen:false);
    // late SettingsController settings = Provider.of<SettingsController>(context, listen:false);
    // final double scalor = Helpers().getScalor(settings);
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
                  painter: GradientBackground(settings: settings, palette: palette, decorationData:[]),
                ),
              ),
            ),              
            Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context,constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                        
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // SizedBox(height: 50,),
                              // Icon(Icons.lock,size: 100,),
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
                                    "Welcome back!",
                                    // style: TextStyle(color: Colors.grey[700],fontSize: 24),
                                    // style: TextStyle(color: palette.text1,fontSize: 24*scalor),
                                    style: palette.mainAppFont(
                                      textStyle: TextStyle(
                                        fontSize: 34 * scalor, 
                                        color: palette.text1
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 15,),
                                  LoginTextField(controller: emailController, hintText: 'Email', obscureText: false, palette: palette,),
                                  // SizedBox(height: 25,),
                                  LoginTextField(controller: passwordController, hintText: 'Password', obscureText: true, palette: palette,),
                                  // SizedBox(height: 10,),
                              
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "forgot password?",
                                        style: palette.authFont(
                                          textStyle: TextStyle(
                                            fontSize: 18 * scalor, 
                                            color: palette.text1
                                          ),
                                        ),
                                    ),
                                  ),
                              
                                  // SizedBox(height: 20),
                                  LoginButton(onTap: signInUser, body: "Sign In", palette: palette,),
                                  // SizedBox(height: 20),
                              
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 25.0 * scalor),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Divider(thickness: 0.5 * scalor, color: palette.text1,),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.0 * scalor,vertical: 18.0 * scalor),
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
                                          child: Divider(thickness: 0.5 * scalor, color: palette.text1,),
                                        )                      
                                      ],
                                    )
                                  ),
                                          
                                  // SizedBox(height: 20,),
                              
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AuthProviderTile(
                                        palette: palette, 
                                        onTap: () => onGooglePressed(), 
                                          
                                        
                                        iconData: Icons.g_mobiledata,
                                      ),
                                      SizedBox(width: 10,),
                                          
                                      AuthProviderTile(
                                        palette: palette, 
                                        onTap: () =>  onApplePressed(), 
                                        iconData: Icons.apple,
                                      ),

                                      SizedBox(width: 10,),
                                      
                                      AuthProviderTile(
                                        palette: palette, 
                                        onTap: () =>  onFacebookPressed(), 
                                        iconData: Icons.facebook,
                                      ),                        
                                                                                            
                                    ],
                                  ),
                                  // SizedBox(height: 20,),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.0 * scalor),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("not a member?", 
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
                                            "register now",
                                            style: palette.authFont(
                                              textStyle: TextStyle(
                                                fontSize: 16 * scalor,
                                                fontWeight: FontWeight.bold,
                                                color: palette.text2
                                              ),
                                            ),
                                          ),
                                        )
                                                                  
                                      ],
                                    ),
                                  ),                    
                                ],
                              ),
                            ],
                          ),
                        ),
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