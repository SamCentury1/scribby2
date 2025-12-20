import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final UserCredential? credential;
  final String? errorCode;
  final String? errorMessage;

  const AuthResult._({
    this.credential,
    this.errorCode,
    this.errorMessage,
  });

  factory AuthResult.success(UserCredential cred) {
    return AuthResult._(credential: cred);
  }

  factory AuthResult.failure({
    required String errorCode,
    required String errorMessage,
  }) {
    return AuthResult._(
      errorCode: errorCode,
      errorMessage: errorMessage,
    );
  }

  bool get isSuccess => credential != null;
}