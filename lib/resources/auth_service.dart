import 'dart:io';

import 'package:scribby_flutter_v2/models/auth_result.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/screens/authentication/auth_screen.dart';
import 'package:scribby_flutter_v2/screens/authentication/components/auth_error_dialog.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  String getUserEmail() => _firebaseAuth.currentUser?.email?? "User";


  Future<AuthResult> registerUserManually(
    String email,
    String password,
    String username,
    String langCode,
  ) async {
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.additionalUserInfo?.isNewUser == true) {
        final userData = {
          "uid": cred.user!.uid,
          "displayName": username,
          "email": email,
          "langCode": langCode,
          "providerData": "none",
        };

        await FirestoreMethods().saveUserToDatabase(userData);
      }

      return AuthResult.success(cred);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorCode: e.code,
        errorMessage: e.message ?? "Registration failed",
      );
    } catch (e) {
      return AuthResult.failure(
        errorCode: "unknown",
        errorMessage: e.toString(),
      );
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      final gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        return AuthResult.failure(
          errorCode: 'cancelled',
          errorMessage: 'Sign-in cancelled',
        );
      }

      final gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final cred = await _firebaseAuth.signInWithCredential(credential);

      if (cred.additionalUserInfo?.isNewUser == true) {
        final langCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;

        await FirestoreMethods().saveUserToDatabase({
          "uid": cred.user!.uid,
          "displayName": cred.user!.displayName ?? "User",
          "email": cred.user!.email ?? "user@email.com",
          "langCode": langCode,
          "providerData": "google",
        });
      }

      return AuthResult.success(cred);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorCode: e.code,
        errorMessage: e.message ?? 'Authentication failed',
      );
    } catch (e) {
      return AuthResult.failure(
        errorCode: 'unknown',
        errorMessage: e.toString(),
      );
    }
  }

  Future<AuthResult> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential cred =
          await _firebaseAuth.signInWithCredential(oAuthCredential);

      if (cred.additionalUserInfo?.isNewUser == true) {
        final String uid = cred.user!.uid;

        final String displayName =
            cred.user?.displayName ??
            (() {
              final name =
                  '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                      .trim();
              return name.isNotEmpty ? name : 'User';
            })();

        final String email =
            cred.user?.email ??
            appleCredential.email ??
            'user@apple.com';

        final String langCode =
            WidgetsBinding.instance.platformDispatcher.locale.languageCode;

        const String providerData = "apple";

        final Map<String, dynamic> userData = {
          "uid": uid,
          "displayName": displayName,
          "email": email,
          "langCode": langCode,
          "providerData": providerData,
        };

        await FirestoreMethods().saveUserToDatabase(userData);
      }

      return AuthResult.success(cred);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return AuthResult.failure(
          errorCode: 'canceled',
          errorMessage: 'Sign in cancelled',
        );
      }
      return AuthResult.failure(
        errorCode: 'apple-auth-error',
        errorMessage: e.message,
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorCode: e.code,
        errorMessage: e.message ?? 'Authentication failed',
      );
    } catch (e) {
      return AuthResult.failure(
        errorCode: 'unknown',
        errorMessage: e.toString(),
      );
    }
  }

Future<AuthResult> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.cancelled) {
        return AuthResult.failure(
          errorCode: 'canceled',
          errorMessage: 'Sign in cancelled',
        );
      }

      if (loginResult.status != LoginStatus.success) {
        return AuthResult.failure(
          errorCode: 'facebook-auth-error',
          errorMessage: loginResult.message ?? 'Facebook sign in failed',
        );
      }

      final OAuthCredential oAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      final UserCredential cred = await _firebaseAuth.signInWithCredential(oAuthCredential);

      if (cred.additionalUserInfo?.isNewUser == true) {
        final String uid = cred.user!.uid;

        // Fetch user profile data from Facebook
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email",
        );

        final String displayName = cred.user?.displayName ?? userData['name'] ?? 'User';

        final String email = cred.user?.email ?? userData['email'] ?? 'user@facebook.com';

        final String langCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;

        const String providerData = "facebook";

        final Map<String, dynamic> userDataMap = {
          "uid": uid,
          "displayName": displayName,
          "email": email,
          "langCode": langCode,
          "providerData": providerData,
        };

        await FirestoreMethods().saveUserToDatabase(userDataMap);
      }

      return AuthResult.success(cred);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorCode: e.code,
        errorMessage: e.message ?? 'Authentication failed',
      );
    } catch (e) {
      return AuthResult.failure(
        errorCode: 'unknown',
        errorMessage: e.toString(),
      );
    }
  }


  // Future<UserCredential?> signInWithApple(BuildContext context) async {
  //   try {
      
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ]
  //     );

  //     print("apple cred: $appleCredential");

  //     final oAuthCredential = OAuthProvider("apple.com").credential(
  //       idToken: appleCredential.identityToken,
  //       accessToken: appleCredential.authorizationCode,
  //     );

  //     print("oauth cred: $oAuthCredential");

  //     final UserCredential cred = await _firebaseAuth.signInWithCredential(oAuthCredential);

  //     print("user cred: $cred");
  //     if (cred.additionalUserInfo!.isNewUser) {
  //       final String uid = cred.user!.uid;
  //       final String displayName = cred.user!.displayName??"User";
  //       final String email = cred.user!.email??"user@email.com";
  //       // final String photoURL = cred.user!.photoURL??"";
  //       final String langCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  //       const String providerData = "apple";
  //       final Map<String,dynamic> userData = {
  //         "uid":uid,
  //         "displayName": displayName,
  //         "email": email,
  //         // "photoURL": photoURL,
  //         "langCode": langCode,
  //         "providerData": providerData,
  //       };
  //       FirestoreMethods().saveUserToDatabase(userData);

  //     }
  //     return cred;
  //   } catch (e) {

  //     showDialog(
  //       context: context,
  //       builder: (ctx) => AuthErrorDialog(errorTitle: 'Apple Sign-in Error', errors: [e.toString()],)
  //     );   
  //     return null;
  //   }
  // }


  Future<void> signOut( SettingsController settings) async {
    await StorageMethods().clearSettings(settings);    
    await _firebaseAuth.signOut();


  }


  // Future<void> authenticationFailed(BuildContext context, String error) async {
  //   if (error == 'invalid-credential') {
  //     return showLoginFailedDialog(
  //       context,
  //       "Invalid Credentials",
  //       ["Please provide a valid email and password combination."]
  //     );
  //   } else if (error == 'invalid-email') {
  //     return showLoginFailedDialog(
  //       context,
  //       "Invalid Email",
  //       ["Please provide a valid email address."]
  //     );
  //   } else if (error == 'channel-error') {
  //     return showLoginFailedDialog(
  //       context,
  //       "Unexpected Error",
  //       ["Please populate all fields before continuing."]
  //     );
  //   } else if (error == 'user-disabled') {
  //     return showLoginFailedDialog(
  //       context, 
  //       "User Disabled", 
  //       ["This user has been disabled, please create a new account."]
  //     );
  //   } else if (error == 'wrong-password') {
  //     return showLoginFailedDialog(
  //       context, 
  //       "Wrong Password", 
  //       ["Please enter the correct password or tap 'forgot password'."]
  //     );
  //   } else if (error == 'too-many-requests') {
  //     return showLoginFailedDialog(
  //       context, 
  //       "Too Many Requests", 
  //       ["Too many requests have been sent simultaneously, for security - please come back later."]
  //     );
  //   } else if (error == 'user-token-expired') {
  //     return showLoginFailedDialog(
  //       context, 
  //       "User Token Expired", 
  //       ["You are no longer authenticated since your refresh token has been expired."]
  //     );
  //   } else if (error == 'network-request-failed') {
  //     return showLoginFailedDialog(
  //       context, 
  //       "Network Request Error", 
  //       ["Please make sure you are connected to the internet to authenticate."]
  //     );
  //   } else if (error == 'operation-not-allowed') {
  //     return showLoginFailedDialog(
  //       context, 
  //       "Operation Not Allowed", 
  //       ["Please reach out to support for assistance."]
  //     );
  //   } else if (error == 'operation-not-allowed') {
  //     return showLoginFailedDialog(
  //       context, 
  //       "Operation Not Allowed", 
  //       ["Please reach out to support for assistance."]
  //     );

  //     /// =======================================
  //   } else if (error == 'email-already-in-use') {
  //     return showLoginFailedDialog(
  //       context, 
  //       "Email already in use", 
  //       ["This email is already in use. Please choose another email or tap 'forgot password'."]
  //     );
  //   } else {
  //     return showLoginFailedDialog(
  //       context, 
  //       "Unexpected Error", 
  //       ["Please reach out to support for assistance."]
  //     );
  //   }
  // }

  Future<void> showLoginFailedDialog(BuildContext context, String title , List<String> errors,) async {

    return await showDialog(
      context: context, 
      builder: (context) {
        return AuthErrorDialog(
          errorTitle: title, 
          errors: errors
        );
      }
    );
  }    

}