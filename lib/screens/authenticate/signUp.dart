import 'package:flutter/material.dart';
import 'package:study_calendar/generated/l10n.dart';
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
  bool isRecover = false;
  String _error = "";
  TextEditingController _passwordControl = TextEditingController();
  TextEditingController _emailControl = TextEditingController();
  TextEditingController _repeatPasswordControl = TextEditingController();
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomPadding: false,
      body: ListView(children: [
        _buildTitle(context),
        Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height - 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(70),
              ),
            ),
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    key: ValueKey("emailField"),
                    controller: _emailControl,
                    validator: (val) =>
                        val.isEmpty ? S.of(context).enterEmail : null,
                    onChanged: (value) {
                      setState(() {
                        _currentEmail = value;
                      });
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Colors.grey),
                        errorText: _validate && (_currentEmail == "")
                            ? S.of(context).emailEmpty
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
                    key: ValueKey("passField"),
                    controller: _passwordControl,
                    onChanged: (value) {
                      setState(() {
                        _currentPassword = value;
                      });
                    },
                    validator: (val) =>
                        val.isEmpty ? S.of(context).enterPassword : null,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_open, color: Colors.grey),
                        labelText: S.of(context).password,
                        errorText: _validate && (_currentPassword == "")
                            ? S.of(context).passwordEmpty
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
                  SizedBox(
                    height: 60.0,
                    child: isSignUp
                        ? TextFormField(
                            key: ValueKey("repeatField"),
                            validator: (val) => val != _currentPassword
                                ? S.of(context).passNoMatch
                                : null,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.lock_open, color: Colors.grey),
                              labelText: S.of(context).repeatPass,
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          )
                        : Container(
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
                                child: Text(
                                  S.of(context).forgot,
                                  style: TextStyle(fontSize: 15.0),
                                ),
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
                    key: ValueKey("btnSignInorRegister"),
                    width: double.infinity,
                    height: 40.0,
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        isSignUp
                            ? S.of(context).createAccount
                            : (S.of(context).login).toUpperCase(),
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
                      key: ValueKey("googleSignIn"),
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ImageIcon(AssetImage('assets/google.png')),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              S.of(context).accessGoogle,
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
                    key: ValueKey("btnHaveActNewAct"),
                    width: double.infinity,
                    height: 40.0,
                    child: OutlineButton(
                        highlightColor: Colors.teal.shade300,
                        color: Colors.white,
                        child: Text(
                          isSignUp
                              ? S.of(context).haveAccount
                              : S.of(context).createAccount,
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
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Container _buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 30.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: isSignUp ? S.of(context).signUp : S.of(context).login,
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
                  color: Colors.purple.shade200),
            ),
          ],
        ),
      ),
    );
  }
}
