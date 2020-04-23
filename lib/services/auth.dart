import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:study_calendar/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> registerWithEmailandPassword(
      String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = authResult.user;

      await DatabaseService().createUserDocument(email, user.uid);

      return "";
    } catch (e) {
      if (e.code == "ERROR_INVALID_EMAIL") {
        return "Invalid Email";
      } else if (e.code == "ERROR_WEAK_PASSWORD") {
        return "Password must be at least 7 characters";
      } else if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        return "Email is already registered, please retrieve your password in the sign in page";
      } else {
        return "User not found";
      }
    }
  }

  //sign in with email and pass
  Future signInWithEmailandPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      if (e.code == "ERROR_INVALID_EMAIL") {
        return "Invalid Email";
      } else if (e.code == "ERROR_WRONG_PASSWORD") {
        return "Invalid Password";
      } else if (e.code == "ERROR_USER_NOT_FOUND") {
        return "This Email was not found";
      } else {
        return "User not found";
      }
    }
  }

  Future<AuthCredential> getCredentials(GoogleSignInAccount account) async {
    AuthCredential auth = GoogleAuthProvider.getCredential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken);
    return auth;
  }

  Future<bool> signInWithGoogle() async {
    try {
      GoogleSignIn google = new GoogleSignIn(
        scopes: [
          'email',
        ],
      );

      GoogleSignInAccount account = await google.signIn();
      if (account == null) {
        return false;
      } else {
        final credentials = await getCredentials(account);

        AuthResult res = await _auth.signInWithCredential(credentials);

        if (res.user == null) {
          return false;
        } else {
          FirebaseUser user = res.user;
          await DatabaseService().createUserDocument(user.email, user.uid);
          print("back from firestore");
          return true;
        }
      }
    } catch (e) {
      print("error signing with google $e");
      return false;
    }
  }

  Future<String> recoverPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      //create a new documnet for the user iwh uid
      return "";
    } catch (e) {
      if (e.code == "ERROR_INVALID_EMAIL") {
        return "Invalid Email";
      } else {
        return "User not found";
      }
    }
  }

  //signout
  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
