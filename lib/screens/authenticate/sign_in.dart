import 'package:flutter/material.dart';
import 'package:study_calendar/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text("SignIn", style: Theme.of(context).textTheme.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  await _auth.registerWithEmailandPassword(
                      "user@test.com", "24682468");
                },
                child: Text("Register"),
              ),
              FlatButton(
                onPressed: () async {
                  await _auth.signInWithGoogle();
                },
                child: Text("Google"),
              ),
              FlatButton(
                onPressed: () async {
                  await _auth.signInWithEmailandPassword(
                      "user@test.com", "24682468");
                },
                child: Text("Sign In"),
              ),
              FlatButton(
                onPressed: () async {
                  await _auth.signOut();
                },
                child: Text("Log Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
