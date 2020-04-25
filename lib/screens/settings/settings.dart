import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:study_calendar/generated/l10n.dart';
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
  UserData _userData;
  bool _isCalendarSet;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkTutorial(context));
  }

  @override
  void didChangeDependencies() async {
    _userData = Provider.of<UserData>(context);
    _isCalendarSet = _userData.calendarToUse != "";
    initTargets();
    await DatabaseService().setCalendars(_userData);
    super.didChangeDependencies();
  }

  void checkTutorial(BuildContext context) {
    if (_isCalendarSet != null &&
        !_isCalendarSet &&
        !_userData.isSettingsTutorialSeen) {
      _showTutorial(context);
      DatabaseService().updateDocument(
          "users", _userData.uid, {"isSettingsTutorialSeen": true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).settings,
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          IconButton(
            tooltip: S.of(context).settings,
            icon: FaIcon(FontAwesomeIcons.question),
            onPressed: () => _showTutorial(context),
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
                                  ? Text(S.of(context).calendarToUse,
                                      style: TextStyle(color: Colors.white))
                                  : Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: AutoSizeText(
                                            S.of(context).selectACalendar,
                                            maxLines: 1,
                                            minFontSize: 15,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    ),
                              leading: FaIcon(
                                _isCalendarSet
                                    ? FontAwesomeIcons.calendarAlt
                                    : FontAwesomeIcons.exclamationTriangle,
                                color: _isCalendarSet
                                    ? Colors.white
                                    : Colors.yellow.shade200,
                                size: 25,
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
                              title: Text(S.of(context).sweetSpot,
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
                              title: Text(S.of(context).cutOff,
                                  style: TextStyle(color: Colors.white)),
                              leading: FaIcon(
                                FontAwesomeIcons.bed,
                                color: Colors.white,
                              ),
                            ),
                            _buildContainer(),
                            SwitchListTile(
                              key: _showNightOwl,
                              value: _userData.nightOwl ?? true,
                              onChanged: (value) {
                                if (_userData != null) {
                                  print("in night owl");
                                  DatabaseService().updateDocument("users",
                                      _userData.uid, {"nightOwl": value});
                                }
                              },
                              title: Text(S.of(context).nightOwl,
                                  style: TextStyle(color: Colors.white)),
                            ),
                            /*  _buildContainer(),
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
                              title: Text(
                                S.of(context).logOut,
                                style: TextStyle(color: Colors.white),
                              ),
                            ), */
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

  void _showTutorial(BuildContext context) async {
    TutorialCoachMark(context,
        targets: targets,
        alignSkip: Alignment.bottomCenter,
        colorShadow: Colors.red,
        textSkip: S.of(context).done,
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
                    S.of(context).sweetSpot,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      S.of(context).sweetSpotTut,
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
                    S.of(context).cutOff,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      S.of(context).cutOffTut,
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
                    S.of(context).nightOwl,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      S.of(context).nightOwlTut,
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
                    S.of(context).calendars,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      S.of(context).calendarsTut,
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
