/*
ADSS!!!!!!
*/

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:study_calendar/generated/l10n.dart';
import 'package:study_calendar/models/user_data.dart';
import 'package:study_calendar/screens/home/setting_form.dart';
import 'package:study_calendar/screens/home/test_list.dart';
import 'package:study_calendar/screens/settings/settings.dart';
import 'package:study_calendar/services/database.dart';

import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Home({
    this.analytics,
    this.observer,
  });
  @override
  _HomeState createState() => _HomeState(analytics, observer);
}

class _HomeState extends State<Home> {
  _HomeState(this.analytics, this.observer);
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  GlobalKey _testKey = GlobalKey();
  GlobalKey _calendarKey = GlobalKey();
  GlobalKey _settingsKey = GlobalKey();

  UserData _userData;
  var _user;
  List<TargetFocus> targets = List();
  List<TargetFocus> settings = List();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkTutorial(context);
      _setLastActivity();
    });
  }

  didChangeDependencies() async {
    initTargets();
    super.didChangeDependencies();
    _userData = Provider.of<UserData>(context);
    _user = Provider.of<FirebaseUser>(context);
  }

  void checkTutorial(BuildContext context) {
    if (_userData != null && !_userData.isHomeTutorialSeen) {
      _showTutorial(context);
      DatabaseService()
          .updateDocument("users", _userData.uid, {"isHomeTutorialSeen": true});
    }
  }

  _setLastActivity() async {
    try {
      await DatabaseService().updateDocument(
          "users", _userData.uid, {"lastActivity": DateTime.now()});
    } catch (e) {
      print("error $e");
    }
  }

  bool showHomeBool = false;
  @override
  Widget build(BuildContext context) {
    print("home build");

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new FloatingActionButton(
              key: _testKey,
              heroTag: "Add Test",
              backgroundColor: Colors.blue.shade100,
              onPressed: () => _userData.calendarToUse == ""
                  ? _showSettingsWarning()
                  : _showSettingsPanel(),
              tooltip: S.of(context).addTest,
              child: new FaIcon(FontAwesomeIcons.plusSquare),
            ),
            FloatingActionButton(
              key: _calendarKey,
              heroTag: "Calendar",
              tooltip: S.of(context).goToCalendar,
              child: FaIcon(FontAwesomeIcons.solidCalendar),
              backgroundColor: Colors.green.shade200,
              onPressed: _launchCalendar,
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Study Planner", style: Theme.of(context).textTheme.title),
        actions: <Widget>[
          IconButton(
            tooltip: S.of(context).tutorial,
            icon: FaIcon(FontAwesomeIcons.question),
            onPressed: () => _showTutorial(context),
          ),
          IconButton(
              tooltip: S.of(context).settings,
              key: _settingsKey,
              icon: FaIcon(
                FontAwesomeIcons.userCog,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              })
        ],
      ),
      body: _userData == null || _user == null
          ? CircularProgressIndicator()
          : Container(
              key: ValueKey("home"),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              child: TestList(),
            ),
    );
  }

  void _launchCalendar() async {
    try {
      const url = 'content://com.android.calendar/time/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e);
    }
  }

  void _showSettingsPanel() async {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(color: Colors.lightBlue.shade50),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SettingsForm(),
              ),
            ),
          );
        });
  }

  void _showTutorial(BuildContext context) async {
    await analytics.logTutorialBegin();

    TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.teal.shade200,
        textSkip: S.of(context).done,
        paddingFocus: 10,
        alignSkip: Alignment.bottomCenter,
        opacityShadow: 1, finish: () async {
      await analytics.logTutorialComplete();
    }, clickTarget: (target) {
      print(target);
    }, clickSkip: () async {
      await analytics.logEvent(name: "Main_Tutorial_Skipped");
    })
      ..show();
  }

  void _showSettingsWarning() async {
    await analytics.logEvent(name: "Settings_Warning_from_Home");
    TutorialCoachMark(context,
        targets: settings,
        colorShadow: Colors.teal.shade200,
        textSkip: S.of(context).done,
        paddingFocus: 10,
        opacityShadow: 1,
        alignSkip: Alignment.bottomCenter,
        finish: () async {}, clickTarget: (target) {
      print(target);
    }, clickSkip: () async {})
      ..show();
  }

  void initTargets() {
    targets.add(TargetFocus(
      identify: "Show Calendar",
      keyTarget: _calendarKey,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.of(context).goToCalendar,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      S.of(context).goToCalendarTut,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));

    targets.add(TargetFocus(
      identify: "Add Test",
      keyTarget: _testKey,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.of(context).addTest,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      S.of(context).addTestTut,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Settings",
      keyTarget: _settingsKey,
      contents: [
        ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.of(context).settings,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      S.of(context).settingsTut,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
    settings.add(TargetFocus(
      identify: "Settings_mandatory",
      keyTarget: _settingsKey,
      contents: [
        ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.of(context).settings,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      S.of(context).settingsWarning,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
  }
}
