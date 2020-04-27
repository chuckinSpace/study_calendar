import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:study_calendar/models/user_data.dart';
import 'package:study_calendar/screens/authenticate/signUp.dart';

import 'package:study_calendar/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:study_calendar/screens/settings/settings.dart';
import 'package:study_calendar/screens/welcome.dart';

class Wrapper extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  Wrapper({this.analytics, this.observer});
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<FirebaseUser>(context);
    final _userData = Provider.of<UserData>(context);

    // return eurhter home or autheticate depeending on auth
    if (_user == null) {
      return SignupPage();
    } else {
      if (_userData != null && _userData.isWelcomeScreenSeen != null) {
        if (!_userData.isWelcomeScreenSeen) {
          return WelcomeScreen(_userData.uid);
        } else if (_userData.isWelcomeScreenSeen &&
            _userData.calendarToUse == "") {
          return Settings();
        } else if (_userData.isWelcomeScreenSeen &&
            _userData.calendarToUse != "") {
          return Home(
            analytics: analytics,
            observer: observer,
          );
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    }
  }
}
