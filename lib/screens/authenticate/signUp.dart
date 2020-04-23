import 'package:flutter/material.dart';
import 'package:study_calendar/screens/authenticate/recover.dart';
import 'package:study_calendar/services/auth.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isSignUp = false;
  String _currentEmail = "";
  String _currentPassword = "";

  String _error = "";
  TextEditingController _passwordControl = TextEditingController();
  TextEditingController _emailControl = TextEditingController();
  TextEditingController _repeatPasswordControl = TextEditingController();
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(children: [
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10.0, 60.0, 0.0, 0.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: isSignUp ? "SignUp" : 'Login',
                            style: TextStyle(
                                fontSize: 80.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: '.',
                            style: TextStyle(
                                fontSize: 80.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Container(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _emailControl,
                          validator: (val) =>
                              val.isEmpty ? "Enter an email" : null,
                          onChanged: (value) {
                            setState(() {
                              _currentEmail = value;
                            });
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email, color: Colors.grey),
                              errorText: _validate && (_currentEmail == "")
                                  ? 'Email Can\'t Be Empty'
                                  : null,
                              labelText: 'EMAIL',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _passwordControl,
                          onChanged: (value) {
                            setState(() {
                              _currentPassword = value;
                            });
                          },
                          validator: (val) =>
                              val.isEmpty ? "Enter Password" : null,
                          decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.lock_open, color: Colors.grey),
                              labelText: 'PASSWORD ',
                              errorText: _validate && (_currentPassword == "")
                                  ? "Password Can\'t Be Empty"
                                  : null,
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          obscureText: true,
                        ),
                        SizedBox(height: 10.0),
                        Visibility(
                          visible: isSignUp,
                          child: TextFormField(
                            validator: (val) => val != _currentPassword
                                ? "Password do not match"
                                : null,
                            /*     onChanged: (value) {
                              setState(() {
                                _currentRepeatPassword = value;
                              });
                            }, */
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.lock_open, color: Colors.grey),
                                labelText: 'REPEAT PASSWORD ',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green))),
                          ),
                        ),
                        Visibility(
                          visible: !isSignUp,
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecoverPass()),
                                  );
                                },
                                child: Text("Forgot Your Password?"),
                              ),
                            ],
                          )),
                        ),
                        Visibility(
                            visible: _error != "",
                            child: Container(child: SizedBox(height: 10.0))),
                        Container(
                            child: Text(
                          _error,
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                        SizedBox(height: 30.0),
                        Container(
                          width: double.infinity,
                          height: 40.0,
                          child: RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              isSignUp ? "CREATE ACCOUNT" : 'LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                var response = "";
                                isSignUp
                                    ? response = await AuthService()
                                        .registerWithEmailandPassword(
                                            _currentEmail, _currentPassword)
                                    : response = await AuthService()
                                        .signInWithEmailandPassword(
                                            _currentEmail, _currentPassword);
                                if (response != "") {
                                  setState(() {
                                    _error = response;
                                  });
                                }
                              } else {
                                setState(() {
                                  _passwordControl.clear();
                                  _emailControl.clear();
                                  _repeatPasswordControl.clear();
                                  _error = "";
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          width: double.infinity,
                          height: 40.0,
                          child: RaisedButton(
                            color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ImageIcon(AssetImage('assets/google.png')),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "ACCESS WITH GOOGLE",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () async {
                              await AuthService().signInWithGoogle();
                            },
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          width: double.infinity,
                          height: 40.0,
                          child: OutlineButton(
                              color: Colors.white,
                              child: Text(
                                isSignUp
                                    ? "Already Have an account"
                                    : 'Create Account',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordControl.clear();
                                  _emailControl.clear();
                                  _repeatPasswordControl.clear();
                                  _error = "";
                                  isSignUp = !isSignUp;
                                  _formKey.currentState.reset();
                                });
                              }),
                        ),
                      ],
                    )),
              ),
            ]),
          ),
        ));
  }
}
