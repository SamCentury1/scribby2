import 'dart:io';

import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scribby_flutter_v2/screens/authentication/components/auth_error_dialog.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  String getUserEmail() => _firebaseAuth.currentUser?.email?? "User";



  Future<void> registerUserManually(String email, String password, String username) async {
    UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );  
    if (cred.additionalUserInfo!.isNewUser) {
        final String uid = cred.user!.uid;
        final String displayName = username;
        final String userEmail = email;
        final String photoURL = cred.user!.photoURL??"";
        const String providerData = "none";
        final Map<String,dynamic> userData = {
          "uid":uid,
          "displayName": displayName,
          "email": userEmail,
          "photoURL": photoURL,
          "providerData": providerData,
        };      
      FirestoreMethods().saveUserToDatabase(userData);
    }    
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    print("sign in with google");
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final UserCredential cred = await _firebaseAuth.signInWithCredential(credential);

      print("user cred: $cred");
      if (cred.additionalUserInfo!.isNewUser) {
        final String uid = cred.user!.uid;
        final String displayName = cred.user!.displayName??"User";
        final String email = cred.user!.email??"user@email.com";
        final String photoURL = cred.user!.photoURL??"";
        const String providerData = "google";
        final Map<String,dynamic> userData = {
          "uid":uid,
          "displayName": displayName,
          "email": email,
          "photoURL": photoURL,
          "providerData": providerData,
        };
        FirestoreMethods().saveUserToDatabase(userData);
      }    
      return cred;  
    } catch(e) {
      print("===========================================");
      print("GOOGLE SIGN IN ERROR:");
      print("$e");
      print("===========================================");

      showDialog(
        context: context,
        builder: (ctx) => AuthErrorDialog(errorTitle: 'Google Sign-in Error', errors: [e.toString()],)
      );
      //
             
      return null;
    }
  }

  Future<UserCredential?> signInWithApple(BuildContext context) async {
    try {
      
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ]
      );

      print("apple cred: $appleCredential");

      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      print("oauth cred: $oAuthCredential");

      final UserCredential cred = await _firebaseAuth.signInWithCredential(oAuthCredential);

      print("user cred: $cred");
      if (cred.additionalUserInfo!.isNewUser) {
        final String uid = cred.user!.uid;
        final String displayName = cred.user!.displayName??"User";
        final String email = cred.user!.email??"user@email.com";
        final String photoURL = cred.user!.photoURL??"";
        const String providerData = "apple";
        final Map<String,dynamic> userData = {
          "uid":uid,
          "displayName": displayName,
          "email": email,
          "photoURL": photoURL,
          "providerData": providerData,
        };
        FirestoreMethods().saveUserToDatabase(userData);

      }

      return cred;

    } catch (e) {
      
      print("===========================================");
      print("APPLE SIGN IN ERROR:");
      print("$e");
      print("===========================================");

      showDialog(
        context: context,
        builder: (ctx) => AuthErrorDialog(errorTitle: 'Apple Sign-in Error', errors: [e.toString()],)
      );   
      return null;
    }
  }


  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }


  Future<void> authenticationFailed(BuildContext context, String error) async {
    if (error == 'invalid-credential') {
      return showLoginFailedDialog(
        context,
        "Invalid Credentials",
        ["Please provide a valid email and password combination."]
      );
    } else if (error == 'invalid-email') {
      return showLoginFailedDialog(
        context,
        "Invalid Email",
        ["Please provide a valid email address."]
      );
    } else if (error == 'channel-error') {
      return showLoginFailedDialog(
        context,
        "Unexpected Error",
        ["Please populate all fields before continuing."]
      );
    } else if (error == 'user-disabled') {
      return showLoginFailedDialog(
        context, 
        "User Disabled", 
        ["This user has been disabled, please create a new account."]
      );
    } else if (error == 'wrong-password') {
      return showLoginFailedDialog(
        context, 
        "Wrong Password", 
        ["Please enter the correct password or tap 'forgot password'."]
      );
    } else if (error == 'too-many-requests') {
      return showLoginFailedDialog(
        context, 
        "Too Many Requests", 
        ["Too many requests have been sent simultaneously, for security - please come back later."]
      );
    } else if (error == 'user-token-expired') {
      return showLoginFailedDialog(
        context, 
        "User Token Expired", 
        ["You are no longer authenticated since your refresh token has been expired."]
      );
    } else if (error == 'network-request-failed') {
      return showLoginFailedDialog(
        context, 
        "Network Request Error", 
        ["Please make sure you are connected to the internet to authenticate."]
      );
    } else if (error == 'operation-not-allowed') {
      return showLoginFailedDialog(
        context, 
        "Operation Not Allowed", 
        ["Please reach out to support for assistance."]
      );
    } else if (error == 'operation-not-allowed') {
      return showLoginFailedDialog(
        context, 
        "Operation Not Allowed", 
        ["Please reach out to support for assistance."]
      );

      /// =======================================
    } else if (error == 'email-already-in-use') {
      return showLoginFailedDialog(
        context, 
        "Email already in use", 
        ["This email is already in use. Please choose another email or tap 'forgot password'."]
      );
    } else {
      return showLoginFailedDialog(
        context, 
        "Unexpected Error", 
        ["Please reach out to support for assistance."]
      );
    }
  }

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