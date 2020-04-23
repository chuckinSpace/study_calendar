import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:study_calendar/models/user_data.dart';
import 'package:study_calendar/screens/settings/calendarsList.dart';
import 'package:study_calendar/screens/settings/cutOffNumberPicker.dart';
import 'package:study_calendar/screens/settings/sweetNumberPicker.dart';
import 'package:study_calendar/services/auth.dart';
import 'package:study_calendar/services/database.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/target_focus.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  GlobalKey _showCalendarToUse = GlobalKey();
  GlobalKey _showCutOff = GlobalKey();
  GlobalKey _showSweet = GlobalKey();
  GlobalKey _showNightOwl = GlobalKey();
  bool _isCalendarExpanded = false;
  bool _isSweetExpanded = false;
  bool _isCutExpanded = false;
  List<TargetFocus> targets = List();

  void initState() {
    super.initState();
    initTargets();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserData>(context);
    bool _isCalendarSet = _userData.calendarToUse != "";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          IconButton(
            tooltip: "Show Tutorial",
            icon: FaIcon(FontAwesomeIcons.question),
            onPressed: () => _showTutorial(),
          ),
        ],
      ),
      body: _userData == null
          ? Container(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        margin: const EdgeInsets.all(10.0),
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ExpansionTile(
                              key: _showCalendarToUse,
                              onExpansionChanged: (bool expanding) => setState(
                                  () => _isCalendarExpanded = expanding),
                              children: [CalendarList()],
                              title: _isCalendarSet
                                  ? Text("Calendar to use",
                                      style: TextStyle(color: Colors.white))
                                  : Center(
                                      child: Text("SELECT A CALENDAR",
                                          style: TextStyle(color: Colors.red)),
                                    ),
                              leading: FaIcon(
                                _isCalendarSet
                                    ? FontAwesomeIcons.calendarAlt
                                    : FontAwesomeIcons.exclamationTriangle,
                                color: _isCalendarSet
                                    ? Colors.white
                                    : Colors.yellowAccent,
                              ),
                              trailing: FaIcon(
                                _isCalendarExpanded
                                    ? FontAwesomeIcons.chevronUp
                                    : FontAwesomeIcons.chevronDown,
                                color: Colors.white,
                              ),
                              subtitle: _isCalendarSet
                                  ? Text(_userData.calendarToUseName ?? "",
                                      style: TextStyle(color: Colors.white))
                                  : Text(""),
                            ),
                            _buildContainer(),
                            ExpansionTile(
                              key: _showSweet,
                              children: <Widget>[
                                SweetNumberPicker(),
                              ],
                              onExpansionChanged: (bool expanding) =>
                                  setState(() => _isSweetExpanded = expanding),
                              trailing: FaIcon(
                                _isSweetExpanded
                                    ? FontAwesomeIcons.chevronUp
                                    : FontAwesomeIcons.chevronDown,
                                color: Colors.white,
                              ),
                              title: Text("Sweet spot",
                                  style: TextStyle(color: Colors.white)),
                              leading: FaIcon(
                                FontAwesomeIcons.clock,
                                color: Colors.white,
                              ),
                            ),
                            _buildContainer(),
                            ExpansionTile(
                              key: _showCutOff,
                              children: <Widget>[
                                CutOffNumberPicker(),
                              ],
                              onExpansionChanged: (bool expanding) =>
                                  setState(() => _isCutExpanded = expanding),
                              trailing: FaIcon(
                                _isCutExpanded
                                    ? FontAwesomeIcons.chevronUp
                                    : FontAwesomeIcons.chevronDown,
                                color: Colors.white,
                              ),
                              title: Text("Cut Offs",
                                  style: TextStyle(color: Colors.white)),
                              leading: FaIcon(
                                FontAwesomeIcons.bed,
                                color: Colors.white,
                              ),
                            ),
                            _buildContainer(),
                            SwitchListTile(
                              key: _showNightOwl,
                              value: _userData?.nightOwl,
                              onChanged: (value) => DatabaseService()
                                  .updateDocument("users", _userData.uid,
                                      {"nightOwl": value}),
                              title: Text("Night Owl",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            _buildContainer(),
                            ListTile(
                              leading: FaIcon(FontAwesomeIcons.user,
                                  color: Colors.white),
                              trailing: IconButton(
                                  onPressed: () async {
                                    await AuthService().signOut();
                                    if (this.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: FaIcon(FontAwesomeIcons.signOutAlt,
                                      color: Colors.white)),
                              title: Text("Log Out",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Padding _buildContainer() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: double.infinity,
          height: 1.0,
          color: Colors.white60),
    );
  }

  void _showTutorial() async {
    /*  await _toTop(); */
    TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.red,
        textSkip: "QUIT",
        paddingFocus: 10,
        opacityShadow: 1, finish: () {
      print("finish");
    }, clickTarget: (target) {
      print(target);
    }, clickSkip: () {
      print("skip");
    })
      ..show();
  }

  void initTargets() {
    targets.add(TargetFocus(
      identify: "Calendars",
      keyTarget: _showCalendarToUse,
      contents: [
        ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Calendars",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "The most important part, select here which calendar you use, the list showing here are your device's current calendars. Study Planner will retrieve events from the calendar selected to check for availability,and also will write the tests and sessions created.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));

    targets.add(TargetFocus(
      identify: "Sweet Spot",
      keyTarget: _showSweet,
      contents: [
        ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Sweet Spot",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Set the perfect time for you to study, Study Planner will always try to set up sessions during these times as the first option.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Cut Off Times",
      keyTarget: _showCutOff,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Cut Off Times",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Study Planner will not accomodate any sessions before morning Cut off or after Night Cut off, usually used for bed time.\nHint: \nYou can use the morning cut off to take your classes into account!\nExample: Your classes end every day around 4pm, set the morning cut off to 4pm",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Night Owl",
      keyTarget: _showNightOwl,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Night Owl",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Select if you would rather have sessions later in the day (Night Owl). \nAfter Study Planner tried to allocate on the sweet spot, it will try later in the night if this option is active, otherwise will try earlier in the morning.",
                      style: TextStyle(color: Colors.white),
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
