import 'package:flutter/material.dart';
import 'package:study_calendar/generated/l10n.dart';
import 'package:study_calendar/services/auth.dart';

class RecoverPass extends StatefulWidget {
  @override
  _RecoverPassState createState() => _RecoverPassState();
}

class _RecoverPassState extends State<RecoverPass> {
  String _currentEmail = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailControl = TextEditingController();
  bool _validate = false;
  String _error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(30),
                padding: EdgeInsets.fromLTRB(10.0, 50.0, 0.0, 0.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: S.of(context).recover,
                        style: TextStyle(
                            fontSize: 60.0,
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
            ),
          ),
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
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
                        labelText: "EMAIL",
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                  ),
                  SizedBox(height: 20.0),
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
                        S.of(context).recoverBig,
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
                          var response = await AuthService()
                              .recoverPassword(_currentEmail);

                          if (response != "") {
                            setState(() {
                              _error = response;
                            });
                          } else {
                            setState(() {
                              _error = S.of(context).emailSent;
                              _emailControl.clear();
                            });
                          }
                        }
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
                          S.of(context).backLogin,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
